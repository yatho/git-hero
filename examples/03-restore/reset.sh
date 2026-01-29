#!/bin/bash
cd "$(dirname "$0")"

# Remove git repository and generated files
rm -rf .git
rm -f config.json utils.js app.js test1.txt test2.txt data.json

echo "✅ Reset complete! Run ./setup.sh to start over"
