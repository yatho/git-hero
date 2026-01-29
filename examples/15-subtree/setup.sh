#!/bin/bash
set -e
cd "$(dirname "$0")"
rm -rf .git lib external-repos

git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"
git add . && git commit -m "feat: initial main app"

# Create external utils library
mkdir -p external-repos/utils-lib
cd external-repos/utils-lib
git init
cat > index.js << 'EOF'
module.exports = {
  formatDate: (date) => date.toISOString(),
  slugify: (str) => str.toLowerCase().replace(/\s+/g, '-').replace(/[^\w-]/g, '')
};
EOF
cat > README.md << 'EOF'
# Utils Library
Shared utilities for multiple projects.
EOF
git add . && git commit -m "feat: utils library v1.0"
cd ../..

# Add as subtree
git remote add utils-lib ./external-repos/utils-lib
git subtree add --prefix=lib/utils utils-lib main --squash

echo "✅ Setup complete! Utils added as subtree. Run ./demo.sh"
