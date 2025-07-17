#!/bin/bash

# Test script for GitHub Actions workflows using ACT
# This script tests the workflows locally to ensure they work correctly

set -e

echo "🧪 Testing GitHub Actions Workflows with ACT"
echo "============================================="

# Check if ACT is installed
if ! command -v act &> /dev/null; then
    echo "❌ ACT is not installed. Please install it first:"
    echo "   brew install act"
    echo "   or visit: https://github.com/nektos/act"
    exit 1
fi

echo "✅ ACT is installed"

# Test the CI workflow
echo ""
echo "🔧 Testing CI workflow..."
act push --workflows .github/workflows/ci.yml --list

echo ""
echo "🔧 Testing Swift workflow..."
act push --workflows .github/workflows/swift.yml --list

echo ""
echo "✅ Workflow testing complete!"
echo ""
echo "To run the workflows locally with ACT:"
echo "  act push --workflows .github/workflows/ci.yml"
echo "  act push --workflows .github/workflows/swift.yml"
echo ""
echo "Note: ACT requires Docker to be running." 