#!/bin/bash
set -e
cd "$(dirname "$0")"

# Reinitialize email-templates.js with initial content
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

rm -rf .git
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"
git add .
git commit -m "Initial email templates"
echo "✅ Setup complete! Run ./demo.sh"

