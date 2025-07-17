#!/bin/bash

# Development setup script for SwiftMpg123
set -e

echo "🚀 Setting up development environment for SwiftMpg123..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed. Please install it first:"
    echo "   https://brew.sh/"
    exit 1
fi

# Install required tools
echo "📦 Installing development tools..."
brew install swiftformat pre-commit

# Check Swift version
echo "🔍 Checking Swift version..."
swift --version

# Install mpg123 dependency
echo "🎵 Installing mpg123..."
brew install mpg123

# Install pre-commit hooks
echo "🔧 Installing pre-commit hooks..."
pre-commit install

# Verify installation
echo "✅ Verifying installation..."
if command -v swiftformat &> /dev/null; then
    echo "   ✅ SwiftFormat installed"
else
    echo "   ❌ SwiftFormat not found"
fi

if command -v pre-commit &> /dev/null; then
    echo "   ✅ Pre-commit installed"
else
    echo "   ❌ Pre-commit not found"
fi

# Test build
echo "🔨 Testing build..."
swift build

echo "🎉 Development environment setup complete!"
echo ""
echo "Next steps:"
echo "  1. Run 'swift test' to run tests"
echo "  2. Run 'swift run MP3PlayerDemo' to test the demo"
echo "  3. Your commits will now be automatically formatted"
echo ""
echo "CI Information:"
echo "  - Supports Swift 5.9 and 6.1.2"
echo "  - Cross-platform: macOS, Linux, Windows"
echo "  - Automated releases on version tags"
echo ""
echo "Useful commands:"
echo "  swiftformat --config .swiftformat Sources/ Tests/  # Format code"
echo "  pre-commit run --all-files                        # Run all pre-commit hooks" 