#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

start_demo "Interactive Rebase" "Clean up commit history"

announce "📋 1. Messy Commit History"
run "git log --oneline"
error "WIP commits, typo fixes, unclear messages!"
pause

announce "🧹 2. Interactive Rebase (Simulated)"
echo "We would run: git rebase -i --root"
echo ""
echo "This opens an editor with actions:"
echo "  pick = keep commit"
echo "  squash = merge with previous"
echo "  fixup = merge, discard message"
echo "  reword = change commit message"
echo "  drop = remove commit"
pause

announce "✏️  3. Our Cleanup Plan"
echo "1. Squash 'WIP' commits into 'add complete functionality'"
echo "2. Fixup typo commits into their targets"
echo "3. Fixup 'fixup for filtering' into 'add filtering'"
echo "4. Reword unclear messages"
pause

announce "🔀 4. Execute Rebase (Automated)"
echo 'git rebase -i --root'
echo ''
echo 'pick 26c707d # feat: add todo app basic structure'
echo 'pick 5e7053a # WIP: add feature'
echo 'fixup edcfd66 # WIP: still working'
echo 'squash 18c688a # feat: add complete functionality'
echo 'fixup 9044695 # typo fix'
echo 'fixup b0f006f # fix typo'
echo 'reword 92799ae # add filtering'
echo 'fixup 0df3218 # fixup for filtering'
pause
# Use GIT_SEQUENCE_EDITOR to script the rebase
GIT_SEQUENCE_EDITOR="sed -i.bak '3s/pick/squash/; 4s/pick/squash/; 5s/pick/fixup/; 6s/pick/fixup/; 7s/pick/reword/; 8s/pick/fixup/'" git rebase -i --root || true
rm -f .git/rebase-merge/git-rebase-todo.bak
success "Rebase completed!"
pause

announce "✅ 5. Clean History"
run "git log --oneline --graph --all"
success "Now, you have readable commit history!"
pause

end_demo \
  "Interactive rebase cleans commit history" \
  "Use before merging to main/master" \
  "squash, fixup, reword, drop are key actions"
