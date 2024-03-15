Write-Output "Starting Phase 5a - Generalize and prepare sysprep scripts"
New-Item -Path 'C:\Windows\Setup\Scripts' -ItemType Directory -Force

# Initialize variable to check if Guest Additions are installed
$vboxGuestInstalled = $false

# Function to install VirtualBox Guest Additions
function Install-VBoxGuestAdditions {
    param (
        [string]$driveLetter
    )
    $installerPath = "${driveLetter}:\VBoxWindowsAdditions.exe"
    if (Test-Path $installerPath) {
        Write-Host "Found VBoxWindowsAdditions.exe at $installerPath"
        Write-Host "Installing Virtualbox Guest Additions from $installerPath"
        & $installerPath /S
        if ($?) {
            Write-Host "Installation successful. Sleeping for 60 seconds to ensure completion."
            Start-Sleep -s 60
            $global:vboxGuestInstalled = $true
        } else {
            Write-Output "Error occurred during installation from $installerPath."
        }
    } else {
        Write-Output "VBoxWindowsAdditions.exe not found at $installerPath"
    }
}




# Enumerate all drives and attempt to install Guest Additions from the first match
Get-PSDrive -PSProvider 'FileSystem' | ForEach-Object {
    if (-not $vboxGuestInstalled) {
        Install-VBoxGuestAdditions -driveLetter $_.Name
    }
    $vboxGuestInstalled=$true
}



Write-Output "Ending Phase 5a - Generalize and prepare sysprep scripts"
if ($vboxGuestInstalled) {
    Write-Output "Virtualbox Guest Additions installed successfully."
    exit 0
} else {
    Write-Output "Virtualbox Guest Addition installation failed - exiting."
    exit -1
}
