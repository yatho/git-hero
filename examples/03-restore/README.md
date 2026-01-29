# Git Restore - Modern File Restoration

This demo showcases `git restore`, the modern replacement for `git checkout` when working with files. Introduced in Git 2.23, it provides a clearer, more intuitive way to restore files and manage your working tree.

## What You'll Learn

1. **Restoring Working Directory** - Discard local changes
2. **Unstaging Files** - Using `--staged` flag
3. **Restore from Commits** - Using `--source` option
4. **Modern vs Old Commands** - Migration guide
5. **Best Practices** - When and how to use restore

## Key Commands Demonstrated

```bash
# Discard changes in working directory
git restore <file>
git restore .

# Unstage file (keep changes in working directory)
git restore --staged <file>

# Discard all changes (staged and unstaged)
git restore --source=HEAD --staged --worktree <file>

# Restore from specific commit
git restore --source=<commit> <file>
git restore --source=HEAD~2 config.json

# Restore from another branch
git restore --source=feature-branch <file>

# Interactive restore
git restore -p <file>
```

## Restore vs Checkout vs Reset

| Task | git restore | git checkout | git reset |
|------|-------------|--------------|-----------|
| Discard changes | ✅ `restore` | `checkout --` | `reset --hard` |
| Unstage file | ✅ `--staged` | ❌ | `reset HEAD` |
| Modern/Clear | ✅ YES | Confusing | Powerful |
| Switch branch | ❌ NO | YES* | ❌ NO |

*Use `git switch` for switching branches (also introduced in Git 2.23)

## Usage

```bash
# First time setup
./setup.sh

# Run the interactive demo
./demo.sh

# Reset everything
./reset.sh
```

## Common Use Cases

### Discard Changes in Working Directory
```bash
# Single file
git restore config.json

# All files
git restore .

# Specific pattern
git restore '*.js'
```

### Unstage Files
```bash
# Unstage single file
git restore --staged app.js

# Unstage all files
git restore --staged .
```

### Restore from Different Sources
```bash
# From specific commit
git restore --source=abc123 file.js

# From 3 commits ago
git restore --source=HEAD~3 file.js

# From another branch
git restore --source=main config.json
```

### Complete Reset
```bash
# Discard all changes (staged and unstaged)
git restore --source=HEAD --staged --worktree .
```

## Restore Options

| Option | Description |
|--------|-------------|
| `--source=<tree>` | Restore from specific commit/branch (default: HEAD) |
| `--staged`, `-S` | Restore staging area (unstage files) |
| `--worktree`, `-W` | Restore working tree (default) |
| `--patch`, `-p` | Interactively select hunks to restore |
| `--ours`, `--theirs` | Resolve conflicts during merge |

## Migration from Old Commands

### Old → New

```bash
# Discard file changes
git checkout -- file.js
  → git restore file.js

# Get file from another branch
git checkout branch -- file.js
  → git restore --source=branch file.js

# Unstage file
git reset HEAD file.js
  → git restore --staged file.js

# Switch branches
git checkout branch-name
  → git switch branch-name
```

## Practical Scenarios

### Scenario 1: Oops, I Modified the Wrong File
```bash
git restore unwanted-changes.js
```

### Scenario 2: I Staged Too Many Files
```bash
# Unstage specific file
git restore --staged debug-code.js

# Or unstage everything
git restore --staged .
```

### Scenario 3: Get Config from Production Branch
```bash
git restore --source=production config.json
```

### Scenario 4: Completely Start Over
```bash
# Discard all changes (staged and unstaged)
git restore --source=HEAD --staged --worktree .
```

### Scenario 5: Partial File Restore
```bash
# Interactively choose what to restore
git restore -p app.js
```

## Best Practices

1. ✅ Use `restore` instead of `checkout` for file operations
2. ✅ Use `--staged` flag to unstage (clearer than `reset HEAD`)
3. ✅ Always run `git status` before restoring
4. ✅ Use `--source` to be explicit about source
5. ✅ Consider `-p` for interactive/partial restores
6. ✅ Remember: `restore` affects files only, not commits
7. ✅ Use `git switch` for branches, `git restore` for files

## Why Use Restore Instead of Checkout?

### Clarity
- `checkout` does too many things (branches, files, commits)
- `restore` is purpose-built for file operations
- `switch` is purpose-built for branches

### Safety
- Less chance of accidentally switching branches
- More explicit about what you're doing
- Clearer error messages

### Modern
- Introduced in Git 2.23 (2019)
- Part of Git's effort to simplify commands
- Better aligns with user mental models

## Important Notes

- `git restore` doesn't create commits or modify history
- Restoring discards changes - make sure that's what you want!
- Use `git stash` if you want to temporarily save changes
- Restore is local - doesn't affect remote or other users
- Works great with `.gitignore` patterns
