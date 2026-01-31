# PowerShell script to setup development environment on Windows using Scoop

# Set execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install Scoop if not installed
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop..."
    irm get.scoop.sh | iex
} else {
    Write-Host "Scoop is already installed."
    scoop update
}

# Add buckets
Write-Host "Adding buckets..."
scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add versions

# Update scoop and buckets
scoop update

# Define apps to install
$apps = @(
    # Browsers
    "googlechrome",
    "vivaldi",
    
    # Editors
    "vscode",
    
    # Dev
    "git",
    "powertoys",
    "win32-openssh",
    
    # Utils
    "7zip",
    "everything",
    "quicklook",
    "shizumi",
    "kindle",
    
    # Media/Comm
    "discord",
    "line",
    "steam",
    "spotify",
    "vlc",

    # Font
    "HackGen-NF"
)

# Install apps
foreach ($app in $apps) {
    Write-Host "Installing $app..."
    scoop install $app
}

Write-Host "Installation complete!"
