#!/usr/bin/env bash
# Comprehensive test script for Chat Simulator

set -e

echo "🧪 Running Chat Simulator test suite..."
echo ""

# Run unit tests
echo "📋 Running unit tests..."
mix test

# Run tests with coverage
echo ""
echo "📊 Running tests with coverage..."
mix test --cover

# Check code formatting
echo ""
echo "💅 Checking code formatting..."
if mix format --check-formatted; then
    echo "✓ Code is properly formatted"
else
    echo "❌ Code formatting issues found. Run 'mix format' to fix."
    exit 1
fi

# Run Credo
echo ""
echo "🔍 Running static analysis (Credo)..."
if mix credo --strict; then
    echo "✓ No issues found"
else
    echo "⚠️  Credo found issues"
fi

# Check for compilation warnings
echo ""
echo "🔨 Checking for compilation warnings..."
if mix compile --warnings-as-errors --force; then
    echo "✓ No compilation warnings"
else
    echo "❌ Compilation warnings found"
    exit 1
fi

echo ""
echo "✅ All checks passed!"
