#!/bin/bash
set -e

echo "🔧 Setting up Git Log & Grep demonstration..."
echo

# Navigate to example directory
cd "$(dirname "$0")"

# Remove existing git repo if any
rm -rf .git

# Initialize new repo
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# ==========================================
# Create a realistic project history
# ==========================================

echo "Creating project history with various commit types..."

# Commit 1: Initial project setup
cat > app.js << 'EOF'
// Simple Todo App
const todos = [];

function addTodo(text) {
  todos.push({ text, completed: false });
}

function listTodos() {
  return todos;
}

module.exports = { addTodo, listTodos };
EOF

cat > package.json << 'EOF'
{
  "name": "todo-app",
  "version": "0.1.0",
  "description": "A simple todo application",
  "main": "app.js"
}
EOF

git add .
GIT_AUTHOR_DATE="2024-01-15 10:00:00" GIT_COMMITTER_DATE="2024-01-15 10:00:00" \
git commit -m "Feat: initial project setup

Initialize todo app with basic structure"

# Commit 2: Add delete functionality
cat > app.js << 'EOF'
// Simple Todo App
const todos = [];

function addTodo(text) {
  todos.push({ text, completed: false });
  return todos.length - 1;
}

function deleteTodo(index) {
  if (index >= 0 && index < todos.length) {
    todos.splice(index, 1);
    return true;
  }
  return false;
}

function listTodos() {
  return todos;
}

module.exports = { addTodo, deleteTodo, listTodos };
EOF

git add app.js
GIT_AUTHOR_DATE="2024-01-16 14:30:00" GIT_COMMITTER_DATE="2024-01-16 14:30:00" \
git commit -m "feat: add delete todo functionality"

# Commit 3: Fix bug in delete
cat > app.js << 'EOF'
// Simple Todo App
const todos = [];

function addTodo(text) {
  if (!text || text.trim() === '') {
    throw new Error('Todo text cannot be empty');
  }
  todos.push({ text, completed: false });
  return todos.length - 1;
}

function deleteTodo(index) {
  if (index >= 0 && index < todos.length) {
    todos.splice(index, 1);
    return true;
  }
  return false;
}

function listTodos() {
  return todos;
}

module.exports = { addTodo, deleteTodo, listTodos };
EOF

git add app.js
git config user.name "Alice Smith"
git config user.email "alice@example.com"
GIT_AUTHOR_DATE="2024-01-17 09:15:00" GIT_COMMITTER_DATE="2024-01-17 09:15:00" \
git commit -m "fix: validate empty todo text

Fixes #42 - crash when adding empty todo"

# Commit 4: Add toggle complete
cat > app.js << 'EOF'
// Simple Todo App
const todos = [];

function addTodo(text) {
  if (!text || text.trim() === '') {
    throw new Error('Todo text cannot be empty');
  }
  todos.push({ text, completed: false });
  return todos.length - 1;
}

function deleteTodo(index) {
  if (index >= 0 && index < todos.length) {
    todos.splice(index, 1);
    return true;
  }
  return false;
}

function toggleTodo(index) {
  if (index >= 0 && index < todos.length) {
    todos[index].completed = !todos[index].completed;
    return true;
  }
  return false;
}

function listTodos() {
  return todos;
}

module.exports = { addTodo, deleteTodo, toggleTodo, listTodos };
EOF

git add app.js
git config user.name "Bob Johnson"
git config user.email "bob@example.com"
GIT_AUTHOR_DATE="2024-01-18 16:45:00" GIT_COMMITTER_DATE="2024-01-18 16:45:00" \
git commit -m "Feat: implement toggle complete functionality

Users can now mark todos as complete/incomplete"

# Commit 5: Refactor - extract validation
cat > validation.js << 'EOF'
function validateTodoText(text) {
  if (!text || text.trim() === '') {
    throw new Error('Todo text cannot be empty');
  }
  return text.trim();
}

module.exports = { validateTodoText };
EOF

cat > app.js << 'EOF'
// Simple Todo App
const { validateTodoText } = require('./validation');
const todos = [];

function addTodo(text) {
  const validText = validateTodoText(text);
  todos.push({ text: validText, completed: false });
  return todos.length - 1;
}

