#!/bin/bash

echo "🔄 Resetting Git Merge demo..."
echo

cd "$(dirname "$0")"

# Remove git repository
rm -rf .git
rm cart.js

echo "✅ Reset complete!"
echo
echo "The git repository has been removed."
echo "Run ./setup.sh to recreate the demo"
