# Git Reset - Understanding --soft, --mixed, and --hard

This demo showcases the three modes of `git reset` and when to use each one.

## What You'll Learn

1. **git reset --soft** - Move HEAD, keep changes staged
2. **git reset --mixed** - Move HEAD, unstage changes (default)
3. **git reset --hard** - Move HEAD, discard all changes ⚠️
4. **Practical Use Cases** - When to use each mode
5. **Safety with Reflog** - How to recover from mistakes
6. **Reset vs Revert** - When to use each command

## Key Commands Demonstrated

```bash
# Unstage files (default is --mixed)
git reset
git reset HEAD <file>

# Undo last commit, keep changes staged
git reset --soft HEAD~1

# Undo last commit, keep changes unstaged
git reset HEAD~1
git reset --mixed HEAD~1

# Undo last commit, discard changes (DANGEROUS)
git reset --hard HEAD~1

# Go to specific commit
git reset --hard <commit-hash>

# View reflog for recovery
git reflog
```

## Reset Modes Comparison

| Mode | HEAD Moves | Staging Area | Working Directory |
|------|-----------|--------------|-------------------|
| `--soft` | ✅ | Unchanged | Unchanged |
| `--mixed` | ✅ | Cleared | Unchanged |
| `--hard` | ✅ | Cleared | Cleared ⚠️ |

## Usage

```bash
# First time setup
./setup.sh

# Run the interactive demo
./demo.sh

# Reset everything
./reset.sh
```

## Important Notes

- **NEVER** use `git reset` on commits that have been pushed to shared branches
- Use `git revert` for shared/pushed commits instead
- `git reset --hard` is destructive - use with caution
- Reflog keeps commits for ~90 days, allowing recovery
- Reset rewrites history, revert creates new commits

## When to Use Each Mode

### --soft
- Combine multiple commits into one
- Redo commit message
- Keep all changes staged for recommit

### --mixed (default)
- Unstage files
- Split one commit into multiple commits
- Reorganize what goes into each commit

### --hard
- Completely discard local changes
- Return to a clean state
- **WARNING**: Cannot be undone (unless using reflog)
