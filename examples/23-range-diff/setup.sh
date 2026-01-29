#!/bin/bash
set -e
cd "$(dirname "$0")"

# Clean up any existing setup
rm -rf .git
rm -f app.js utils.js config.json

# Initialize git repository
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Create initial file on main
cat > app.js << 'EOF'
// Main application
function main() {
  console.log('Hello, World!');
}

main();
EOF

git add . && git commit -m "Initial commit"

# Create feature branch with several commits
git checkout -b feature

# Commit 1: Add utils
cat > utils.js << 'EOF'
function add(a, b) {
  return a + b;
}

module.exports = { add };
EOF
git add . && git commit -m "Add utils module"

# Commit 2: Add subtract
cat > utils.js << 'EOF'
function add(a, b) {
  return a + b;
}

function subtract(a, b) {
  return a - b;
}

module.exports = { add, subtract };
EOF
git add . && git commit -m "Add subtract function"

# Commit 3: Use utils in app
cat > app.js << 'EOF'
// Main application
const utils = require('./utils');

function main() {
  console.log('Hello, World!');
  console.log('2 + 3 =', utils.add(2, 3));
  console.log('5 - 2 =', utils.subtract(5, 2));
}

main();
EOF
git add . && git commit -m "Use utils in main app"

# Save original feature state
git branch feature-v1

# Now simulate updating after code review
# This creates a "rebased" version with changes

# Go back to main and add a commit (to simulate main moving forward)
git checkout main

cat > config.json << 'EOF'
{
  "name": "range-diff-demo",
  "version": "1.0.0"
}
EOF
git add . && git commit -m "Add config file"

# Create new feature branch from updated main
git checkout -b feature-v2

# Commit 1: Add utils (same as before)
cat > utils.js << 'EOF'
function add(a, b) {
  return a + b;
}

module.exports = { add };
EOF
git add . && git commit -m "Add utils module"

# Commit 2: Add subtract - but with input validation (reviewer feedback!)
cat > utils.js << 'EOF'
function add(a, b) {
  if (typeof a !== 'number' || typeof b !== 'number') {
    throw new Error('Arguments must be numbers');
  }
  return a + b;
}

function subtract(a, b) {
  if (typeof a !== 'number' || typeof b !== 'number') {
    throw new Error('Arguments must be numbers');
  }
  return a - b;
}

module.exports = { add, subtract };
EOF
git add . && git commit -m "Add subtract function with validation"

# Commit 3: Use utils in app (slightly modified)
cat > app.js << 'EOF'
// Main application
const utils = require('./utils');
const config = require('./config.json');

function main() {
  console.log(`Starting ${config.name} v${config.version}`);
  console.log('2 + 3 =', utils.add(2, 3));
  console.log('5 - 2 =', utils.subtract(5, 2));
}

main();
EOF
git add . && git commit -m "Use utils and config in main app"

# NEW Commit 4: Add multiply (new feature requested in review)
cat > utils.js << 'EOF'
function add(a, b) {
  if (typeof a !== 'number' || typeof b !== 'number') {
    throw new Error('Arguments must be numbers');
  }
  return a + b;
}

function subtract(a, b) {
  if (typeof a !== 'number' || typeof b !== 'number') {
    throw new Error('Arguments must be numbers');
  }
  return a - b;
}

function multiply(a, b) {
  if (typeof a !== 'number' || typeof b !== 'number') {
    throw new Error('Arguments must be numbers');
  }
  return a * b;
}

module.exports = { add, subtract, multiply };
EOF
git add . && git commit -m "Add multiply function"

# Go back to main
git checkout main

echo "✅ Setup complete! Run ./demo.sh to start the demonstration"
