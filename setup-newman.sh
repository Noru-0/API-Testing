#!/bin/bash

echo "📥 Installing Newman and HTML Extra Reporter..."

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install Node.js and npm first."
    echo "Download from: https://nodejs.org/"
    exit 1
fi

# Install Newman and HTML Extra Reporter globally
npm install -g newman newman-reporter-htmlextra

# Verify installation
if command -v newman &> /dev/null; then
    echo "✅ Newman installed successfully!"
    newman --version
    
    # Check if htmlextra reporter is available
    if newman run --help | grep -q "htmlextra"; then
        echo "✅ HTML Extra Reporter installed successfully!"
    else
        echo "⚠️  HTML Extra Reporter might not be installed correctly."
        echo "Try running: npm install -g newman-reporter-htmlextra"
    fi
else
    echo "❌ Newman installation failed."
    exit 1
fi

echo "🎉 Setup complete! You can now run API tests."
