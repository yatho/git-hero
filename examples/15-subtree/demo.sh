#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

start_demo "Git Subtree" "Simpler alternative to submodules"

announce "📋 1. What Are Subtrees?"
info "Subtrees merge external repos into your project"
info "They appear as regular directories (no .gitmodules)"
pause

announce "🔍 2. View Subtree Content"
run "ls -la lib/utils/"
info "Looks like normal files, but came from external repo"
pause

announce "📝 3. Modify Subtree Locally"
echo "// Local change" >> lib/utils/index.js
run "git add lib/utils/index.js"
run "git commit -m 'feat: enhance utils'"
info "Changes committed in main repo like normal files"
pause

announce "🔄 4. Pull Updates from Library"
echo "To pull updates from the library repo:"
echo "  git subtree pull --prefix=lib/utils utils-lib main --squash"
pause

announce "📤 5. Push Changes Back to Library"
echo "To contribute changes back:"
echo "  git subtree push --prefix=lib/utils utils-lib main"
info "Extracts commits touching lib/utils and pushes to library repo"
pause

announce "⚖️  6. Subtree vs Submodule"
echo "Subtree advantages:"
echo "  ✅ Simpler workflow (no --recursive, no init)"
echo "  ✅ Clone 'just works'"
echo "  ✅ Changes committed like normal files"
echo ""
echo "Subtree disadvantages:"
echo "  ❌ History gets mixed (--squash helps)"
echo "  ❌ Larger repository size"
echo "  ❌ Less obvious it's external code"
pause

end_demo \
  "Subtrees merge external repos as regular files" \
  "Simpler workflow than submodules" \
  "Trade-offs: easier use vs larger size" \
  "Submodules is a link, subtree is a copy"
