Write-Host "📥 Installing Newman and HTML Extra Reporter..."

# Check if npm is installed
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "❌ npm is not installed. Please install Node.js and npm first."
    Write-Host "Download from: https://nodejs.org/"
    exit 1
}

# Install Newman and HTML Extra Reporter globally
Write-Host "Installing packages..."
npm install -g newman newman-reporter-htmlextra

# Verify installation
if (Get-Command newman -ErrorAction SilentlyContinue) {
    Write-Host "✅ Newman installed successfully!"
    newman --version
    Write-Host "✅ HTML Extra Reporter installed successfully!"
} else {
    Write-Host "❌ Newman installation failed."
    exit 1
}

Write-Host "🎉 Setup complete! You can now run API tests."
