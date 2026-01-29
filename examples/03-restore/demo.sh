#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

# ===============================
# Git Restore Demo
# ===============================

start_demo "Git Restore" "Modern way to restore files and working tree"

# -------------------------
announce "📋 1. Current State"

info "Git restore is the modern replacement for git checkout for file operations"
echo "Introduced in Git 2.23 (2019)"
pause

run "git log --oneline"
pause

run "ls -1"
pause

run "cat config.json"
pause

# -------------------------
announce "✏️ 2. Making Changes"

info "Let's modify some files..."

cat > config.json << 'EOF'
{
  "name": "my-app",
  "version": "2.0.0",
  "port": 9000,
  "database": {
    "host": "production-db.example.com",
    "port": 5432,
    "name": "prod_db"
  },
  "features": {
    "auth": true,
    "logging": true,
    "analytics": true
  }
}
EOF

cat > utils.js << 'EOF'
function formatDate(date) {
  return date.toLocaleDateString();
}

function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

function reverse(str) {
  return str.split('').reverse().join('');
}

module.exports = { formatDate, capitalize, reverse };
EOF

run "git status"
pause

# -------------------------
announce "🔄 3. Restore Working Directory"

info "Discard changes in working directory (unstaged changes)"
echo "Let's restore config.json to last committed state:"
pause

run "git restore config.json"
pause

run "git status"
pause

run "cat config.json"
echo
success "config.json restored to last commit!"
pause

# -------------------------
announce "📦 4. Staging and Restoring"

info "Let's stage the utils.js changes:"
run "git add utils.js"
pause

run "git status"
pause

info "Now modify utils.js again:"
cat > utils.js << 'EOF'
function formatDate(date) {
  return date.toLocaleDateString();
}

function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

function reverse(str) {
  return str.split('').reverse().join('');
}

// New function
function truncate(str, length) {
  return str.length > length ? str.slice(0, length) + '...' : str;
}

module.exports = { formatDate, capitalize, reverse, truncate };
EOF

run "git status"
echo
info "We have BOTH staged and unstaged changes!"
pause

# -------------------------
announce "🎯 5. Restore from Staging Area"

info "Restore working directory from staging area (not HEAD):"
run "git restore utils.js"
pause

run "git diff --staged"
echo
success "Working directory matches staging area!"
pause

# -------------------------
announce "♻️ 6. Unstage Files"

info "Use --staged to unstage files:"
run "git restore --staged utils.js"
pause

run "git status"
echo
success "File unstaged but changes still in working directory!"
pause

# -------------------------
announce "🗑️ 7. Discard Everything"

info "Restore from HEAD (discard all changes, staged and unstaged):"
run "git restore --source=HEAD --staged --worktree utils.js"
pause

run "git status"
pause

run "cat utils.js"
echo
success "All changes discarded!"
pause

# -------------------------
announce "⏮️ 8. Restore from Specific Commit"

info "You can restore files from any commit:"
run "git log --oneline"
pause

info "Restore config.json from first commit:"
FIRST_COMMIT=$(git log --oneline | tail -1 | awk '{print $1}')
run "git restore --source=$FIRST_COMMIT config.json"
pause

run "git status"
pause

run "cat config.json"
echo
success "Restored to version from first commit!"
pause

info "Let's discard this change:"
run "git restore config.json"
pause

# -------------------------
announce "📂 9. Restore Multiple Files"

info "Modify multiple files:"
cat > app.js << 'EOF'
const config = require('./config.json');
const utils = require('./utils');

console.log(`Starting ${config.name} v${config.version}`);
console.log(`Port: ${config.port}`);
console.log(`Time: ${utils.formatDate(new Date())}`);
EOF

cat > utils.js << 'EOF'
function formatDate(date) {
  return 'MODIFIED';
}

module.exports = { formatDate };
EOF

run "git status"
pause

info "Restore all modified files:"
run "git restore ."
pause

run "git status"
echo
success "All files restored!"
pause

# -------------------------
announce "🎨 10. Restore Patterns"

