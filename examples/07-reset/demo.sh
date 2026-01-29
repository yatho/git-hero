#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

# ===============================
# Git Reset Demo
# ===============================

start_demo "Git Reset" "Understanding --soft, --mixed, and --hard"

# -------------------------
announce "📋 1. Current State"

info "Let's see our commit history:"
run "git log --oneline"
pause

info "Current HEAD is at commit with logger and stop method"
run "cat app.js"
pause

# -------------------------
announce "🔄 2. Reset --soft (Keep Changes Staged)"

info "git reset --soft moves HEAD but keeps changes in staging area"
echo "Let's go back 1 commit with --soft:"
run "git reset --soft HEAD~1"
pause

info "Notice: HEAD moved but changes are still staged"
run "git status"
pause

run "git diff --staged"
echo
success "Changes from the last commit are now in staging area!"
pause

info "Let's commit them again:"
run "git commit -m 'Add logger and stop method (recommitted)'"
pause

# -------------------------
announce "🔄 3. Reset --mixed (Default - Unstage Changes)"

info "git reset --mixed (or just git reset) moves HEAD and unstages changes"
echo "Let's go back 1 commit with --mixed:"
run "git reset --mixed HEAD~1"
pause

info "Notice: HEAD moved and changes are now unstaged"
run "git status"
pause

run "git diff"
echo
success "Changes are in working directory but not staged!"
pause

info "We can see the changes but haven't lost them:"
run "cat app.js"
pause

info "Let's commit them again:"
git add .
run "git commit -m 'Add logger and stop method (recommitted again)'"
pause

# -------------------------
announce "🔄 4. Reset --hard (Discard Everything)"

warning "git reset --hard DESTROYS CHANGES! Use with caution!"
echo "Let's go back 1 more commit and discard all changes:"
pause

run "git reset --hard HEAD~1"
pause

info "Notice: HEAD moved and ALL changes are gone"
run "git status"
pause

run "cat app.js"
echo
warning "The logger and stop method are completely gone!"
pause

# -------------------------
announce "📊 5. Comparison Summary"

echo "Let's see where we are now:"
run "git log --oneline"
pause

info "We went from 4 commits to 2 commits"
echo
echo "Reset modes comparison:"
echo "  • --soft:  Moves HEAD, keeps changes staged"
echo "  • --mixed: Moves HEAD, keeps changes unstaged (default)"
echo "  • --hard:  Moves HEAD, DELETES all changes ⚠️"
pause

# -------------------------
announce "💾 6. Practical Use Cases"

echo "When to use each mode:"
echo
echo "✅ --soft: Undo commits but keep work"
echo "   Example: Combine last 3 commits into one"
echo "   $ git reset --soft HEAD~3"
echo "   $ git commit -m 'Combined feature'"
echo
pause

echo "✅ --mixed: Unstage files"
echo "   Example: Accidentally staged too many files"
echo "   $ git reset HEAD"
echo "   $ git add only-what-i-want.js"
echo
pause

echo "⚠️  --hard: Start fresh (DANGEROUS)"
echo "   Example: Completely discard local changes"
echo "   $ git reset --hard HEAD"
echo "   or go back to specific commit"
echo "   $ git reset --hard abc123"
pause

# -------------------------
announce "🛟 7. Safety: Recovering from Reset"

info "Even after --hard, commits aren't immediately deleted!"
echo "They're in the reflog for ~90 days:"
run "git reflog"
pause

info "To recover, find the commit hash and reset to it:"
echo "$ git reset --hard <commit-hash>"
echo
success "The reflog is your safety net!"
pause

# -------------------------
announce "🎯 8. Reset vs Revert"

echo "git reset: Rewrites history (moves HEAD)"
echo "  • Use for local, unpushed commits"
echo "  • NEVER use on pushed commits (breaks others' history)"
echo
echo "git revert: Creates new commit that undoes changes"
echo "  • Use for pushed commits"
echo "  • Safe for shared branches"
echo
pause

# -------------------------
announce "⚡ 9. Quick Reference"

echo "Common reset commands:"
echo
echo "# Unstage all files (keep changes)"
echo "$ git reset"
echo
echo "# Unstage specific file"
echo "$ git reset HEAD <file>"
echo
echo "# Undo last commit, keep changes staged"
echo "$ git reset --soft HEAD~1"
echo
echo "# Undo last commit, keep changes unstaged"
echo "$ git reset HEAD~1"
echo
echo "# Undo last commit, discard changes"
echo "$ git reset --hard HEAD~1"
echo
echo "# Go to specific commit"
echo "$ git reset --hard <commit-hash>"
pause

# End demo
end_demo \
  "git reset --soft: moves HEAD, keeps changes staged" \
  "git reset --mixed (default): moves HEAD, unstages changes" \
  "git reset --hard: moves HEAD, DELETES changes ⚠️" \
  "Use reset for local commits only, never on pushed commits" \
  "Reflog is your safety net - commits recoverable for ~90 days" \
  "reset = rewrite history, revert = new commit (safer for shared branches)"
