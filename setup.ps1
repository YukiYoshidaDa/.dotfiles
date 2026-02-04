# Windows integrated setup script (Entry Point)

# 0. Check for Administrator Privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (!$isAdmin) {
    Write-Warning "This script is not running as Administrator. Symbolic link creation may fail unless Developer Mode is enabled."
}

# 1. Run Installation (System Dependencies)
Write-Host "--- 1. Running Installation Script (System) ---" -ForegroundColor Cyan
& "$PSScriptRoot\windows\install.ps1"

# 2. Refresh Environment Variables
Write-Host "`n--- 2. Refreshing Environment Variables ---" -ForegroundColor Cyan
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
Write-Host "Path refreshed."

# 3. Run Linker (Symlinks)
Write-Host "`n--- 3. Running Linking Script ---" -ForegroundColor Cyan
& "$PSScriptRoot\scripts\link.ps1"

# 4. Run VS Code Setup (Extensions)
Write-Host "`n--- 4. Running VS Code Setup ---" -ForegroundColor Cyan
& "$PSScriptRoot\vscode\install_extensions.ps1"

Write-Host "`nAll setup steps completed successfully!" -ForegroundColor Green