info "Create some test files:"
cat > test1.txt << 'EOF'
test file 1
EOF
cat > test2.txt << 'EOF'
test file 2
EOF
cat > data.json << 'EOF'
{"test": true}
EOF

run "git status"
pause

info "Restore only .txt files:"
echo "$ git restore '*.txt'"
echo "(Not running as files aren't tracked)"
pause

info "Restore specific directory:"
echo "$ git restore src/"
pause

# Clean up test files
rm -f test1.txt test2.txt data.json

# -------------------------
announce "🆚 11. Restore vs Checkout vs Reset"

echo "┌──────────────────┬────────────┬────────────┬────────────┐"
echo "│ Task             │ restore    │ checkout   │ reset      │"
echo "├──────────────────┼────────────┼────────────┼────────────┤"
echo "│ Discard changes  │ ✅ restore │ checkout   │ reset --hard│"
echo "│ Unstage file     │ ✅ --staged│ reset HEAD │ reset HEAD │"
echo "│ Modern/clear     │ ✅ YES     │ Confusing  │ Powerful   │"
echo "│ Switch branch    │ ❌ NO      │ YES*       │ ❌ NO      │"
echo "└──────────────────┴────────────┴────────────┴────────────┘"
echo
echo "* Use 'git switch' for switching branches (also modern)"
pause

# -------------------------
announce "📝 12. Common Restore Patterns"

echo "# Discard changes in working directory"
echo "$ git restore <file>"
echo "$ git restore ."
echo
echo "# Unstage file (keep changes in working directory)"
echo "$ git restore --staged <file>"
echo
echo "# Discard all changes (staged and unstaged)"
echo "$ git restore --source=HEAD --staged --worktree <file>"
echo
echo "# Restore from specific commit"
echo "$ git restore --source=<commit> <file>"
echo "$ git restore --source=HEAD~2 config.json"
echo
echo "# Restore from specific branch"
echo "$ git restore --source=main <file>"
pause

# -------------------------
announce "⚡ 13. Restore Options"

echo "Key options:"
echo
echo "  --source=<tree>    Restore from specific commit/branch"
echo "  --staged (-S)      Restore staging area (unstage)"
echo "  --worktree (-W)    Restore working tree (default)"
echo "  -p, --patch        Interactive restore (choose hunks)"
echo
pause

# -------------------------
announce "🎯 14. Practical Examples"

echo "Scenario 1: Accidentally staged wrong file"
echo "  $ git restore --staged unwanted.txt"
echo
echo "Scenario 2: Want to discard all local changes"
echo "  $ git restore ."
echo
echo "Scenario 3: Get file from another branch"
echo "  $ git restore --source=feature-branch -- config.json"
echo
echo "Scenario 4: Undo staging but keep changes"
echo "  $ git restore --staged ."
echo
echo "Scenario 5: Go back to version from 3 commits ago"
echo "  $ git restore --source=HEAD~3 oldfile.js"
pause

# -------------------------
announce "💡 15. Best Practices"

echo "✅ Use restore for file operations (not checkout)"
echo "✅ Use --staged to unstage (clearer than reset HEAD)"
echo "✅ Always check git status before restoring"
echo "✅ Use --source to be explicit about restore source"
echo "✅ Consider using -p for interactive restore"
echo "✅ Remember: restore only affects files, not commits"
pause

# -------------------------
announce "🔧 16. Migration from Old Commands"

echo "Old way → New way"
echo
echo "git checkout -- <file>"
echo "  → git restore <file>"
echo
echo "git checkout <branch> -- <file>"
echo "  → git restore --source=<branch> <file>"
echo
echo "git reset HEAD <file>"
echo "  → git restore --staged <file>"
echo
echo "git checkout <branch>"
echo "  → git switch <branch>"
pause

# End demo
end_demo \
  "git restore is the modern way to restore files" \
  "git restore <file> discards working directory changes" \
  "git restore --staged <file> unstages files" \
  "Use --source to restore from specific commits/branches" \
  "Clearer and safer than old git checkout for files" \
  "Use git switch for branches, git restore for files"
