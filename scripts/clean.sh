#!/usr/bin/env bash
# Clean build artifacts and generated files

set -e

echo "🧹 Cleaning Chat Simulator project..."

# Remove build artifacts
echo "Removing build artifacts..."
rm -rf _build
rm -rf deps
rm -rf doc
rm -rf cover

# Remove escript
if [ -f chat_simulator ]; then
    echo "Removing escript..."
    rm chat_simulator
fi

# Remove data files
if [ -f .chat_data.etf ]; then
    echo "Removing data file..."
    rm .chat_data.etf
fi

if [ -f .chat_data_dev.etf ]; then
    echo "Removing dev data file..."
    rm .chat_data_dev.etf
fi

if [ -f .chat_data_test.etf ]; then
    echo "Removing test data file..."
    rm .chat_data_test.etf
fi

# Remove crash dumps
if [ -f erl_crash.dump ]; then
    echo "Removing crash dump..."
    rm erl_crash.dump
fi

echo "✅ Clean complete!"
