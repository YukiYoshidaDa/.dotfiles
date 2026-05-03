# PowerShell script to link config files on Windows (Helper)

$DotfilesDir = Split-Path $PSScriptRoot -Parent
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# 1. Link VS Code & Antigravity settings
Write-Host "--- Linking Editor Configuration ---" -ForegroundColor Cyan
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

Write-Host "`nSymlinks created!" -ForegroundColor Green
