#!/bin/bash

AUTHOR_TITLE="iOS Template Generator bY @Carmudii"

# Function to add a line above a marker in a file
add_line_above_marker() {
    local line_to_add="$1"
    local file_path="$2"
    local marker="__FLAG_DEPENDENCIES_AUTO_ADD__"

    # Check if the file exists
    if [ ! -f "$file_path" ]; then
        echo -e "\033[31mError: File '$file_path' not found.\033[0m"
        exit 1
    fi

    # Replace the marker in the file
    if grep -q "$marker" "$file_path"; then
        sed -i '' "/$marker/i\\
$line_to_add
" "$file_path"
        echo -e "\033[32mDependencies added successfully.\033[0m"
    else
        echo -e "\033[31mError: '$marker' not found in $file_path.\033[0m"
        exit 1
    fi
}

# Function to recursively rename files and folders and replace placeholders
rename_files_and_folders() {
    local project_type="$1"
    local directory="$2"
    local project_name="$3"
    local module_prefix="$4"
    local package_name="$5"

    # Replacing Project Target
    # give yello color
    echo -e "\033[33mRenaming files and folders in $directory\033[0m"
    if [ "$project_type" == "2" ]; then
        # Replace placeholders
        LC_ALL=C find "$directory" -depth -type f -exec sed -i '' -e "s/__PACKAGE__/$package_name/g" {} \;
        LC_ALL=C find "$directory" -depth -type f -exec sed -i '' -e "s/__MODULE_PREFIX__/$module_prefix/g" {} \;
        
        # Rename folders and replace placeholders
        find "$directory" -depth -type d -name "*__PACKAGE__*" -execdir bash -c 'mv "$0" "${0//__PACKAGE__/$1}"' {} "$package_name" \;
        find "$directory" -depth -type d -name "*__MODULE_PREFIX__*" -execdir bash -c 'mv "$0" "${0//__MODULE_PREFIX__/$1}"' {} "$module_prefix" \;
        LC_ALL=C find "$directory" -d -name "__MODULE_CLASS_PREFIX__*" -type f -exec sh -c '$0 $1 ${1/__MODULE_CLASS_PREFIX__/$2}' mv {} "$module_prefix" \;

        return
    fi

    # Replace placeholders
    LC_ALL=C find "$directory" -depth -type f -exec sed -i '' -e "s/__TEMPLATE__/$project_name/g" {} \;
    LC_ALL=C find "$directory" -depth -type f -exec sed -i '' -e "s/__PACKAGE__/$package_name/g" {} \;
    LC_ALL=C find "$directory" -depth -type f -exec sed -i '' -e "s/__MODULE_PREFIX__/$module_prefix/g" {} \;

    # Rename folders and replace placeholders
    find "$directory" -depth -type d -name "*__TEMPLATE__*" -execdir bash -c 'mv "$0" "${0/__TEMPLATE__/$1}"' {} "$project_name" \;
    find "$directory" -depth -type d -name "*__PACKAGE__*" -execdir bash -c 'mv "$0" "${0/__PACKAGE__/$1}"' {} "$package_name" \;
    find "$directory" -depth -type d -name "*__MODULE_PREFIX__*" -execdir bash -c 'mv "$0" "${0/__MODULE_PREFIX__/$1}"' {} "$module_prefix" \;
    LC_ALL=C find "$directory" -d -name "__MODULE_CLASS_PREFIX__*" -type f -exec sh -c '$0 $1 ${1/__MODULE_CLASS_PREFIX__/$2}' mv {} "$module_prefix" \;
    LC_ALL=C find "$directory" -d -name "__CLASS_TEMPLATE__*" -type f -exec sh -c '$0 $1 ${1/__CLASS_TEMPLATE__/$2}' mv {} "$module_prefix" \;
}

# Function to display a dialog box with a message
show_dialog() {
    local message="$1"
    local result
    result=$(osascript -e "display dialog \"$message\" buttons {\"OK\", \"Cancel\"} default button \"OK\" cancel button \"Cancel\" with title \"$AUTHOR_TITLE\"")
    
    # Check the result to see if the user clicked "Cancel"
    if [[ "$result" =~ "OK" ]]; then
        echo 1
    else
        echo 0
    fi
}

