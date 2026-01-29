#!/bin/bash

echo "🔄 Resetting Git Log & Grep demo..."
echo

cd "$(dirname "$0")"

# Remove git repository
rm -rf .git

# Remove generated files
rm -f app.js validation.js search.js config.js package.json USAGE.md app.test.js

echo "✅ Reset complete!"
echo
echo "The git repository and generated files have been removed."
echo "Run ./setup.sh to recreate the demo"
