#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

cd "$SCRIPT_DIR/monorepo-demo"

# ===============================
# Git Sparse-Checkout Demo
# ===============================

start_demo "Git Sparse-Checkout" "Work with only parts of a large repository"

# -------------------------
announce "1. Current Repository State"

info "This is a monorepo with multiple apps and packages"
run "ls -la"
pause

info "Let's see the full structure:"
run "find . -type f -name '*.js' -o -name '*.json' -o -name '*.md' | grep -v .git | head -20"
pause

run "git log --oneline"
pause

# -------------------------
announce "2. Enable Sparse-Checkout"

info "Sparse-checkout lets us check out only specific directories"
echo "This is essential for large monorepos!"
pause

info "First, enable sparse-checkout in cone mode (recommended):"
run "git sparse-checkout init --cone"
pause

info "Check the sparse-checkout config:"
run "cat .git/info/sparse-checkout"
pause

# -------------------------
announce "3. Select What to Checkout"

info "Let's say we're a frontend developer..."
echo "We only need the frontend app and UI components"
pause

run "git sparse-checkout set apps/frontend packages/ui-components"
pause

info "Now check what files we have:"
run "ls -la"
pause

run "ls -la apps/"
pause

run "ls -la packages/"
pause

success "Only frontend and ui-components are checked out!"
pause

# -------------------------
announce "4. List Current Patterns"

info "See what's currently included:"
run "git sparse-checkout list"
pause

# -------------------------
announce "5. Add More Directories"

info "We also need the shared-utils package:"
run "git sparse-checkout add packages/shared-utils"
pause

run "ls -la packages/"
pause

run "git sparse-checkout list"
pause

# -------------------------
announce "6. Git Status Still Works"

info "Git still tracks everything, even if not checked out:"
run "git status"
pause

info "Let's modify a file:"
cat >> apps/frontend/src/App.js << 'EOF'

// New feature
function NewComponent() {
  return <div>New Component</div>;
}
EOF

run "git status"
pause

run "git diff"
pause

# Reset the change
git checkout -- apps/frontend/src/App.js

# -------------------------
announce "7. Working with Excluded Files"

info "What happens with excluded directories?"
echo "Let's try to see the backend (not checked out):"
pause

run "ls apps/"
echo
info "Notice: backend and mobile directories don't appear!"
pause

info "But we can still see them in git:"
run "git ls-tree --name-only HEAD apps/"
pause

# -------------------------
announce "8. Change Your Focus"

info "Now let's switch to being a backend developer:"
run "git sparse-checkout set apps/backend packages/shared-utils packages/api-client"
pause

run "ls -la apps/"
pause

run "ls -la packages/"
pause

success "Now we only have backend-related code!"
pause

# -------------------------
announce "9. DevOps Focus"

info "Or maybe we're doing DevOps work:"
run "git sparse-checkout set infrastructure docs"
pause

run "ls -la"
pause

run "ls -la infrastructure/"
pause

run "cat infrastructure/kubernetes/deployment.yaml"
pause

# -------------------------
announce "10. Full Checkout"

info "To get everything back:"
run "git sparse-checkout disable"
pause

run "ls -la"
pause

run "ls -la apps/"
pause

success "All files are back!"
pause

# -------------------------
announce "11. Practical Clone Example"

echo "For a real workflow, you'd typically do:"
echo
echo "# Clone without checkout (fast)"
echo "$ git clone --no-checkout https://github.com/company/monorepo.git"
echo "$ cd monorepo"
echo
echo "# Enable sparse-checkout"
echo "$ git sparse-checkout init --cone"
echo "$ git sparse-checkout set my/needed/paths"
echo
echo "# Now checkout"
echo "$ git checkout main"
pause

# -------------------------
announce "12. Partial Clone + Sparse Checkout"

echo "For the ultimate performance on huge repos:"
echo
echo "# Combine partial clone with sparse checkout"
echo "$ git clone --filter=blob:none --sparse \\"
echo "    https://github.com/company/huge-monorepo.git"
echo "$ cd huge-monorepo"
echo "$ git sparse-checkout set src/my-project"
echo
echo "This only downloads blobs (file contents) that you need!"
pause

# -------------------------
announce "13. Cone vs Non-Cone Mode"

echo "Cone Mode (--cone) - RECOMMENDED"
echo "  - Only specify directories"
echo "  - Fast pattern matching"
echo "  - Better for monorepos"
echo
echo "Non-Cone Mode (legacy)"
echo "  - Supports gitignore patterns (*.md, src/**/*.js)"
echo "  - More flexible but slower"
echo "  - Use: git sparse-checkout init (without --cone)"
pause

# -------------------------
announce "14. Key Commands Summary"

echo "# Initialize sparse-checkout"
echo "$ git sparse-checkout init --cone"
echo
echo "# Set directories (replaces current selection)"
echo "$ git sparse-checkout set dir1 dir2"
echo
echo "# Add to current selection"
echo "$ git sparse-checkout add dir3"
echo
echo "# See current selection"
echo "$ git sparse-checkout list"
echo
echo "# Disable and get everything"
echo "$ git sparse-checkout disable"
echo
echo "# Check if enabled"
echo "$ git sparse-checkout check-rules"
pause

# End demo
end_demo \
  "Sparse-checkout lets you work with parts of a repo" \
  "Use --cone mode for best performance" \
  "Great for monorepos and large repositories" \
  "Combine with --filter=blob:none for huge repos" \
  "Git still tracks all files for commits/history"
