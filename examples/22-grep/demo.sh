#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

cd "$SCRIPT_DIR"

# ===============================
# Git Grep Demo
# ===============================

start_demo "Git Grep" "Search code in your Git repository"

# -------------------------
announce "1. Project Structure"

info "We have a typical Node.js project:"
run "find . -type f -name '*.js' | grep -v .git"
pause

# -------------------------
announce "2. Basic Search"

info "Find all occurrences of 'TODO':"
run "git grep TODO"
pause

info "This shows filename:line content for each match"
pause

# -------------------------
announce "3. Show Line Numbers"

info "Add line numbers with -n:"
run "git grep -n TODO"
pause

# -------------------------
announce "4. Case Insensitive Search"

info "Search case-insensitively with -i:"
run "git grep -i fixme"
pause

# -------------------------
announce "5. Count Matches"

info "Count matches per file with -c:"
run "git grep -c TODO"
pause

info "Total TODOs in the project:"
run "git grep -c TODO | awk -F: '{sum += \$2} END {print sum}'"
pause

# -------------------------
announce "6. List Files Only"

info "Show only filenames with matches (-l):"
run "git grep -l TODO"
pause

info "Useful for piping to other commands"
pause

# -------------------------
announce "7. Show Context"

info "Show 2 lines before and after each match:"
run "git grep -C 2 'validateEmail'"
pause

info "Or use -B (before) and -A (after) separately:"
run "git grep -B 1 -A 3 'hashPassword'"
pause

# -------------------------
announce "8. Search Specific Files"

info "Search only in JavaScript files:"
run "git grep -n TODO -- '*.js'"
pause

info "Search only in test files:"
run "git grep -n TODO -- 'tests/**'"
pause

# -------------------------
announce "9. Extended Regex"

info "Use extended regex with -E:"
run "git grep -E 'TODO|FIXME|HACK'"
pause

info "Find function definitions:"
run "git grep -P 'function\\s+\\w+\\(' -- '*.js'"
pause

# -------------------------
announce "10. Word Boundary"

info "Match whole words only with -w:"
echo "Without -w (matches 'order' in 'orderService'):"
run "git grep -n order -- 'src/controllers/*.js' | head -5"
pause

echo "With -w (whole word only):"
run "git grep -nw order -- 'src/controllers/*.js'"
pause

# -------------------------
announce "11. Invert Match"

info "Show lines that DON'T match with -v:"
run "git grep -v '//' -- 'src/utils/logger.js' | head -15"
pause

# -------------------------
announce "12. Search in Specific Commit"

info "Search in a specific commit:"
FIRST_COMMIT=$(git log --oneline | tail -1 | awk '{print $1}')
run "git grep -n TODO $FIRST_COMMIT"
pause

info "Useful for comparing what TODOs existed at different points"
pause

# -------------------------
announce "13. Find Deprecated Code"

info "Search for deprecated markers:"
run "git grep -n DEPRECATED"
pause

# -------------------------
announce "14. Find Potential Issues"

info "Find hardcoded ports:"
run "git grep -E '[0-9]{4,5}' -- '*.js' | head -10"
pause

info "Find console.log statements:"
run "git grep -n 'console\\.' -- 'src/**/*.js'"
pause

# -------------------------
announce "15. Search Multiple Patterns"

info "Search for multiple patterns in one command:"
run "git grep -E 'require|import' -- 'src/app.js'"
pause

# -------------------------
announce "16. Practical: Find Security Issues"

info "Find potential password handling:"
run "git grep -in password -- '*.js'"
pause

info "Find hardcoded secrets patterns:"
run "git grep -E '(api_key|secret|token).*=' -- '*.js'"
pause

# -------------------------
announce "17. Combine with Other Commands"

info "Find TODOs and blame them:"
echo "$ git grep -l TODO | xargs -I {} git blame {} | grep TODO"
pause

info "Find files with TODOs and count lines:"
run "git grep -l TODO | xargs wc -l"
pause

# -------------------------
announce "18. Git Grep vs Regular Grep"

echo "git grep advantages:"
echo "  ✅ Only searches tracked files"
echo "  ✅ Automatically ignores .git directory"
echo "  ✅ Respects .gitignore patterns"
echo "  ✅ Can search specific commits/branches"
echo "  ✅ Faster on large repositories"
echo
echo "Regular grep/ripgrep advantages:"
echo "  ✅ Works outside Git repositories"
echo "  ✅ More familiar syntax for some"
echo "  ✅ ripgrep has better Unicode support"
pause

# -------------------------
announce "19. Key Commands Summary"

echo "# Basic search"
echo "$ git grep 'pattern'"
echo "$ git grep -n 'pattern'          # with line numbers"
echo "$ git grep -i 'pattern'          # case insensitive"
echo
echo "# Scope limiting"
echo "$ git grep 'pattern' -- '*.js'   # specific files"
echo "$ git grep 'pattern' src/        # specific directory"
echo
echo "# Output control"
echo "$ git grep -l 'pattern'          # filenames only"
echo "$ git grep -c 'pattern'          # count per file"
echo "$ git grep -C 3 'pattern'        # with context"
echo
echo "# Advanced"
echo "$ git grep -E 'pat1|pat2'        # extended regex"
echo "$ git grep -w 'word'             # whole word"
echo "$ git grep 'pattern' HEAD~5      # in specific commit"
pause

# End demo
end_demo \
  "git grep searches only tracked files" \
  "Use -n for line numbers, -l for filenames only" \
  "Use -E for extended regex patterns" \
  "Search specific commits with git grep pattern <commit>" \
  "Faster than grep on Git repositories"
