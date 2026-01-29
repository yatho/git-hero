#!/bin/bash
set -e
cd "$(dirname "$0")"
rm -rf .git notes-data.json
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Commit 1
cat > notes-data.json << 'EOF'
[{"id":1,"title":"First Note","content":"Hello World","created":"2024-01-01T10:00:00Z"}]
EOF
git add .
git commit -m "Initial commit: first note"

# Commit 2
cat > notes-data.json << 'EOF'
[{"id":1,"title":"First Note","content":"Hello World","created":"2024-01-01T10:00:00Z"},
 {"id":2,"title":"Ideas","content":"Add dark mode","created":"2024-01-02T10:00:00Z"}]
EOF
git add notes-data.json
git commit -m "Add ideas note"

# Create experimental branch with important work
git checkout -b experimental

# Commit 3
cat > notes-data.json << 'EOF'
[{"id":1,"title":"First Note","content":"Hello World","created":"2024-01-01T10:00:00Z"},
 {"id":2,"title":"Ideas","content":"Add dark mode","created":"2024-01-02T10:00:00Z"},
 {"id":3,"title":"Research","content":"Git reflog is amazing!","created":"2024-01-03T10:00:00Z"}]
EOF
git add notes-data.json
git commit -m "Add research note"

# Commit 4
cat > notes-data.json << 'EOF'
[{"id":1,"title":"First Note","content":"Hello World","created":"2024-01-01T10:00:00Z"},
 {"id":2,"title":"Ideas","content":"Add dark mode and search","created":"2024-01-02T10:00:00Z"},
 {"id":3,"title":"Research","content":"Git reflog is amazing!","created":"2024-01-03T10:00:00Z"},
 {"id":4,"title":"TODOs","content":"Finish presentation","created":"2024-01-04T10:00:00Z"}]
EOF
git add notes-data.json
git commit -m "Add TODO and update ideas"

git checkout main

echo "✅ Setup complete!"
echo "Repository with main and experimental branches created"
echo "Run ./demo.sh"
