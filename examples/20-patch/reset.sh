#!/bin/bash
cd "$(dirname "$0")"

# Remove git repository and generated files
rm -rf .git patches *.patch
rm -f app.js utils.js config.json uncommitted.patch

echo "✅ Reset complete! Run ./setup.sh to start over"
