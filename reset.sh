#!/bin/bash

echo "🔄 Resetting all Git Hero examples..."
echo ""

# Block 1: Daily Developer Workflow
cd examples/01-stash
./reset.sh
cd ../02-merge
./reset.sh
cd ../03-restore
./reset.sh
cd ../04-reflog
./reset.sh

# Block 2: Clean History
cd ../05-rebase-interactive
./reset.sh
cd ../06-fixup
./reset.sh
cd ../07-reset
./reset.sh
cd ../08-revert
./reset.sh

# Block 3: Debugging & Investigation
cd ../09-bisect
./reset.sh
cd ../10-log
./reset.sh
cd ../11-diff
./reset.sh

# Block 4: Advanced Workflows
cd ../12-worktree
./reset.sh
cd ../13-cherry-pick
./reset.sh
cd ../14-submodules
./reset.sh
cd ../15-subtree
./reset.sh
cd ../16-filter-branch
./reset.sh
cd ../17-rerere
./reset.sh
cd ../18-checkout
./reset.sh

# Block 5: Alien workflows :)
cd ../19-sparse-checkout
./reset.sh
cd ../20-patch
./reset.sh
cd ../21-blame
./reset.sh
cd ../22-grep
./reset.sh
cd ../23-range-diff
./reset.sh
cd ../24-bundle
./reset.sh

cd ../..

echo ""
echo "✅ All git examples have been reset successfully!"
echo ""
echo "Run ./setup.sh to initialize all examples again."
