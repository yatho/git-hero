#!/bin/bash
cd "$(dirname "$0")"
rm -rf .git notes-data.json
echo "✅ Reset complete! Run ./setup.sh"
