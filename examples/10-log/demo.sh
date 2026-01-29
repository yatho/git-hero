#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

# ===============================
# Git Log & Grep Demo
# ===============================

start_demo "Git Log & Grep" "Master git history search and filtering"

# -------------------------
announce "📋 1. Basic Git Log Commands"

info "The simplest log view:"
run "git log --oneline"
echo
pause

info "More detailed view with graph (shows branching structure):"
run "git log --oneline --graph --all"
echo
echo "Notice: The graph shows feature branches and merge commits"
echo
pause

info "Show last 5 commits with details:"
run "git log -5"
echo
pause

# -------------------------
announce "🔍 2. Filtering by Author"

info "Find all commits by Alice:"
run "git log --oneline --author='Alice'"
echo
pause

info "Find commits by multiple authors (Alice OR Bob):"
run "git log --oneline --author='Alice\\|Bob'"
echo
pause

# -------------------------
announce "📅 3. Filtering by Date"

info "Commits since February 10, 2024:"
run "git log --oneline --since='2024-02-10'"
echo
pause

info "Commits in a date range:"
run "git log --oneline --since='2024-02-01' --until='2024-02-15'"
echo
pause

info "Commits from last week (relative dates):"
echo "git log --oneline --since='1 week ago'"
echo "(Not shown as demo uses fixed dates)"
echo
pause

# -------------------------
announce "🔎 4. Searching Commit Messages with --grep"

info "Find feature commits (case sensitive - lowercase only):"
run "git log --oneline --grep='feat'"
echo
pause

info "Find feature commits (case insensitive - both 'Feat' and 'feat'):"
run "git log --oneline --grep='feat' -i"
echo
echo "Notice: -i flag finds both 'Feat' and 'feat' commits"
echo
pause

info "Find CRITICAL or URGENT commits:"
run "git log --grep='CRITICAL\\|URGENT'"
echo
pause

# -------------------------
announce "📝 5. Searching Code Changes with -S and -G"

info "Find commits that added or removed 'validateTodoText':"
run "git log --oneline -S 'validateTodoText'"
echo
pause

info "Find commits that changed 'priority' (with regex):"
run "git log --oneline -G 'priority'"
echo
pause

info "Show the actual changes for 'completed' field:"
run "git log --oneline -S 'completed' -p"
echo "(Showing with -p to see the patch)"
echo
pause

# -------------------------
announce "🗂️ 6. Filtering by File or Directory"

info "Show commits that modified app.js:"
run "git log --oneline -- app.js"
echo
pause

info "Show commits that modified validation.js with details:"
run "git log --oneline -p -- validation.js"
echo
pause

# -------------------------
announce "🏷️ 7. Working with Tags"

info "List all tags:"
run "git tag"
echo
pause

info "Show commits between two tags:"
run "git log --oneline v1.0.0..v2.0.0"
echo
pause

info "Show what changed in v2.0.0:"
run "git show v2.0.0"
echo
pause

# -------------------------
announce "🎨 8. Custom Formatting"

info "Pretty format with author and date:"
run "git log --pretty=format:'%h - %an, %ar : %s' -10"
echo
echo "Format specifiers:"
echo "  %h  = short hash"
echo "  %an = author name"
echo "  %ar = author date (relative)"
echo "  %s  = subject (commit message)"
pause

info "One-line with date:"
run "git log --pretty=format:'%C(yellow)%h%C(reset) %C(blue)%ad%C(reset) - %s' --date=short -10"
echo
pause

# -------------------------
announce "🔗 9. Combining Filters (Advanced)"

info "Bug fixes by Alice in February:"
run "git log --oneline --author='Alice' --grep='fix' --since='2024-02-01' --until='2024-02-28'"
echo
pause

info "Features added to app.js by anyone except Demo User:"
run "git log --oneline --grep='feat' --author='^((?!Demo User).*)$' --perl-regexp -- app.js"
echo
pause

# -------------------------
announce "📊 10. Statistics and Analysis"

info "Show commit statistics:"
run "git log --oneline --stat -5"
echo
pause

info "Show shortstat summary:"
run "git log --oneline --shortstat -5"
echo
pause

info "Count commits by author:"
run "git shortlog -sn"
echo
pause

# -------------------------
announce "🎯 11. Practical Grep Patterns"

info "Find all work-in-progress commits:"
run "git log --oneline --grep='WIP' -i"
echo
pause

info "Find merge commits:"
run "git log --oneline --merges"
echo
echo "Shows: feature/priority and hotfix/validation branch merges"
echo
pause

info "Find non-merge commits only:"
run "git log --oneline --no-merges"
echo
pause

info "Find commits with issue references:"
run "git log --grep='#[0-9]\\+' --all"
echo
pause

# -------------------------
announce "🔍 12. Full-Text Search in Commit Contents"

info "Search for 'memory leak' in commit messages:"
run "git log --oneline --all --grep='memory leak' -i"
echo
pause

info "Find when 'createdAt' was added to code:"
run "git log --oneline -S 'createdAt' --source --all"
echo
pause

# -------------------------
announce "💡 13. Useful Aliases"

echo "You can create git aliases for common searches:"
echo
echo "git config --global alias.today 'log --oneline --since=\"00:00:00\"'"
echo "git config --global alias.features 'log --oneline --grep=feat -i'"
echo "git config --global alias.fixes 'log --oneline --grep=fix -i'"
echo "git config --global alias.lg 'log --graph --pretty=format:\"%C(yellow)%h%C(reset) - %s %C(blue)(%ar)%C(reset) %C(green)<%an>%C(reset)\"'"
echo
echo "Then use: git today, git features, git fixes, git lg"
pause

# -------------------------
announce "🚀 14. Pro Tips"

echo "1. Use --follow to track file renames:"
echo "   git log --follow -- oldfile.js"
echo
echo "2. Search in all branches:"
echo "   git log --all --grep='pattern'"
echo
echo "3. Combine -S with --all to search entire history:"
echo "   git log --all -S 'functionName'"
echo
echo "4. Use --reverse to see oldest commits first:"
echo "   git log --oneline --reverse"
echo
echo "5. Find commits that touched specific lines:"
echo "   git log -L 10,20:app.js"
echo
echo "6. Use --first-parent to follow main branch only:"
echo "   git log --first-parent --oneline"
pause

# End demo
end_demo \
  "git log --grep to search commit messages" \
  "git log -S 'text' to find when code was added/removed" \
  "git log --author to filter by contributor" \
  "Combine filters: --since, --until, --grep, --author, -- file" \
  "Use custom formats with --pretty for better readability"
