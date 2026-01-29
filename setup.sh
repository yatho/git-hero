#!/bin/bash

echo "🚀 Setting up all Git Hero examples..."
echo ""

# Block 1: Daily Developer Workflow
echo "📦 Block 1: Daily Developer Workflow"
cd examples/01-stash
./reset.sh
./setup.sh
cd ../02-merge
./reset.sh
./setup.sh
cd ../03-restore
./reset.sh
./setup.sh
cd ../04-reflog
./reset.sh
./setup.sh

# Block 2: Clean History
echo ""
echo "🧹 Block 2: Clean History"
cd ../05-rebase-interactive
./reset.sh
./setup.sh
cd ../06-fixup
./reset.sh
./setup.sh
cd ../07-reset
./reset.sh
./setup.sh
cd ../08-revert
./reset.sh
./setup.sh

# Block 3: Debugging & Investigation
echo ""
echo "🔍 Block 3: Debugging & Investigation"
cd ../09-bisect
./reset.sh
./setup.sh
cd ../10-log
./reset.sh
./setup.sh
cd ../11-diff
./reset.sh
./setup.sh

# Block 4: Advanced Workflows
echo ""
echo "⚡ Block 4: Advanced Workflows"
cd ../12-worktree
./reset.sh
./setup.sh
cd ../13-cherry-pick
./reset.sh
./setup.sh
cd ../14-submodules
./reset.sh
./setup.sh
cd ../15-subtree
./reset.sh
./setup.sh
cd ../16-filter-branch
./reset.sh
./setup.sh
cd ../17-rerere
./reset.sh
./setup.sh
cd ../18-checkout
./reset.sh
./setup.sh


# Block 5: Alien workflows :)
cd ../19-sparse-checkout
./reset.sh
./setup.sh
cd ../20-patch
./reset.sh
./setup.sh
cd ../21-blame
./reset.sh
./setup.sh
cd ../22-grep
./reset.sh
./setup.sh
cd ../23-range-diff
./reset.sh
./setup.sh
cd ../24-bundle
./reset.sh
./setup.sh

cd ...

echo ""
echo "✅ All git examples have been reset and set up successfully!"
echo ""
echo "Examples are organized in presentation order:"
echo "  Block 1: Daily Developer Workflow (01-04)"
echo "  Block 2: Clean History (05-08)"
echo "  Block 3: Debugging & Investigation (09-11)"
echo "  Block 4: Advanced Workflows (12-18)"
echo "  Block 5: Aliens Workflows (19-24)"
echo ""
echo "See presentation.md for the complete presentation guide."
