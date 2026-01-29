#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

start_demo "Git Submodules" "Version-pin external dependencies"

announce "📋 1. What Are Submodules?"
info "Submodules let you include other git repositories at specific commits"
pause

announce "🔍 2. View Submodules"
run "git submodule status"
run "cat .gitmodules"
pause

announce "📂 3. Submodule Structure"
run "ls -la plugins/"
info "Each submodule is a separate git repository"
pause

announce "🔄 4. Update a Submodule"
echo "cd plugins/math && git pull"
cd plugins/math && git pull || true
cd ../..
run "git status"
info "Main repo sees submodule changed to new commit"
pause

announce "📦 5. Clone Workflow"
echo "When cloning a repo with submodules:"
echo "  git clone --recursive <url>"
echo "Or after cloning:"
echo "  git submodule update --init --recursive"
pause

announce "⚠️  6. Common Pitfalls"
warning "Submodules are in detached HEAD state"
warning "Must cd into submodule to commit changes"
info "Requires extra steps compared to normal files"
pause

end_demo \
  "Submodules pin external repos to specific commits" \
  "Use --recursive when cloning" \
  "More complex than regular files but powerful"
