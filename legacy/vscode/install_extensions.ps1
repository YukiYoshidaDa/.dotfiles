# PowerShell script to install VS Code extensions

$DotfilesDir = Split-Path $PSScriptRoot -Parent

Write-Host "`n--- Installing Extensions ---" -ForegroundColor Cyan
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

Write-Host "`nVS Code extensions installation complete!" -ForegroundColor Green
