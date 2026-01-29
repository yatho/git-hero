#!/bin/bash
cd "$(dirname "$0")"

# Remove git repository and generated files
rm -rf monorepo-demo

echo "✅ Reset complete! Run ./setup.sh to start over"