function deleteTodo(index) {
  if (index >= 0 && index < todos.length) {
    todos.splice(index, 1);
    return true;
  }
  return false;
}

function toggleTodo(index) {
  if (index >= 0 && index < todos.length) {
    todos[index].completed = !todos[index].completed;
    return true;
  }
  return false;
}

function listTodos() {
  return todos;
}

module.exports = { addTodo, deleteTodo, toggleTodo, listTodos };
EOF

git add .
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"
GIT_AUTHOR_DATE="2024-01-19 11:20:00" GIT_COMMITTER_DATE="2024-01-19 11:20:00" \
git commit -m "refactor: extract validation to separate module

Improves code organization and reusability"

# Tag version 1.0.0
git tag -a v1.0.0 -m "Release 1.0.0 - Basic functionality"

# Create a feature branch for priority work
git switch -c feature/priority

# Commit 6: Add priority feature (on feature branch)
cat > app.js << 'EOF'
// Simple Todo App
const { validateTodoText } = require('./validation');
const todos = [];

function addTodo(text, priority = 'normal') {
  const validText = validateTodoText(text);
  todos.push({ text: validText, completed: false, priority });
  return todos.length - 1;
}

function deleteTodo(index) {
  if (index >= 0 && index < todos.length) {
    todos.splice(index, 1);
    return true;
  }
  return false;
}

function toggleTodo(index) {
  if (index >= 0 && index < todos.length) {
    todos[index].completed = !todos[index].completed;
    return true;
  }
  return false;
}

function listTodos() {
  return todos;
}

module.exports = { addTodo, deleteTodo, toggleTodo, listTodos };
EOF

git add app.js
git config user.name "Charlie Davis"
git config user.email "charlie@example.com"
GIT_AUTHOR_DATE="2024-02-01 13:00:00" GIT_COMMITTER_DATE="2024-02-01 13:00:00" \
git commit -m "feat: add priority levels to todos

Implements #45 - Support for high/normal/low priority"

# Commit 7: Performance optimization
cat > app.js << 'EOF'
// Simple Todo App
const { validateTodoText } = require('./validation');
const todos = [];
let nextId = 1;

function addTodo(text, priority = 'normal') {
  const validText = validateTodoText(text);
  const todo = {
    id: nextId++,
    text: validText,
    completed: false,
    priority,
    createdAt: new Date()
  };
  todos.push(todo);
  return todo.id;
}

function deleteTodo(id) {
  const index = todos.findIndex(t => t.id === id);
  if (index !== -1) {
    todos.splice(index, 1);
    return true;
  }
  return false;
}

function toggleTodo(id) {
  const todo = todos.find(t => t.id === id);
  if (todo) {
    todo.completed = !todo.completed;
    return true;
  }
  return false;
}

function listTodos() {
  return todos;
}

module.exports = { addTodo, deleteTodo, toggleTodo, listTodos };
EOF

git add app.js
git config user.name "Alice Smith"
git config user.email "alice@example.com"
GIT_AUTHOR_DATE="2024-02-05 10:30:00" GIT_COMMITTER_DATE="2024-02-05 10:30:00" \
git commit -m "perf: use IDs instead of indices for todos

Improves performance and prevents index shifting issues"

# Switch back to main and add a commit there
git switch main

# Commit on main: Add documentation while feature branch is in progress
cat > USAGE.md << 'EOF'
# Todo App

A simple but powerful todo application.

## Features

- Add todos
- Mark todos as complete
- Delete todos
- List all todos

## Usage

```javascript
const { addTodo, toggleTodo, listTodos } = require('./app');

// Add a todo
const id = addTodo('Buy groceries');

// Toggle completion
toggleTodo(id);

// List all todos
console.log(listTodos());
```
EOF

git add USAGE.md
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"
GIT_AUTHOR_DATE="2024-02-03 15:00:00" GIT_COMMITTER_DATE="2024-02-03 15:00:00" \
git commit -m "docs: add basic usage documentation"

