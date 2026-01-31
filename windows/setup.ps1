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

# 3. Link VS Code & Antigravity settings
Write-Host "`n--- 3. Setting up Editor Configuration (Symbolic Links) ---" -ForegroundColor Cyan
$EditorConfigDirs = @(
    "$env:APPDATA\Code\User",
    "$env:APPDATA\Antigravity\User"
)

foreach ($dir in $EditorConfigDirs) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    $vscodeFiles = @("settings.json", "keybindings.json")
    foreach ($file in $vscodeFiles) {
        $src = Join-Path $DotfilesDir "vscode\$file"
        $dest = Join-Path $dir $file

        if (Test-Path $src) {
            # Backup existing file if it's not already a link to our source
            if (Test-Path $dest) {
                $existingTarget = (Get-Item $dest).Target
                if ($existingTarget -eq $src) {
                    Write-Host "Already linked ($file): $dir" -ForegroundColor Gray
                    continue
                }

                Write-Host "Backing up existing $file in $dir" -ForegroundColor Yellow
                Move-Item $dest "${dest}.${Timestamp}.bak" -Force
            }

            # Create Symbolic Link
            try {
                New-Item -ItemType SymbolicLink -Path $dest -Target $src -Force | Out-Null
                Write-Host "Created symbolic link for $file in $dir" -ForegroundColor Green
            } catch {
                Write-Error "Failed to create symbolic link for $file in $dir. Please run as Administrator or enable Developer Mode."
            }
        }
    }
}

# 4. Install Extensions (VS Code & Antigravity)
Write-Host "`n--- 4. Installing Extensions ---" -ForegroundColor Cyan
$extFile = Join-Path $DotfilesDir "vscode\extensions.txt"
if (Test-Path $extFile) {
    foreach ($cmd in @("code", "agy")) {
        if (Get-Command $cmd -ErrorAction SilentlyContinue) {
            Write-Host "Installing extensions for $cmd..." -ForegroundColor Cyan
            Get-Content $extFile | ForEach-Object {
                $line = $_.Trim()
                if ($line -and !$line.StartsWith("#")) {
                    Write-Host "Installing extension for $cmd: $line"
                    & $cmd --install-extension $line --force
                }
            }
        } else {
            Write-Warning "'$cmd' command not found. Skipping extension installation for $cmd."
        }
    }
}

Write-Host "`nWindows setup complete!" -ForegroundColor Green
