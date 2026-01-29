#!/bin/bash
cd "$(dirname "$0")"
rm -rf .git
PARENT_DIR="$(dirname "$(pwd)")"
rm -rf "${PARENT_DIR}/09-worktree-pr" 2>/dev/null || true
echo "✅ Reset complete!"