# Merge the feature branch back to main
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"
GIT_AUTHOR_DATE="2024-02-06 09:00:00" GIT_COMMITTER_DATE="2024-02-06 09:00:00" \
git merge --no-ff feature/priority -m "Merge branch 'feature/priority'

Brings in priority levels and ID-based todo management"

# Commit 8: CRITICAL BUG FIX
cat > app.js << 'EOF'
// Simple Todo App
const { validateTodoText } = require('./validation');
const todos = [];
let nextId = 1;

function addTodo(text, priority = 'normal') {
  const validText = validateTodoText(text);
  const todo = {
    id: nextId++,
    text: validText,
    completed: false,
    priority,
    createdAt: new Date()
  };
  todos.push(todo);
  return todo.id;
}

function deleteTodo(id) {
  const index = todos.findIndex(t => t.id === id);
  if (index !== -1) {
    const deleted = todos.splice(index, 1);
    return deleted[0];
  }
  return null;
}

function toggleTodo(id) {
  const todo = todos.find(t => t.id === id);
  if (todo) {
    todo.completed = !todo.completed;
    return true;
  }
  return false;
}

function listTodos() {
  return [...todos];
}

module.exports = { addTodo, deleteTodo, toggleTodo, listTodos };
EOF

git add app.js
git config user.name "Bob Johnson"
git config user.email "bob@example.com"
GIT_AUTHOR_DATE="2024-02-06 08:00:00" GIT_COMMITTER_DATE="2024-02-06 08:00:00" \
git commit -m "CRITICAL: fix memory leak in listTodos

Returns copy instead of reference to prevent mutations
Fixes production crash reported by multiple users"

# Commit 9: Update documentation to include priority
cat > USAGE.md << 'EOF'
# Todo App

A simple but powerful todo application.

## Features

- Add todos with priority levels
- Mark todos as complete
- Delete todos
- List all todos

## Usage

```javascript
const { addTodo, toggleTodo, listTodos } = require('./app');

// Add a todo with priority
const id = addTodo('Buy groceries', 'high');

// Toggle completion
toggleTodo(id);

// List all todos
console.log(listTodos());
```
EOF

git add USAGE.md
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"
GIT_AUTHOR_DATE="2024-02-10 15:00:00" GIT_COMMITTER_DATE="2024-02-10 15:00:00" \
git commit -m "docs: update usage with priority feature examples"

# Commit 10: Add filter functionality
cat > app.js << 'EOF'
// Simple Todo App
const { validateTodoText } = require('./validation');
const todos = [];
let nextId = 1;

function addTodo(text, priority = 'normal') {
  const validText = validateTodoText(text);
  const todo = {
    id: nextId++,
    text: validText,
    completed: false,
    priority,
    createdAt: new Date()
  };
  todos.push(todo);
  return todo.id;
}

function deleteTodo(id) {
  const index = todos.findIndex(t => t.id === id);
  if (index !== -1) {
    const deleted = todos.splice(index, 1);
    return deleted[0];
  }
  return null;
}

function toggleTodo(id) {
  const todo = todos.find(t => t.id === id);
  if (todo) {
    todo.completed = !todo.completed;
    return true;
  }
  return false;
}

function listTodos(filter = 'all') {
  const copy = [...todos];
  if (filter === 'active') {
    return copy.filter(t => !t.completed);
  }
  if (filter === 'completed') {
    return copy.filter(t => t.completed);
  }
  return copy;
}

module.exports = { addTodo, deleteTodo, toggleTodo, listTodos };
EOF

git add app.js
git config user.name "Charlie Davis"
git config user.email "charlie@example.com"
GIT_AUTHOR_DATE="2024-02-12 14:20:00" GIT_COMMITTER_DATE="2024-02-12 14:20:00" \
git commit -m "feat: add filter functionality for listing todos

Supports filtering by all/active/completed"

# Tag version 2.0.0
git tag -a v2.0.0 -m "Release 2.0.0 - Filter and Priority features"

# Create a hotfix branch for urgent validation fix
git switch -c hotfix/validation

