#!/bin/bash

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
    # echo -e "\033[33mRenaming files and folders in $directory\033[0m"
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
    find "$directory" -depth -type d -name "*__TEMPLATE__*" -execdir bash -c 'mv "$0" "${0//__TEMPLATE__/$1}"' {} "$project_name" \;
    find "$directory" -depth -type d -name "*__PACKAGE__*" -execdir bash -c 'mv "$0" "${0//__PACKAGE__/$1}"' {} "$package_name" \;
    find "$directory" -depth -type d -name "*__MODULE_PREFIX__*" -execdir bash -c 'mv "$0" "${0//__MODULE_PREFIX__/$1}"' {} "$module_prefix" \;
    LC_ALL=C find "$directory" -d -name "__MODULE_CLASS_PREFIX__*" -type f -exec sh -c '$0 $1 ${1/__MODULE_CLASS_PREFIX__/$2}' mv {} "$module_prefix" \;
    LC_ALL=C find "$directory" -d -name "__CLASS_TEMPLATE__*" -type f -exec sh -c '$0 $1 ${1/__CLASS_TEMPLATE__/$2}' mv {} "$module_prefix" \;
}

# Prompt for project type selection
echo "Select project type:"
echo "1. iOS Project"
echo "2. iOS Module"
read -p "Enter your choice: " CHOICE

# Determine template name based on the user's choice
if [ "$CHOICE" == "1" ]; then
    TEMPLATE_NAME="Project"
elif [ "$CHOICE" == "2" ]; then
    TEMPLATE_NAME="Module"
else
    echo -e "\033[31mInvalid choice. Please select 1 or 2.\033[0m"
    exit 1
fi

# Check if template exists and is not empty
TEMPLATES_DIR="$(dirname "$(readlink -f "$0")")/templates"
TEMPLATE_DIR="$TEMPLATES_DIR/$TEMPLATE_NAME"

if [ ! -d "$TEMPLATE_DIR" ]; then
    echo -e "\033[31mError: Template '$TEMPLATE_NAME' not found\033[0m"
    exit 1
elif [ -z "$(ls -A "$TEMPLATE_DIR")" ]; then
    echo -e "\033[31mError: Template '$TEMPLATE_NAME' is empty.\033[0m"
    exit 1
fi

# Prompt for project details
if [ "$CHOICE" == "1" ]; then

    # Get project details
    echo -e "1. Enter the path to save your new iOS project:"
    read -p "> " PROJECT_PATH
    # Validate project path
    if [ -z "$PROJECT_PATH" ]; then
        echo -e "\033[31mError: Project path cannot be empty.\033[0m"
        exit 1
    elif [ -e "$PROJECT_PATH" ]; then
        echo -e "\033[31mError: $PROJECT_PATH already exists.\033[0m"
        exit 1
    fi

    # Create project directory if it doesn't exist
    mkdir -p "$PROJECT_PATH" || exit 1

    echo -e "2. Enter the package name, following reverse-domain style convention:"
    read -p "> " PACKAGE_NAME
    # Validate package name
    if [ -z "$PACKAGE_NAME" ]; then
        echo -e "\033[31mError: Package name cannot be empty.\033[0m"
        exit 1
    elif [[ ! "$PACKAGE_NAME" =~ ^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)*$ ]]; then
        echo -e "\033[31mError: Invalid package name format. It should follow reverse-domain style convention.\033[0m"
        exit 1
    fi

    echo -e "3. Enter the project name:"
    read -p "> " PROJECT_NAME
    # Validate project name
    if [ -z "$PROJECT_NAME" ]; then
        echo -e "\033[31mError: Project name cannot be empty.\033[0m"
        exit 1
    fi

    echo -e "4. Enter the module prefix:"
    read -p "> " MODULE_PREFIX
    # Validate module prefix
    if [ -z "$MODULE_PREFIX" ]; then
        echo -e "\033[31mError: Class prefix cannot be empty.\033[0m"
        exit 1
    fi
elif [ "$CHOICE" == "2" ]; then
    # Get project details
    echo -e "1. Enter the path to save your iOS module project:"
    read -p "> " PROJECT_PATH
    # Validate project path
    if [ -z "$PROJECT_PATH" ]; then
        echo -e "\033[31mError: Project path cannot be empty.\033[0m"
        exit 1
    fi

    # Create project directory if it doesn't exist
    mkdir -p "$PROJECT_PATH" || exit 1

    echo -e "2. Enter the package name, following reverse-domain style convention:"
    read -p "> " PACKAGE_NAME
    # Validate package name
    if [ -z "$PACKAGE_NAME" ]; then
        echo -e "\033[31mError: Package name cannot be empty.\033[0m"
        exit 1
    elif [[ ! "$PACKAGE_NAME" =~ ^[a-zA-Z_][a-zA-Z0-9_]*\.[a-zA-Z_][a-zA-Z0-9_]*(\.[a-zA-Z_][a-zA-Z0-9_]*)*$ ]]; then
        echo -e "\033[31mError: Invalid package name format. It should follow reverse-domain style convention.\033[0m"
        exit 1
    fi

    echo -e "3. Enter the module prefix:"
    read -p "> " MODULE_PREFIX
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
rename_files_and_folders "$CHOICE" "$PROJECT_PATH" "$PROJECT_NAME" "$MODULE_PREFIX" "$PACKAGE_NAME"

if [ "$CHOICE" == "2" ]; then
    # Define the variable value
    LINE_TO_ADD='modulesDependencies.merge(addTarget(self, "./Modules/__MODULE__"))'

    # Define the placeholder to replace
    placeholder='__MODULE__'

    # Replace the placeholder with the replacement value
    LINE_TO_ADD="${LINE_TO_ADD//$placeholder/$MODULE_PREFIX}"
    add_line_above_marker "$LINE_TO_ADD" "$PROJECT_PATH/../Podfile"    
fi

if command -v pod &> /dev/null; then
    [[ "$CHOICE" == "2" ]] && cd "$PROJECT_PATH/../" && pod install || cd "$PROJECT_PATH" && pod install
fi

echo -e "\033[32mProject setup completed.\033[0m"