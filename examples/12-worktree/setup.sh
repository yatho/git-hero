#!/bin/bash
set -e
cd "$(dirname "$0")"
rm -rf .git
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

git add . && git commit -m "feat: initial API docs generator"

# Create feature branch
git checkout -b feature/openapi
echo "// OpenAPI support" >> api-docs.js
git add api-docs.js && git commit -m "wip: OpenAPI format"

# Create PR review branch
git checkout main
git checkout -b pr-review
echo "// PR to review" >> api-docs.js
git add api-docs.js && git commit -m "feat: add examples"

git checkout main
echo "✅ Setup complete! Run ./demo.sh"
