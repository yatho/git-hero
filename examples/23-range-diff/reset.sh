#!/bin/bash
cd "$(dirname "$0")"

# Remove git repository and generated files
rm -rf .git
rm -f app.js utils.js config.json

echo "✅ Reset complete! Run ./setup.sh to start over"
