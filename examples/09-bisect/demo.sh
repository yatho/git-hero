#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

# ===============================
# Git Bisect Demo
# ===============================

start_demo "Git Bisect" "Find bugs automatically with binary search"

# -------------------------
announce "📋 1. The Problem: Our Game is Broken!"

info "Let's try the current version (v2.0.0)..."
echo
warning "Think of number 50 and watch what happens..."
pause
npm start
echo "The game should guess 50 first (midpoint of 1-100)"
echo "But it will guess 55 instead! The binary search is broken."
echo
pause

# -------------------------
announce "🔍 2. When Was It Working?"

run "git log --oneline"
echo
info "We have 13 commits. v1.0.0 was working, v2.0.0 is broken."
info "But which commit introduced the bug?"
pause

# -------------------------
announce "🎯 3. Start Git Bisect"

run "git bisect start"
run "git bisect bad"
info "Marked current version (v2.0.0) as bad"
pause

run "git bisect good v1.0.0"
info "Marked v1.0.0 as known good version"
echo
success "Git will now use binary search to find the bad commit!"
pause

# -------------------------
announce "🤖 4. Option A: Manual Testing"

info "Git checks out the middle commit for us to test..."
run "git status"
echo
warning "At this point, you would run: node number-guesser.js"
echo "Then mark as good or bad:"
echo "  • git bisect good  (if it works)"
echo "  • git bisect bad   (if it's broken)"
echo
echo "Git repeats this until it finds the exact commit."
echo
pause
npm start
pause
info "Let's say this commit was bad..."
run "git bisect bad"
pause
info "But there's a better way with automated testing..."
pause

# -------------------------
announce "⚡ 5. Option B: Automated Testing (BETTER!)"

run "git bisect reset"
info "Reset to try the automated approach..."
pause

run "git bisect start"
run "git bisect bad"
run "git bisect good v1.0.0"
pause

info "Now we use 'git bisect run' with our test script..."
run "git bisect run npm test"
echo
success "Git automatically found the bad commit!"
pause

# -------------------------
announce "🔬 6. Examine the Culprit"

info "Let's see what changed in the bad commit..."
echo "git show <bad-commit-hash>"
pause

echo
error "Found it! The bug is in the binarySearch function:"
echo "  Before: return Math.floor((low + high) / 2);"
echo "  After:  return Math.floor((low + high) / 2) + 5;  ← BUG!"
echo
info "Someone added '+5' which breaks the binary search algorithm"
pause

# -------------------------
announce "📊 7. Understanding the Power"

echo "With 8 commits, bisect found the bug in just 3 tests!"
echo
echo "Binary search efficiency:"
echo "  • 8 commits   → ~3 tests  (log2(8))"
echo "  • 100 commits → ~7 tests  (log2(100))"
echo "  • 1000 commits → ~10 tests (log2(1000))"
echo
success "Compare this to testing each commit linearly!"
pause

# -------------------------
announce "🔧 8. Clean Up and Fix"

run "git bisect reset"
info "Returned to the original HEAD (v2.0.0)"
pause

echo "Now you could fix the bug with:"
echo "  • git revert <bad-commit>  (safe, keeps history)"
echo "  • Create a new commit with the fix"
echo "  • git rebase -i to remove the bad commit (rewrites history)"
pause

# End demo
end_demo \
  "Git bisect uses binary search to find bugs in log2(n) steps" \
  "Use 'git bisect run <test-command>' for automated bisect" \
  "Tag known-good versions to make bisect easier" \
  "The bug was: adding +5 to the midpoint calculation"
