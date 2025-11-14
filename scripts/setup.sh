#!/usr/bin/env bash
# Setup script for Chat Simulator development

set -e

echo "🚀 Setting up Chat Simulator development environment..."

# Check if Elixir is installed
if ! command -v elixir &> /dev/null; then
    echo "❌ Elixir is not installed. Please install Elixir first."
    echo "   Visit: https://elixir-lang.org/install.html"
    exit 1
fi

echo "✓ Elixir $(elixir --version | head -n 1)"

# Check if Mix is available
if ! command -v mix &> /dev/null; then
    echo "❌ Mix is not available."
    exit 1
fi

echo "✓ Mix available"

# Install Hex
echo "📦 Installing Hex..."
mix local.hex --force

# Install Rebar
echo "📦 Installing Rebar..."
mix local.rebar --force

# Install dependencies
echo "📦 Installing dependencies..."
mix deps.get

# Compile dependencies
echo "🔨 Compiling dependencies..."
mix deps.compile

# Run tests
echo "🧪 Running tests..."
mix test

# Check code formatting
echo "💅 Checking code formatting..."
mix format --check-formatted || {
    echo "⚠️  Code is not formatted. Run 'mix format' to fix."
}

# Build escript
echo "🔨 Building escript..."
mix escript.build

echo ""
echo "✅ Setup complete!"
echo ""
echo "To run the application:"
echo "  ./chat_simulator"
echo ""
echo "Or with Mix:"
echo "  mix run -e \"ChatSimulator.CLI.main()\""
echo ""
echo "To run tests:"
echo "  mix test"
echo ""
echo "Happy coding! 🎉"