# Function to display a dialog box for user input
get_input() {
    local prompt="$1"
    local default="$2"
    local result
    result=$(osascript <<EOF
set userInput to text returned of (display dialog "$prompt" default answer "$default" buttons {"Cancel", "OK"} default button "OK" with title "$AUTHOR_TITLE")
return userInput
EOF
)
    if [[ "$result" == "false" ]]; then
        exit 0
    else
        echo "$result"
    fi
}

# Function to display a dialog box for selection type
get_selection_input() {
    local prompt="$1"
    local options=("$2" "$3")
    local default="$4"
    local result
    result=$(osascript <<EOF
set selectedOption to choose from list {"${options[0]}", "${options[1]}"} with prompt "$prompt" default items {"$default"} without multiple selections allowed and empty selection allowed with title "$AUTHOR_TITLE"
if selectedOption is {"${options[0]}"} then
    return "1"
else if selectedOption is {"${options[1]}"} then
    return "2"
else
    return "false"
end if
EOF
)
    if [[ "$result" == "false" ]]; then
        exit 0
    else
        echo "$result"
    fi
}

# Function to open file in Finder
open_finder() {
    local path=$(osascript <<EOF
        tell application "Finder"
                    set chosenFolder to choose folder with prompt "Select the path to save your new iOS project:"
                    if chosenFolder is not equal to false then
                return POSIX path of (chosenFolder as text)
            else
                return "false"
            end if
        end tell
EOF
)
    echo "$path"
}

