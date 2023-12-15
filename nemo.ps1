Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

# Window dimensions
$windowWidth = 500 # Increased window width
$windowHeight = 325

function Select-FolderDialog {
    param ([string]$Description="Select Folder",[string]$RootFolder="Desktop")

    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = $Description
    $dialog.RootFolder = $RootFolder
    $result = $dialog.ShowDialog()

    if ($result -eq "OK") {
        $dialog.SelectedPath
    } else {
        ""
    }
}

function Process-Files {
    $directory = $textboxDirectory.Text
    $searchStr = $textboxSearch.Text
    $replaceStr = $textboxReplace.Text
    $extension = $textboxExtension.Text.TrimStart('.') # Remove leading dot
    $ignoreExt = $checkboxIgnoreExt.Checked

    if (-not [string]::IsNullOrWhiteSpace($directory) -and -not [string]::IsNullOrWhiteSpace($searchStr) -and -not [string]::IsNullOrWhiteSpace($replaceStr)) {
        Get-ChildItem -Path $directory -Recurse -File | ForEach-Object {
            if (-not $ignoreExt -and $_.Extension.ToLower() -ne ".$extension".ToLower()) {
                return
            }

            try {
                $content = Get-Content $_.FullName -Raw
                if ($content -match [regex]::Escape($searchStr)) {
                    $content -replace [regex]::Escape($searchStr), $replaceStr | Set-Content $_.FullName
                    Write-Host "Replaced in file: $($_.FullName)"
                } else {
                    Write-Host "No match in file: $($_.FullName)"
                }
            }
            catch {
                Write-Host "Error processing file: $($_.FullName) - $_"
            }
        }

        [System.Windows.Forms.MessageBox]::Show("Processing complete", "Nemo v1.1")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please fill in all required fields", "Error")
    }
}

# Main window
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Nemo v1.1 by Joshua Dwight'
$form.Size = New-Object System.Drawing.Size($windowWidth, $windowHeight)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# Directory input
$labelDirectory = New-Object System.Windows.Forms.Label
$labelDirectory.Location = New-Object System.Drawing.Point(10,20)
$labelDirectory.Size = New-Object System.Drawing.Size(280,20)
$labelDirectory.Text = "Directory:"
$form.Controls.Add($labelDirectory)

$textboxDirectory = New-Object System.Windows.Forms.TextBox
$textboxDirectory.Location = New-Object System.Drawing.Point(10,40)
$textboxDirectory.Size = New-Object System.Drawing.Size(360,20) # Increased width
$form.Controls.Add($textboxDirectory)

$buttonBrowse = New-Object System.Windows.Forms.Button
$buttonBrowse.Location = New-Object System.Drawing.Point(380,38)
$buttonBrowse.Size = New-Object System.Drawing.Size(100,23)
$buttonBrowse.Text = "Browse"
$buttonBrowse.Add_Click({$textboxDirectory.Text = Select-FolderDialog})
$form.Controls.Add($buttonBrowse)

# Search string input
$labelSearch = New-Object System.Windows.Forms.Label
$labelSearch.Location = New-Object System.Drawing.Point(10,70)
$labelSearch.Size = New-Object System.Drawing.Size(280,20)
$labelSearch.Text = "Search For:"
$form.Controls.Add($labelSearch)

$textboxSearch = New-Object System.Windows.Forms.TextBox
$textboxSearch.Location = New-Object System.Drawing.Point(10,90)
$textboxSearch.Size = New-Object System.Drawing.Size(470,20) # Increased width
$form.Controls.Add($textboxSearch)

# Replace string input
$labelReplace = New-Object System.Windows.Forms.Label
$labelReplace.Location = New-Object System.Drawing.Point(10,120)
$labelReplace.Size = New-Object System.Drawing.Size(280,20)
$labelReplace.Text = "Replace With:"
$form.Controls.Add($labelReplace)

$textboxReplace = New-Object System.Windows.Forms.TextBox
$textboxReplace.Location = New-Object System.Drawing.Point(10,140)
$textboxReplace.Size = New-Object System.Drawing.Size(470,20) # Increased width
$form.Controls.Add($textboxReplace)

# Extension input
$labelExtension = New-Object System.Windows.Forms.Label
$labelExtension.Location = New-Object System.Drawing.Point(10,170)
$labelExtension.Size = New-Object System.Drawing.Size(280,20)
$labelExtension.Text = "File Extension:"
$form.Controls.Add($labelExtension)

$textboxExtension = New-Object System.Windows.Forms.TextBox
$textboxExtension.Location = New-Object System.Drawing.Point(10,190)
$textboxExtension.Size = New-Object System.Drawing.Size(470,20) # Increased width
$form.Controls.Add($textboxExtension)

# Ignore extension checkbox
$checkboxIgnoreExt = New-Object System.Windows.Forms.CheckBox
$checkboxIgnoreExt.Location = New-Object System.Drawing.Point(10,220)
$checkboxIgnoreExt.Size = New-Object System.Drawing.Size(280,20)
$checkboxIgnoreExt.Text = "Ignore Extension"
$form.Controls.Add($checkboxIgnoreExt)

# Process button
$buttonProcess = New-Object System.Windows.Forms.Button
$buttonProcess.Location = New-Object System.Drawing.Point(10,250)
$buttonProcess.Size = New-Object System.Drawing.Size(470,23) # Adjusted to fit new window width
$buttonProcess.Text = "Process"
$buttonProcess.Add_Click({Process-Files})
$form.Controls.Add($buttonProcess)

# Show form
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
