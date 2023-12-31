# Nemo v1.2 - Search and Replace Tool

Nemo v1.2 is an enhanced PowerShell script with a graphical user interface (GUI) for searching and replacing text within files of specific programming and scripting file types in a selected directory. It provides a user-friendly and more efficient way to perform bulk text replacements across multiple files.

## Features

- User-friendly GUI for easy interaction.
- Directory browsing to select the target folder.
- Options to specify search and replace text.
- Dropdown menu to choose from a list of common programming and scripting file extensions.
- Real-time processing feedback.
- Improved usability with keyboard navigation in dropdowns.

## Prerequisites

- Windows operating system.
- PowerShell 5.1 or higher.

## Installation

No installation is required. The script can be run directly in PowerShell.

## Usage

1. **Running the Script**:
   - Right-click on `Nemo.ps1` and select "Run with PowerShell".
   - The GUI will appear for interaction.

2. **Using the Application**:
   - **Select Directory**: Use the "Browse" button to choose the directory containing files you want to process.
   - **Search For**: Enter the text string you want to find in the files.
   - **Replace With**: Enter the replacement text.
   - **File Extension**: Use the dropdown to select a specific file extension (e.g., 'py', 'txt'). 
   - Click "Process" to start the operation.

3. **Output**:
   - The application will display real-time processing status in the PowerShell console.
   - A message box will appear upon completion.

## Notes

- Ensure that the directory and file types you are processing do not contain critical or non-editable files, as changes are irreversible.
- The application is optimized for plain text files. Binary files or documents with complex formatting (like Word or PDF files) are not recommended.
- Always backup important files before performing bulk operations.

## Troubleshooting

- If the script does not execute, ensure that PowerShell execution policies allow running scripts. You might need to run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned` in PowerShell as an administrator.
- For any issues related to file access or permissions, make sure the files are not read-only and your user account has the necessary permissions.

## License

This project is licensed under the GNU General Public License v3.0 - see the [GPLv3 License](https://www.gnu.org/licenses/gpl-3.0.en.html) for details.

## Author

- Created by Joshua Dwight

## Version

- Nemo v1.2

---

This README provides a comprehensive guide for users to understand, install, and use the Nemo v1.2 PowerShell tool. You can add it to your project repository or distribute it along with your script.
