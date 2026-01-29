#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

start_demo "Git Filter-Branch" "Rewrite history to remove files"

announce "😱 1. The Problem"
echo "Accidentally committed:"
echo "  • config.json with FAKE_API_KEY"
echo "  • logs/debug.log (1MB file)"
pause

announce "📊 2. Check Repository Size"
run "du -sh .git"
run "git log --oneline --stat"
pause

announce "⚠️  3. WARNING: History Rewriting"
warning "filter-branch rewrites history!"
warning "Only do this on unshared branches or coordinate with team"
pause

announce "🧹 4. Remove Large Log File"
run "git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch logs/debug.log' HEAD"
success "Large file removed from all commits!"
pause

announce "🔐 5. Remove Config with Secrets"
run "git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch config.json' HEAD"
success "Config file removed from history!"
pause

announce "📉 6. Check New Repository Size"
run "du -sh .git"
run "git log --oneline --stat"
info "Files removed, but .git still large (use git gc to fully clean)"
pause

end_demo \
  "filter-branch rewrites history" \
  "Use for removing sensitive data or large files" \
  "Coordinate with team - dangerous for shared repos"
