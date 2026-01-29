#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

start_demo "Git Cherry-Pick" "Select specific commits across branches"

announce "📋 1. The Situation"
echo "• main: Production with 5 cities (London has wrong temp)"
echo "• feature/extended-cities: Add cities + redesign + fix bug"
echo "• Problem: Need the fix NOW, but redesign isn't ready"
pause

announce "🌳 2. View Branch History"
info "The fix commit is the last one"
run "git log --oneline --all --graph"
pause

announce "🍒 3. Cherry-Pick Just the Fix"
HASH=$(git log --oneline feature/extended-cities | head -1 | awk '{print $1}')
run "git cherry-pick $HASH"
success "Fix applied to main without the redesign!"
pause

announce "✅ 4. Verify"
run "git log --oneline --graph --all"
info "Fix is now in main, feature branch continues independently"
pause

end_demo \
  "Cherry-pick applies specific commits to current branch" \
  "Useful for hotfixes from feature branches" \
  "Original commit stays in source branch"
