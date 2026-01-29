#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

cd "$SCRIPT_DIR"

# ===============================
# Git Range-Diff Demo
# ===============================

start_demo "Git Range-Diff" "Compare commit ranges to review changes"

# -------------------------
announce "1. The Scenario"

info "We have a feature branch that went through code review"
echo
echo "feature-v1: Original PR submission"
echo "feature-v2: Updated after review feedback"
echo
echo "Range-diff helps us see exactly what changed between versions!"
pause

# -------------------------
announce "2. Original Feature Branch (v1)"

info "Let's see the original commits:"
run "git log --oneline main..feature-v1"
pause

info "These commits were submitted for review..."
pause

# -------------------------
announce "3. Updated Feature Branch (v2)"

info "After code review, the branch was updated:"
run "git log --oneline main..feature-v2"
pause

info "Notice: 4 commits now instead of 3, and rebased onto updated main"
pause

# -------------------------
announce "4. Basic Range-Diff"

info "Compare the two versions:"
run "git range-diff main..feature-v1 main..feature-v2"
pause

# -------------------------
announce "5. Understanding the Output"

echo "Symbol meanings:"
echo
echo "  1:  abc = 1:  def   # '=' means identical commits"
echo "  2:  abc ! 2:  def   # '!' means commit was modified"
echo "  3:  abc < -:  ---   # '<' means commit was removed"
echo "  -:  --- > 3:  def   # '>' means commit was added"
echo
echo "The diff below each '!' shows what changed in that commit"
pause

# -------------------------
announce "6. Analyzing the Changes"

info "Let's break down what we see:"
echo
echo "Commit 1 (Add utils module):"
echo "  '=' - Identical, no changes"
echo
echo "Commit 2 (Add subtract):"
echo "  '!' - Modified: added input validation (reviewer feedback)"
echo
echo "Commit 3 (Use utils in app):"
echo "  '!' - Modified: now also uses config.json"
echo
echo "Commit 4 (Add multiply):"
echo "  '>' - New commit added (requested in review)"
pause

# -------------------------
announce "7. Looking at a Specific Change"

info "Let's look at what changed in the subtract commit:"
run "git show feature-v1:utils.js"
echo
info "Original version (v1) - no validation"
pause

run "git show feature-v2~2:utils.js"
echo
info "Updated version (v2) - with validation"
pause

# -------------------------
announce "8. Real-World Workflow"

echo "As a reviewer, you'd use range-diff like this:"
echo
echo "1. Review initial PR (feature-v1)"
echo "   'Add input validation to all functions'"
echo "   'Consider adding multiply operation'"
echo
echo "2. Author updates and force-pushes"
echo
echo "3. Re-review with range-diff:"
echo "   \$ git fetch origin"
echo "   \$ git range-diff main..origin/feature@{1} main..origin/feature"
echo
echo "4. See exactly what changed without re-reviewing everything!"
pause

# -------------------------
announce "9. Three-Dot Syntax"

info "Shorthand when the bases are the same:"
echo
echo "Instead of:"
echo "  git range-diff A..B A..C"
echo
echo "You can write:"
echo "  git range-diff A..B...A..C"
echo
echo "The '...' connects the two ranges"
pause

# -------------------------
announce "10. Compare with Regular Diff"

info "Regular diff shows ALL differences between endpoints:"
run "git diff feature-v1 feature-v2 --stat"
pause

info "This doesn't tell us which commits changed!"
echo "Range-diff is commit-aware, showing the evolution"
pause

# -------------------------
announce "11. Using reflog References"

info "Use @{n} to reference previous branch states:"
echo
echo "# Before rebasing/amending"
echo "$ git rebase -i main"
echo
echo "# After rebasing, compare with previous state"
echo "$ git range-diff main..feature@{1} main..feature"
echo
echo "feature@{1} = where feature pointed before the last change"
pause

# -------------------------
announce "12. Stat Mode"

info "Get a summary with --stat:"
run "git range-diff --stat main..feature-v1 main..feature-v2"
pause

# -------------------------
announce "13. When to Use Range-Diff"

echo "Perfect for:"
echo "  ✅ Reviewing updated PRs after feedback"
echo "  ✅ Understanding what changed during rebase"
echo "  ✅ Comparing different implementations"
echo "  ✅ Verifying rebase didn't break anything"
echo "  ✅ Auditing force-pushed branches"
echo
echo "Not ideal for:"
echo "  ❌ Comparing completely different branches"
echo "  ❌ Very large changes (output gets noisy)"
pause

# -------------------------
announce "14. Tips for Effective Use"

echo "1. Keep commit messages consistent across rebases"
echo "   - Helps the algorithm match commits"
echo
echo "2. Save references before rebasing:"
echo "   \$ git branch feature-backup"
echo "   \$ git rebase main"
echo "   \$ git range-diff main..feature-backup main..feature"
echo
echo "3. In PR reviews, compare against previous push:"
echo "   \$ git fetch origin"
echo "   \$ git range-diff origin/main..feature@{push} origin/main..feature"
pause

# -------------------------
announce "15. Key Commands Summary"

echo "# Compare two commit ranges"
echo "$ git range-diff base..old base..new"
echo
echo "# After rebasing, compare with previous state"
echo "$ git range-diff main..branch@{1} main..branch"
echo
echo "# Compare PR iterations"
echo "$ git range-diff main..pr-v1 main..pr-v2"
echo
echo "# With statistics"
echo "$ git range-diff --stat base..v1 base..v2"
echo
echo "# Three-dot shorthand"
echo "$ git range-diff base..v1...base..v2"
pause

# End demo
end_demo \
  "range-diff compares commit ranges, not just endpoints" \
  "Shows which commits were added, removed, or modified" \
  "Essential for reviewing rebased branches" \
  "Use @{1} to reference previous branch states" \
  "Requires Git 2.19 or newer"
