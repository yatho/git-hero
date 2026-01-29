#!/bin/bash

echo "🔄 Resetting Git Bisect demo..."
echo

cd "$(dirname "$0")"

# Remove git repository
rm -rf .git
rm number-guesser.js
rm number-guesser.test.js

# Remove any backup files created by sed
rm -f *.bak

echo "✅ Reset complete!"
echo
echo "The git repository has been removed."
echo "Run ./setup.sh to recreate the demo"