# Main function
main() {
    # Choose project type
    local PROJECT_TYPE=$(get_selection_input "Select project type:" "iOS Project" "iOS Module" "iOS Project")

    # Determine template name based on the user's PROJECT_TYPE
    local TEMPLATE_NAME
    if [ "$PROJECT_TYPE" == "1" ]; then
        TEMPLATE_NAME="Project"
    elif [ "$PROJECT_TYPE" == "2" ]; then
        TEMPLATE_NAME="Module"
    else
        echo -e "\033[31mInvalid choice. Please select 'iOS Project' or 'iOS Module'.\033[0m"
        exit 1
    fi

    # Check if template exists and is not empty
    local TEMPLATES_DIR="$(dirname "$(readlink -f "$0")")/templates"
    local TEMPLATE_DIR="$TEMPLATES_DIR/$TEMPLATE_NAME"

    if [ ! -d "$TEMPLATE_DIR" ]; then
        echo -e "\033[31mError: Template '$TEMPLATE_NAME' not found\033[0m"
        exit 1
    elif [ -z "$(ls -A "$TEMPLATE_DIR")" ]; then
        echo -e "\033[31mError: Template '$TEMPLATE_NAME' is empty.\033[0m"
        exit 1
    fi

    # Prompt for project details
    local PROJECT_PATH
    local PACKAGE_NAME
    local PROJECT_NAME
    local MODULE_PREFIX
    if [ "$PROJECT_TYPE" == "1" ]; then
        # Show dialog box to get project details
        RESULT=$(show_dialog "Open finder to choose the path to save your new iOS project.")
        if [[ $RESULT -eq 0 ]]; then
            main
        fi

        # Get project details using AppleScript
        PROJECT_PATH=$(open_finder)
        # Validate project path
        if [ "$PROJECT_PATH" == "false" ]; then
            exit 0
        elif [ -z "$PROJECT_PATH" ]; then
            echo -e "\033[31mError: Project path cannot be empty.\033[0m"
            exit 1
        elif [ ! -d "$PROJECT_PATH" ]; then
            echo -e "\033[31mError: Invalid project path.\033[0m"
            exit 1
        fi

        echo -e "\033[32mProject path: $PROJECT_PATH\033[0m"

        PACKAGE_NAME=$(get_input "Enter the package name, following reverse-domain style convention:" "")
        echo -e "\033[33mPACKAGE_NAME -> $PACKAGE_NAME\033[0m"

        # Validate package name
        if [ -z "$PACKAGE_NAME" ]; then
            echo -e "\033[31mError: Package name cannot be empty.\033[0m"
            exit 1
        elif [[ ! "$PACKAGE_NAME" =~ ^[a-zA-Z_][a-zA-Z0-9_]*\.[a-zA-Z_][a-zA-Z0-9_]*(\.[a-zA-Z_][a-zA-Z0-9_]*)*$ ]]; then
            echo -e "\033[31mError: Invalid package name format. It should follow reverse-domain style convention.\033[0m"
            exit 1
        fi

        PROJECT_NAME=$(get_input "Enter the project name:" "")
        echo -e "\033[33mPROJECT_NAME -> $PROJECT_NAME\033[0m"
        # Validate project name
        if [ -z "$PROJECT_NAME" ]; then
            echo -e "\033[31mError: Project name cannot be empty.\033[0m"
            exit 1
        fi

        MODULE_PREFIX=$(get_input "Enter the module prefix:" "")
        echo -e "\033[33mMODULE_PREFIX -> $MODULE_PREFIX\033[0m"
        # Validate module prefix
        if [ -z "$MODULE_PREFIX" ]; then
            echo -e "\033[31mError: Class prefix cannot be empty.\033[0m"
            exit 1
        fi
    elif [ "$PROJECT_TYPE" == "2" ]; then
        # Show dialog box to get project details
        RESULT=$(show_dialog "Open finder to choose the path to save your new iOS module project.")
        if [[ $RESULT -eq 0 ]]; then
            main
        fi

        # Get project details
        PROJECT_PATH=$(open_finder)
        # Validate project path
        if [ -z "$PROJECT_PATH" ]; then
            exit 0
        fi

        PACKAGE_NAME=$(get_input "Enter the package name, following reverse-domain style convention:" "")
        # Validate package name
        if [ -z "$PACKAGE_NAME" ]; then
            echo -e "\033[31mError: Package name cannot be empty.\033[0m"
            exit 1
        elif [[ ! "$PACKAGE_NAME" =~ ^[a-zA-Z_][a-zA-Z0-9_]*\.[a-zA-Z_][a-zA-Z0-9_]*(\.[a-zA-Z_][a-zA-Z0-9_]*)*$ ]]; then
            echo -e "\033[31mError: Invalid package name format. It should follow reverse-domain style convention.\033[0m"
            exit 1
        fi

        MODULE_PREFIX=$(get_input "Enter the module prefix:" "")
        # Validate module prefix
        if [ -z "$MODULE_PREFIX" ]; then
            echo -e "\033[31mError: Class prefix cannot be empty.\033[0m"
            exit 1
        elif [ -e "$PROJECT_PATH/$MODULE_PREFIX" ]; then
            echo -e "\033[31mError: $MODULE_PREFIX already exists.\033[0m"
            exit 1
        fi
    fi

    # Copy the template files
    cp -r "$TEMPLATE_DIR"/* "$PROJECT_PATH" || exit 1

    # Rename files and folders
    rename_files_and_folders "$PROJECT_TYPE" "$PROJECT_PATH" "$PROJECT_NAME" "$MODULE_PREFIX" "$PACKAGE_NAME"

    if [ "$PROJECT_TYPE" == "2" ]; then
        # Define the variable value
        local LINE_TO_ADD='modulesDependencies.merge(addTarget(self, "./Modules/__MODULE__"))'

        # Define the placeholder to replace
        local placeholder='__MODULE__'

        # Replace the placeholder with the replacement value
        LINE_TO_ADD="${LINE_TO_ADD//$placeholder/$MODULE_PREFIX}"
        add_line_above_marker "$LINE_TO_ADD" "$PROJECT_PATH../Podfile"    
    fi

    if command -v pod &> /dev/null; then
        [[ "$PROJECT_TYPE" == "2" ]] && cd "$PROJECT_PATH../" && pod install || cd "$PROJECT_PATH" && pod install
    fi

    echo -e "\033[32mProject setup completed.\033[0m"
}

# Call the main function
main