# Commit 11: Hotfix for production (on hotfix branch)
cat > validation.js << 'EOF'
function validateTodoText(text) {
  if (!text || typeof text !== 'string' || text.trim() === '') {
    throw new Error('Todo text must be a non-empty string');
  }
  if (text.length > 500) {
    throw new Error('Todo text too long (max 500 characters)');
  }
  return text.trim();
}

module.exports = { validateTodoText };
EOF

git add validation.js
git config user.name "Alice Smith"
git config user.email "alice@example.com"
GIT_AUTHOR_DATE="2024-02-14 09:00:00" GIT_COMMITTER_DATE="2024-02-14 09:00:00" \
git commit -m "hotfix: add length validation to prevent DB overflow

URGENT: Production issue with oversized todos causing database errors"

# Switch back to main for parallel work
git switch main

# Commit 12: WIP - search feature (on main, parallel to hotfix)
cat > search.js << 'EOF'
// TODO: Implement search functionality
function searchTodos(query) {
  // Work in progress
  return [];
}

module.exports = { searchTodos };
EOF

git add search.js
git config user.name "Bob Johnson"
git config user.email "bob@example.com"
GIT_AUTHOR_DATE="2024-02-13 16:00:00" GIT_COMMITTER_DATE="2024-02-13 16:00:00" \
git commit -m "WIP: start implementing search feature

Not ready for production yet"

# Commit 13: Tests
cat > app.test.js << 'EOF'
const { addTodo, toggleTodo, listTodos } = require('./app');

describe('Todo App', () => {
  test('should add todo', () => {
    const id = addTodo('Test todo');
    const todos = listTodos();
    expect(todos.length).toBe(1);
  });

  test('should toggle todo', () => {
    const id = addTodo('Another test');
    toggleTodo(id);
    const todos = listTodos();
    expect(todos.find(t => t.id === id).completed).toBe(true);
  });
});
EOF

git add app.test.js
git config user.name "Bob Johnson"
git config user.email "bob@example.com"
GIT_AUTHOR_DATE="2024-02-15 11:00:00" GIT_COMMITTER_DATE="2024-02-15 11:00:00" \
git commit -m "test: add unit tests for core functionality"

# Merge hotfix branch back to main
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"
GIT_AUTHOR_DATE="2024-02-16 10:00:00" GIT_COMMITTER_DATE="2024-02-16 10:00:00" \
git merge --no-ff hotfix/validation -m "Merge branch 'hotfix/validation'

Urgent fix for validation issue in production"

# Commit 14: Chore - update dependencies
cat > package.json << 'EOF'
{
  "name": "todo-app",
  "version": "2.1.0",
  "description": "A simple todo application",
  "main": "app.js",
  "scripts": {
    "test": "jest"
  },
  "devDependencies": {
    "jest": "^29.0.0"
  }
}
EOF

git add package.json
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"
GIT_AUTHOR_DATE="2024-02-20 10:00:00" GIT_COMMITTER_DATE="2024-02-20 10:00:00" \
git commit -m "chore: update dependencies and add test script"

# Commit 15: Merge conflict simulation setup
cat > config.js << 'EOF'
module.exports = {
  maxTodos: 100,
  defaultPriority: 'normal'
};
EOF

git add config.js
git config user.name "Charlie Davis"
git config user.email "charlie@example.com"
GIT_AUTHOR_DATE="2024-02-22 13:30:00" GIT_COMMITTER_DATE="2024-02-22 13:30:00" \
git commit -m "feat: add configuration file for app settings"

echo
echo "✅ Setup complete!"
echo
echo "Git repository created with branching history:"
echo "  • Multiple authors (Demo User, Alice, Bob, Charlie)"
echo "  • Various commit types (Feat, feat, fix, refactor, docs, test, chore, hotfix)"
echo "  • Feature branches (feature/priority, hotfix/validation)"
echo "  • Merge commits to demonstrate --graph and --merges"
echo "  • Commits with special markers (CRITICAL, WIP, URGENT)"
echo "  • Two version tags (v1.0.0, v2.0.0)"
echo "  • Case-sensitive commits (Feat vs feat) for -i demo"
echo
echo "Run the demo with: ./demo.sh"
echo "Or explore manually:"
echo "  git log --oneline --graph --all"
echo "  git log --oneline --merges"
echo
