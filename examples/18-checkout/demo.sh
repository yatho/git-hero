#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

start_demo "Git Checkout" "Get files from other branches (unlike switch)"

announce "📋 1. The Situation"
echo "• main: basic app"
echo "• feature/api-integration: has api-client.js we want"
echo "• production/optimized-db: has optimized database.js"
echo ""
info "git switch changes branches, git checkout can grab individual files!"
pause

announce "📂 2. Current Files on Main"
run "ls -1"
run "cat config.js"
pause

announce "🌳 3. View All Branches"
run "git log --oneline --all --graph"
pause

announce "🎯 4. Checkout Single File from Feature Branch"
info "Get api-client.js without switching branches"
run "git checkout feature/api-integration -- api-client.js"
run "ls -1"
success "api-client.js is now in working directory!"
run "git status"
pause

announce "📊 5. See What We Got"
run "cat api-client.js"
info "File is staged and ready to commit"
pause

announce "🔧 6. Checkout Another File from Production Branch"
info "Get the optimized database config"
run "git checkout production/optimized-db -- database.js"
run "cat database.js"
success "Production database config retrieved!"
pause

announce "💾 7. Commit the Changes"
run "git commit -m 'feat: integrate API client with production database'"
run "git log --oneline"
pause

announce "🔄 8. Checkout Specific File Version"
info "Restore config.js to 2 commits ago"
run "git log --oneline config.js"
HASH=$(git log --oneline config.js | sed -n '2p' | awk '{print $1}')
run "git checkout $HASH -- config.js"
run "cat config.js"
success "File restored to previous version!"
pause

announce "♻️ 9. Discard Changes"
info "Restore config.js to HEAD"
run "git checkout HEAD -- config.js"
run "cat config.js"
pause

announce "✅ 10. Final State"
run "git log --oneline --all --graph -5"
run "ls -1"
pause

end_demo \
  "git checkout can grab files from any branch/commit" \
  "git checkout branch -- file: get file from branch" \
  "git checkout HEAD -- file: discard working changes" \
  "Unlike switch, checkout works at file level!"
