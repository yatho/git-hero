#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

start_demo "Git Reflog" "Recover 'lost' commits with Git's safety net"

announce "📋 1. Our Branches"
run "git log --oneline --all --graph"
pause

announce "😱 2. OOPS - Accidentally Delete experimental Branch!"†
run "git branch -D experimental"
error "Branch deleted! Commits seem lost..."
pause

announce "🔍 3. Check git log - Commits Are Gone"
run "git log --oneline --all"
warning "The experimental commits don't appear in git log!"
pause

announce "🦸 4. Reflog to the Rescue!"
run "git reflog"
info "Reflog shows ALL operations, even deleted branches!"
pause

announce "✅ 5. Recover the Branch"
run "git switch -C experimental-recovered HEAD@{1}"
run "git log --oneline --all --graph"
success "All commits recovered!"
pause

end_demo \
  "Deleted branches can be recovered" \
  "Git rarely loses data permanently"
