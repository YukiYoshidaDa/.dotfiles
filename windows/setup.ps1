# Windows integrated setup script for dotfiles (Robust Version)

# 0. Check for Administrator Privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (!$isAdmin) {
    Write-Warning "This script is not running as Administrator. Symbolic link creation may fail unless Developer Mode is enabled."
}

$DotfilesDir = Split-Path $PSScriptRoot -Parent
$VscodeConfigDir = "$env:APPDATA\Code\User"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# 1. Run Scoop app installation
Write-Host "--- 1. Installing Apps via Scoop ---" -ForegroundColor Cyan
& "$PSScriptRoot\install_apps.ps1"

# 2. Refresh Environment Variables (to recognize newly installed 'code' command)
Write-Host "`n--- 2. Refreshing Environment Variables ---" -ForegroundColor Cyan
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
Write-Host "Path refreshed."

# 3. Link VS Code settings
Write-Host "`n--- 3. Setting up VS Code Configuration (Symbolic Links) ---" -ForegroundColor Cyan
if (!(Test-Path $VscodeConfigDir)) {
    New-Item -ItemType Directory -Path $VscodeConfigDir -Force
}

$vscodeFiles = @("settings.json", "keybindings.json")
foreach ($file in $vscodeFiles) {
    $src = Join-Path $DotfilesDir "vscode\$file"
    $dest = Join-Path $VscodeConfigDir $file

    if (Test-Path $src) {
        # Backup existing file if it's not already a link to our source
        if (Test-Path $dest) {
            $existingTarget = (Get-Item $dest).Target
            if ($existingTarget -eq $src) {
                Write-Host "Already linked: $file" -ForegroundColor Gray
                continue
            }

            Write-Host "Backing up existing $file to ${file}.${Timestamp}.bak" -ForegroundColor Yellow
            Move-Item $dest "${dest}.${Timestamp}.bak" -Force
        }

        # Create Symbolic Link
        try {
            New-Item -ItemType SymbolicLink -Path $dest -Target $src -Force | Out-Null
            Write-Host "Created symbolic link for $file" -ForegroundColor Green
        } catch {
            Write-Error "Failed to create symbolic link for $file. Please run as Administrator or enable Developer Mode."
        }
    }
}

# 4. Install VS Code extensions
Write-Host "`n--- 4. Installing VS Code Extensions ---" -ForegroundColor Cyan
$extFile = Join-Path $DotfilesDir "vscode\extensions.txt"
if (Test-Path $extFile) {
    if (Get-Command code -ErrorAction SilentlyContinue) {
        Get-Content $extFile | ForEach-Object {
            $line = $_.Trim()
            if ($line -and !$line.StartsWith("#")) {
                Write-Host "Installing extension: $line"
                code --install-extension $line --force
            }
        }
    } else {
        Write-Error "'code' command not found. Please ensure VS Code is installed and in your PATH."
    }
}

Write-Host "`nWindows setup complete!" -ForegroundColor Green
