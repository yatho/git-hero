#!/bin/bash
cd "$(dirname "$0")"

# Remove git repository and generated files
rm -rf .git src tests docs
rm -f package.json .env.example

echo "✅ Reset complete! Run ./setup.sh to start over"
