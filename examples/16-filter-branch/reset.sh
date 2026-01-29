#!/bin/bash
cd "$(dirname "$0")"
rm -rf .git logs config.json logger.js
echo "✅ Reset complete!"
