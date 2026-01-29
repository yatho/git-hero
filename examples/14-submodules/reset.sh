#!/bin/bash
cd "$(dirname "$0")"
rm -rf .git .gitmodules plugins external-repos
echo "✅ Reset complete!"
