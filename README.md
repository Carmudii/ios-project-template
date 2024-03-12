# Bash Script for Project Setup

This script automates the setup process for iOS projects and modules by renaming files, folders, and replacing placeholders in template files. It also adds dependencies to the Podfile for modules.

## Usage

1. Make sure you have Bash installed on your system.
2. Clone this repository or copy the script content into a new file.
3. Run the script using the following command:

./generate.sh

## Functions

### add_line_above_marker()

This function adds a line above a specified marker in a file. It is used to add dependencies to the Podfile for iOS modules.

### rename_files_and_folders()

This function recursively renames files and folders and replaces placeholders in template files based on the provided project details.

## Instructions

1. When prompted, select the project type: iOS Project or iOS Module.
2. Provide the necessary project details such as project path, package name, project name, and module prefix.
3. Wait for the script to complete the setup process.

## Important Notes

- Ensure that the script file has executable permissions.
- Make sure to provide valid input when prompted to avoid errors during setup.
- If you're setting up an iOS module, dependencies will be added to the Podfile automatically.

## License

This script is licensed under the MIT License. See the LICENSE file for details.
