#!/bin/bash
set -e
cd "$(dirname "$0")"
rm -rf .git plugins external-repos

git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"
git add . && git commit -m "feat: initial app with plugin system"

# Create external plugin repositories
mkdir -p external-repos

# Plugin 1: Math operations
mkdir -p external-repos/plugin-math
cd external-repos/plugin-math
git init
cat > index.js << 'EOF'
module.exports = {
  name: 'Math Plugin',
  add: (a, b) => a + b,
  subtract: (a, b) => a - b,
  multiply: (a, b) => a * b
};
EOF
git add . && git commit -m "feat: math plugin v1.0"
git tag v1.0
cd ../..

# Plugin 2: String operations
mkdir -p external-repos/plugin-string
cd external-repos/plugin-string
git init
cat > index.js << 'EOF'
module.exports = {
  name: 'String Plugin',
  reverse: (str) => str.split('').reverse().join(''),
  uppercase: (str) => str.toUpperCase()
};
EOF
git add . && git commit -m "feat: string plugin v1.0"
git tag v1.0
cd ../..

# Add as submodules (allow file protocol for local repos)
git -c protocol.file.allow=always submodule add ./external-repos/plugin-math plugins/math
git -c protocol.file.allow=always submodule add ./external-repos/plugin-string plugins/string
git commit -m "feat: add plugins as submodules"

echo "✅ Setup complete! Plugins added as submodules. Run ./demo.sh"
