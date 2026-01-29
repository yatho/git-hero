#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

# ===============================
# Git Revert Demo
# ===============================

start_demo "Git Revert" "Safely undo commits without rewriting history"

# -------------------------
announce "📋 1. Current State"

info "Let's see our commit history:"
run "git log --oneline"
pause

info "We have 4 commits, but one introduced a bug!"
run "cat server.js"
pause

warning "The /data endpoint has a bug that crashes the server!"
pause

# -------------------------
announce "🐛 2. The Problem"

echo "Commit history:"
echo "  ✅ Initial server setup"
echo "  ✅ Add authentication middleware"
echo "  🐛 Add data endpoint (BUGGY!)"
echo "  ✅ Add logging middleware"
echo
info "We need to remove the buggy commit but keep the logging!"
pause

# -------------------------
announce "❌ 3. Why NOT Use Reset?"

warning "We could use 'git reset --hard' but..."
echo
echo "Problems with reset:"
echo "  • Rewrites history (breaks shared branches)"
echo "  • Would remove logging commit too"
echo "  • Others who pulled would have conflicts"
echo "  • Dangerous for collaboration"
pause

# -------------------------
announce "✅ 4. Git Revert to the Rescue"

info "git revert creates a NEW commit that undoes changes"
echo "This is safe because:"
echo "  • Doesn't rewrite history"
echo "  • Creates new commit everyone can pull"
echo "  • Preserves all history"
pause

info "Let's revert the buggy commit (HEAD~1):"
run "git log --oneline -4"
pause

# Get the commit hash for the buggy commit
BUGGY_COMMIT=$(git log --oneline | grep "Add data endpoint" | awk '{print $1}')
info "Reverting commit: $BUGGY_COMMIT"
run "git revert $BUGGY_COMMIT --no-edit"
pause

# -------------------------
announce "🎯 5. What Happened?"

info "New commit created that undoes the buggy changes:"
run "git log --oneline"
pause

info "The buggy code is gone:"
run "cat server.js"
echo
success "The /data endpoint is removed, but logging is still there!"
pause

# -------------------------
announce "📊 6. History Comparison"

echo "With git reset (BAD for shared branches):"
echo "  Before: A → B → C (buggy) → D"
echo "  After:  A → B → D"
echo "  ❌ History rewritten, commit C gone"
echo
echo "With git revert (SAFE for shared branches):"
echo "  Before: A → B → C (buggy) → D"
echo "  After:  A → B → C (buggy) → D → E (revert C)"
echo "  ✅ History preserved, new commit undoes C"
pause

# -------------------------
announce "🔄 7. Reverting Multiple Commits"

info "Let's make some more changes to demonstrate..."
cat > server.js << 'EOF'
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.get('/health', (req, res) => {
  res.send('OK');
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF

run "git add . && git commit -m 'Add health check endpoint'"
pause

cat > server.js << 'EOF'
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.get('/health', (req, res) => {
  res.send('OK');
});

app.get('/status', (req, res) => {
  res.json({ status: 'running', uptime: process.uptime() });
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF

run "git add . && git commit -m 'Add status endpoint'"
pause

info "Now let's revert the last 2 commits:"
run "git log --oneline -3"
pause

info "Revert multiple commits (no merge commit):"
run "git revert --no-commit HEAD HEAD~1"
pause

run "git status"
pause

run "git commit -m 'Revert health and status endpoints'"
pause

# -------------------------
announce "⚔️ 8. Handling Conflicts"

info "Sometimes reverting causes conflicts..."
echo
echo "When conflicts occur:"
echo "  1. Git pauses the revert"
echo "  2. Fix conflicts manually"
echo "  3. git add <resolved-files>"
echo "  4. git revert --continue"
echo
echo "Or abort with:"
echo "  git revert --abort"
pause

# -------------------------
announce "🎓 9. Revert vs Reset Comparison"

echo "┌─────────────────┬──────────────┬──────────────┐"
echo "│ Feature         │ git reset    │ git revert   │"
echo "├─────────────────┼──────────────┼──────────────┤"
echo "│ Rewrites history│ YES ⚠️        │ NO ✅        │"
echo "│ Safe for shared │ NO ❌        │ YES ✅       │"
echo "│ Creates commit  │ NO           │ YES          │"
echo "│ Use case        │ Local only   │ Shared repos │"
echo "└─────────────────┴──────────────┴──────────────┘"
pause

# -------------------------
announce "📝 10. Common Revert Patterns"

echo "# Revert the last commit"
echo "$ git revert HEAD"
echo
echo "# Revert specific commit"
echo "$ git revert <commit-hash>"
echo
echo "# Revert without auto-commit"
echo "$ git revert --no-commit HEAD"
echo
echo "# Revert multiple commits"
echo "$ git revert --no-commit HEAD HEAD~1 HEAD~2"
echo "$ git commit -m 'Revert features X, Y, Z'"
echo
echo "# Revert a range (oldest..newest)"
echo "$ git revert HEAD~3..HEAD"
echo
echo "# Continue/abort after conflict"
echo "$ git revert --continue"
echo "$ git revert --abort"
pause

# -------------------------
announce "💡 11. When to Use Each"

echo "Use git reset when:"
echo "  ✅ Commits are local (not pushed)"
echo "  ✅ Working alone on a branch"
echo "  ✅ Want clean history"
echo
pause

echo "Use git revert when:"
echo "  ✅ Commits are pushed/shared"
echo "  ✅ Working with a team"
echo "  ✅ Need to preserve history"
echo "  ✅ In production/main branch"
pause

# -------------------------
announce "🎯 12. Best Practices"

echo "✅ Always use revert for shared/pushed commits"
echo "✅ Use --no-edit to keep default message"
echo "✅ Use --no-commit to combine multiple reverts"
echo "✅ Test after reverting (especially with conflicts)"
echo "✅ Revert merge commits with -m flag"
echo "✅ Document why you're reverting in commit message"
pause

# End demo
end_demo \
  "git revert creates new commits that undo changes" \
  "Revert is SAFE for shared branches (doesn't rewrite history)" \
  "Reset is for local commits, revert is for pushed commits" \
  "Use --no-commit to revert multiple commits at once" \
  "Handle conflicts with --continue or --abort" \
  "Always prefer revert over reset for team/production work"
