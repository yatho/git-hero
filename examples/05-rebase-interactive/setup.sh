#!/bin/bash
set -e
cd "$(dirname "$0")"
rm -rf .git todos.json
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Create messy commit history
cat > todos.json << 'EOF'
[{"id":1,"task":"Buy groceries","done":false}]
EOF
git add . && git commit -m "feat: add todo app basic structure"

echo '[{"id":1,"task":"Buy groceries","done":false},{"id":2,"task":"Call dentist","done":false}]' > todos.json
git add todos.json && git commit -m "WIP: add feature"

echo '[{"id":1,"task":"Buy groceries","done":false},{"id":2,"task":"Call dentist","done":false},{"id":3,"task":"Finish project","done":false}]' > todos.json
git add todos.json && git commit -m "WIP: still working"

echo '[{"id":1,"task":"Buy groceries","done":true},{"id":2,"task":"Call dentist","done":false},{"id":3,"task":"Finish project","done":false}]' > todos.json
git add todos.json && git commit -m "feat: add complete functionality"

echo '[{"id":1,"task":"Buy groc eries","done":true},{"id":2,"task":"Call dentist","done":false},{"id":3,"task":"Finish project","done":false}]' > todos.json
git add todos.json && git commit -m "typo fix"

echo '[{"id":1,"task":"Buy groceries","done":true},{"id":2,"task":"Call dentist","done":false},{"id":3,"task":"Finish project","done":false}]' > todos.json
git add todos.json && git commit -m "fix typo"

echo '[{"id":1,"task":"Buy groceries","done":true},{"id":2,"task":"Call dentist","done":false},{"id":3,"task":"Finish project","done":false},{"id":4,"task":"Read book","done":false}]' > todos.json
git add todos.json && git commit -m "add filtering"

echo '[{"id":1,"task":"Buy groceries","done":true},{"id":2,"task":"Call dentist","done":false},{"id":3,"task":"Finish project","done":false},{"id":4,"task":"Read book","done":false},{"id":5,"task":"Exercise","done":false}]' > todos.json
git add todos.json && git commit -m "fixup for filtering"

echo "✅ Setup complete! Messy history with 8 commits. Run ./demo.sh"
