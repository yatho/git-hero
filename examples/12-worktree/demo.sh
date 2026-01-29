#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

start_demo "Git Worktree" "Work on multiple branches simultaneously"

announce "📝 1. The Problem"
echo "You're working on feature/openapi (uncommitted work)"
echo "A PR needs urgent review on pr-review branch"
echo ""
warning "Traditional solution: stash, switch, review, switch back, unstash"
error "Too much overhead!"
pause

announce "✨ 2. Worktree Solution"
info "Create a separate working directory for the PR review"
pause

announce "🌲 3. List Current Worktrees"
run "git worktree list"
pause

announce "➕ 4. Add New Worktree for PR Review"
run "git worktree add ../12-worktree-pr pr-review"
success "New worktree created!"
pause

announce "📂 5. Explore the New Worktree"
run "ls ../12-worktree-pr"
info "Complete working directory with pr-review branch checked out"
pause

announce "✅ 6. Benefits"
echo "• Continue work in main worktree (feature/openapi)"
echo "• Review PR in separate worktree (pr-review)"
echo "• No stashing or switching needed!"
echo "• Both directories are fully functional"
run "git worktree list"
pause

announce "🧹 7. Cleanup"
run "git worktree remove ../12-worktree-pr"
run "git worktree list"
success "Worktree removed!"
pause

end_demo \
  "Worktrees allow multiple branches checked out simultaneously" \
  "Each worktree is a complete working directory" \
  "Eliminates stash/switch overhead"
