#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

start_demo "Git Fixup" "Mark commits for automatic squashing"

announce "📋 1. Discover Bug in Multiplication"
run "node calc.js"
error "5 * 3 should be 15, not 8!"
pause

announce "🔍 2. Find Which Commit Introduced It"
run "git log --oneline"
info "Commit 3 added multiplication"
pause

announce "🔧 3. Fix the Bug"
sed -i.bak 's/\(function multiply.*return a \)+ \(b;\)/\1* \2/' calc.js
rm -f calc.js.bak
run "git diff"
pause

announce "🏷️  4. Create Fixup Commit"
HASH=$(git log --oneline | grep "add multiplication" | awk '{print $1}')
run "git add calc.js"
run "git commit --fixup=$HASH"
info "Created fixup commit targeting the bug's commit"
pause

announce "📜 5. View History with Fixup"
run "git log --oneline"
warning "Notice the 'fixup!' prefix"
pause

announce "🔀 6. Auto-squash with Rebase"
run "git rebase -i --autosquash HEAD~4"
success "Fixup automatically moved next to target commit!"
pause

announce "✅ 7. Clean History"
run "git log --oneline"
success "Bug fix integrated into original commit!"
pause

end_demo \
  "git commit --fixup marks commits for squashing" \
  "git rebase -i --autosquash automatically reorders" \
  "Cleaner than manual interactive rebase"
