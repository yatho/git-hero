#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

start_demo "Git Stash" "Save work temporarily without commits"

announce "📝 1. Start Working on New Feature"
cat > email-templates.js << 'EOF'
#!/usr/bin/env node
const templates = {
  welcome: "Welcome {{name}}! Thanks for joining.",
  reminder: "Hi {{name}}, don't forget your meeting at {{time}}.",
  goodbye: "Goodbye {{name}}, we'll miss you!"
};

function render(template, data) {
  return template.replace(/\{\{(\w+)\}\}/g, (_, key) => data[key] || '');
}

// TODO : Adding new template

function demo() {
  console.log('Email Templates:');
  Object.entries(templates).forEach(([name, tmpl]) => {
    console.log(`\n${name}:`);
    console.log(render(tmpl, {name: 'Alice', time: '3pm'}));
  });
}

if (require.main === module) demo();
module.exports = { templates, render };
EOF

run "git status"
info "Work in progress, not ready to commit"
pause

announce "🚨 2. Urgent Bug Needs Fixing!"
warning "Can't commit incomplete work, can't switch branches..."
pause

announce "💾 3. Stash the Work"
run "git stash push -m 'WIP: new template feature'"
run "git status"
success "Working directory is clean!"
pause

announce "🔧 4. Fix the Bug"
echo "// Bug fix" >> email-templates.js
run "git add email-templates.js"
run "git commit -m 'fix: urgent bug'"
pause

announce "📋 5. List Stashes"
run "git stash list"
pause

announce "✅ 6. Restore Stashed Work"
run "git stash pop"
run "git status"
success "Work restored! Can continue feature development"
pause

end_demo \
  "Stash saves uncommitted work temporarily" \
  "Use descriptive messages with -m flag" \
  "git stash pop restores and removes from stash"
