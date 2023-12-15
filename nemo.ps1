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

# SIG # Begin signature block
# MIIFggYJKoZIhvcNAQcCoIIFczCCBW8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU4AEtazY7QfRcc5IgWdM8hTgA
# MSqgggMWMIIDEjCCAfqgAwIBAgIQLOXnTOrsfbtMi7849WAAizANBgkqhkiG9w0B
# AQsFADAhMR8wHQYDVQQDDBZDSEVTSS1Db2RlU2lnbi1KRC0yMDI0MB4XDTIzMTEx
# OTE5NDEzOVoXDTI0MTExOTIwMDEzOVowITEfMB0GA1UEAwwWQ0hFU0ktQ29kZVNp
# Z24tSkQtMjAyNDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPLupOwP
# zQtFN22nZD29Yqkuqwb5LXLJaxVJzWF38sns0Rax7Fr6haZNxmbVmZw4SWhvYDes
# jR98yXqjMELpvt3ZEhccopEm8LmF1mjGvHBIhD9bya6NbDqv8RyIym6DanS72KQi
# ezYcvhGKc3pDIkyIYGWSjDSnLjAFUxqhgWwhVGjqStjoJNl3p0qI9U/Pd+a2INys
# TfiTsaQ8eQhqVkc7w0hBulq46QgqcnbTmqtwhJGyMsej47DND9IfqULB42xmtDDa
# XfzQQdq6GU5vINm+2h0Gv5iLKmjSZjOG+/7FzgNBxaPC0Z07dGGzxzEm40mw/ufe
# gki02fPb4prDKg0CAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoG
# CCsGAQUFBwMDMB0GA1UdDgQWBBTbV2TSWoTH1WlvUao+edP/mlTetDANBgkqhkiG
# 9w0BAQsFAAOCAQEASFqUcORM/DGlMCGom0Om+WYZAcv+7haMd3RKIvM3ApsM0HOG
# CGYkQjVchY1pDlBE+hN14WiskS4sHi+BwrMQcqmMKbDdn6gdCnR/hJ8d1Vn+/ikS
# R7X0kqvUdvrEjSscHv+KwIK4zpYvne+4zLUTQaYC13SrlakuezjxJQcNr78qeEXT
# JoIqQmp54Lbw6nIyHAVz+L2IxSUWZOBth383J2FZXjH31CRhLLTwGzE7dyW4cDPj
# MolWgY0BfNTlIj9+s1a0rj3T2s2UiNsjSQnwuwtTsQozH6MS6o6RnxP2XeNl1fOc
# 4dTS7Wh7Hu95i9J+5A9AVSfvXPqnPiTcQB4JvzGCAdYwggHSAgEBMDUwITEfMB0G
# A1UEAwwWQ0hFU0ktQ29kZVNpZ24tSkQtMjAyNAIQLOXnTOrsfbtMi7849WAAizAJ
# BgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0B
# CQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAj
# BgkqhkiG9w0BCQQxFgQUUXde9+PLUNtrWv49zEwj7C1Kp/owDQYJKoZIhvcNAQEB
# BQAEggEA798CQm7DGKKlaChhoBG70uzeUnJXJvgDNkjydEeHJj9vxtdFreK2nmUz
# D3/BlQ+NnyicHaZjJhMb04x3/bQvjNe3cCFQzuh6D/Hwj7wHKnixjbQvg81jD/Po
# DoPmyVcPPg5uRbTj38dJkIbfD7aWJ+QtU40NA+vgYJSO9+PsCoblmXtanjwhyJkW
# 5HVjwLsW3EUjaNUTjBliekSv4L8ZBPK6Ezac9fcx+NgSm2i+3pQeIDu9+uRW6m/3
# BdJ8+348Fmp+WVqnLQAxjQFiJIViwjX5OFxNPBj39H4tXAj6alJGy6N2At4/MFhl
# 00rgNt4mc/7QPMM9IhsqLzgl4TngPQ==
# SIG # End signature block
