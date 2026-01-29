#!/bin/bash
set -e
cd "$(dirname "$0")"

# Clean up any existing setup
rm -rf .git patches *.patch
rm -f app.js utils.js config.json

# Initialize git repository
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Create initial files
cat > app.js << 'EOF'
const config = require('./config.json');
const utils = require('./utils');

function main() {
  console.log(`Starting ${config.name} v${config.version}`);

  const items = ['apple', 'banana', 'cherry'];
  items.forEach(item => {
    console.log(utils.capitalize(item));
  });
}

main();
EOF

cat > utils.js << 'EOF'
function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

function lowercase(str) {
  return str.toLowerCase();
}

module.exports = { capitalize, lowercase };
EOF

cat > config.json << 'EOF'
{
  "name": "patch-demo",
  "version": "1.0.0"
}
EOF

git add . && git commit -m "Initial commit: basic app structure"

# Second commit - add feature
cat >> utils.js << 'EOF'

function reverse(str) {
  return str.split('').reverse().join('');
}

module.exports.reverse = reverse;
EOF

git add . && git commit -m "feat: add reverse string utility"

# Third commit - update config
cat > config.json << 'EOF'
{
  "name": "patch-demo",
  "version": "1.1.0",
  "author": "Demo User"
}
EOF

git add . && git commit -m "chore: bump version and add author"

# Fourth commit - fix bug
cat > utils.js << 'EOF'
function capitalize(str) {
  if (!str) return '';
  return str.charAt(0).toUpperCase() + str.slice(1);
}

function lowercase(str) {
  if (!str) return '';
  return str.toLowerCase();
}

function reverse(str) {
  if (!str) return '';
  return str.split('').reverse().join('');
}

module.exports = { capitalize, lowercase, reverse };
EOF

git add . && git commit -m "fix: handle null/undefined input in utils"

# Fifth commit - add truncate
cat >> utils.js << 'EOF'

function truncate(str, maxLength) {
  if (!str) return '';
  if (str.length <= maxLength) return str;
  return str.slice(0, maxLength) + '...';
}

module.exports.truncate = truncate;
EOF

git add . && git commit -m "feat: add truncate utility function"

# Create patches directory
mkdir -p patches

echo "✅ Setup complete! Run ./demo.sh to start the demonstration"
