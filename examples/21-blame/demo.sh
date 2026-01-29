#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

cd "$SCRIPT_DIR"

# ===============================
# Git Blame Demo
# ===============================

start_demo "Git Blame" "Track who changed each line and when"

# -------------------------
announce "1. Current Repository State"

info "Let's see our commit history:"
run "git log --oneline"
pause

info "Current file content:"
run "cat calculator.js"
pause

# -------------------------
announce "2. Basic Blame"

info "See who last modified each line:"
run "git blame calculator.js"
pause

info "Understanding the output:"
echo "  - First column: commit SHA (short)"
echo "  - Second: author name"
echo "  - Third: date/time"
echo "  - Fourth: line number"
echo "  - Fifth: actual line content"
pause

# -------------------------
announce "3. Show Emails"

info "Show email addresses instead of names:"
run "git blame -e calculator.js"
pause

# -------------------------
announce "4. Blame Specific Lines"

info "Focus on specific line range (lines 13-20):"
run "git blame -L 13,20 calculator.js"
pause

info "These are the divide function lines"
echo "Notice: Alice added the zero check, Carol added the original function"
pause

# -------------------------
announce "5. The Formatting Problem"

info "Notice something odd about the blame?"
echo "DevOps Bot appears for many lines..."
pause

run "git log --oneline | grep Format"
echo
info "A formatting commit changed whitespace on many lines!"
echo "This makes blame less useful - we see the formatter, not the original author"
pause

# -------------------------
announce "6. Ignore Whitespace Changes"

info "Use -w to ignore whitespace-only changes:"
run "git blame -w calculator.js"
pause

info "Now we see the REAL authors who wrote the logic!"
pause

# -------------------------
announce "7. Ignore Specific Commits"

info "For bulk formatting commits, use --ignore-rev:"
FORMAT_COMMIT=$(cat .formatting-commit)
echo "Format commit: $FORMAT_COMMIT"
pause

run "git blame --ignore-rev $FORMAT_COMMIT calculator.js"
pause

# -------------------------
announce "8. Permanent Ignore File"

info "For team-wide ignore, create .git-blame-ignore-revs:"
echo "$FORMAT_COMMIT" > .git-blame-ignore-revs
run "cat .git-blame-ignore-revs"
pause

info "Configure git to use it:"
echo "$ git config blame.ignoreRevsFile .git-blame-ignore-revs"
git config blame.ignoreRevsFile .git-blame-ignore-revs
pause

info "Now blame automatically ignores those commits:"
run "git blame calculator.js"
pause

# -------------------------
announce "9. Show Full Commit SHA"

info "Use -l for full SHA (useful for scripts):"
run "git blame -l calculator.js | head -10"
pause

# -------------------------
announce "10. Different Date Formats"

info "Relative dates:"
run "git blame --date=relative calculator.js"
pause

info "Short dates:"
run "git blame --date=short calculator.js"
pause

# -------------------------
announce "11. Blame a Function"

info "Blame a specific function by name:"
run "git blame -L :divide calculator.js"
pause

info "This finds the function and shows only those lines!"
pause

# -------------------------
announce "12. Detect Moved/Copied Code"

info "Use -M to detect moved lines within file:"
echo "$ git blame -M calculator.js"
pause

info "Use -C to detect copied lines from other files:"
echo "$ git blame -C calculator.js"
pause

info "Use -C -C -C to be even more aggressive:"
echo "$ git blame -C -C -C calculator.js"
echo
echo "This is useful when code is refactored between files"
pause

# -------------------------
announce "13. Blame at Specific Commit"

info "See blame at an earlier point in time:"
EARLY_COMMIT=$(git log --oneline | tail -3 | head -1 | awk '{print $1}')
echo "Looking at commit: $EARLY_COMMIT"
run "git blame $EARLY_COMMIT -- calculator.js"
pause

# -------------------------
announce "14. Combine with Log"

info "Found a suspicious line? Dig deeper:"
echo
echo "1. Get the commit SHA from blame:"
COMMIT=$(git blame -l calculator.js | grep "power" | head -1 | awk '{print $1}')
echo "   Found commit: $COMMIT"
pause

info "2. See the full commit:"
run "git show --stat $COMMIT"
pause

# -------------------------
announce "15. Practical Workflow"

echo "Debugging a bug? Here's the workflow:"
echo
echo "1. Find the problematic line"
echo "   $ git blame file.js | grep 'buggy code'"
echo
echo "2. Get the commit that introduced it"
echo "   abc123 (Author  2024-01-15) buggy code"
echo
echo "3. See what else changed in that commit"
echo "   $ git show abc123"
echo
echo "4. Check the commit message for context"
echo "   $ git log -1 abc123"
echo
echo "5. Ask the author if needed!"
pause

# -------------------------
announce "16. IDE Integration"

echo "Most IDEs have built-in blame (git lens):"
echo
echo "  VS Code: GitLens extension"
echo "  JetBrains: Annotate (right-click gutter)"
echo "  vim: :Git blame (with fugitive plugin)"
echo
echo "Benefits:"
echo "  - Hover to see commit details"
echo "  - Click to see full diff"
echo "  - Inline annotations"
pause

# -------------------------
announce "17. Key Commands Summary"

echo "# Basic blame"
echo "$ git blame file.js"
echo
echo "# Ignore whitespace"
echo "$ git blame -w file.js"
echo
echo "# Specific lines"
echo "$ git blame -L 10,20 file.js"
echo "$ git blame -L :functionName file.js"
echo
echo "# Ignore formatting commits"
echo "$ git blame --ignore-rev abc123 file.js"
echo "$ echo 'abc123' >> .git-blame-ignore-revs"
echo
echo "# Different date formats"
echo "$ git blame --date=relative file.js"
echo "$ git blame --date=short file.js"
pause

# Cleanup
rm -f .git-blame-ignore-revs
git config --unset blame.ignoreRevsFile 2>/dev/null || true

# End demo
end_demo \
  "git blame shows who last modified each line" \
  "Use -w to ignore whitespace-only changes" \
  "Create .git-blame-ignore-revs for bulk format commits" \
  "Use -L to focus on specific lines or functions" \
  "Combine with git log/show for full context"
