#!/bin/bash
cd "$(dirname "$0")"

# Remove git repository and generated files
rm -rf .git
rm -f calculator.js package.json package-lock.json README-demo.md .gitattributes

echo "✅ Reset complete! Run ./setup.sh to start over"
