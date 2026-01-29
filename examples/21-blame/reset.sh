#!/bin/bash
cd "$(dirname "$0")"

# Remove git repository and generated files
rm -rf .git
rm -f calculator.js utils.js config.json .git-blame-ignore-revs .formatting-commit

echo "✅ Reset complete! Run ./setup.sh to start over"
