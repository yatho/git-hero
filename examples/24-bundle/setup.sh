#!/bin/bash
set -e
cd "$(dirname "$0")"

# Clean up any existing setup
rm -rf .git source-repo received-repo bundles
rm -f *.bundle

# Create source repository
mkdir -p source-repo
cd source-repo

git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Create initial content
cat > app.js << 'EOF'
// Simple application
console.log('Hello from the source repository!');
EOF

cat > README.md << 'EOF'
# Bundle Demo Project

This project demonstrates git bundle functionality.

## Features
- Feature 1
- Feature 2
EOF

git add . && git commit -m "Initial commit"

# Add more commits
cat >> app.js << 'EOF'

function greet(name) {
  return `Hello, ${name}!`;
}

module.exports = { greet };
EOF
git add . && git commit -m "Add greet function"

# Tag for incremental bundle demo
git tag v1.0

cat > utils.js << 'EOF'
function formatDate(date) {
  return date.toISOString().split('T')[0];
}

module.exports = { formatDate };
EOF
git add . && git commit -m "Add utils module"

# Create a feature branch
git checkout -b feature-login

cat > auth.js << 'EOF'
function login(username, password) {
  // TODO: Implement actual authentication
  return { user: username, token: 'abc123' };
}

function logout() {
  return { success: true };
}

module.exports = { login, logout };
EOF
git add . && git commit -m "Add authentication module"

cat >> auth.js << 'EOF'

function validateToken(token) {
  return token && token.length > 0;
}

module.exports.validateToken = validateToken;
EOF
git add . && git commit -m "Add token validation"

# Back to main and add more commits
git checkout main

cat >> README.md << 'EOF'

## Getting Started
1. Clone the repository
2. Run npm install
3. Run npm start
EOF
git add . && git commit -m "Update README with getting started"

cat > config.json << 'EOF'
{
  "name": "bundle-demo",
  "version": "1.0.0",
  "port": 3000
}
EOF
git add . && git commit -m "Add configuration"

# Tag the current state
git tag v1.1

cd ..

# Create bundles directory
mkdir -p bundles

echo "✅ Setup complete! Run ./demo.sh to start the demonstration"
