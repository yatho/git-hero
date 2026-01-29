#!/bin/bash
cd "$(dirname "$0")"

# Remove git repositories and generated files
rm -rf source-repo received-repo bundles
rm -f *.bundle

echo "✅ Reset complete! Run ./setup.sh to start over"
