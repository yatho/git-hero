# Git Revert - Safely Undo Commits

This demo showcases how to safely undo commits without rewriting history, making it perfect for shared branches and production code.

## What You'll Learn

1. **git revert Basics** - Create new commits that undo changes
2. **Revert vs Reset** - When to use each command
3. **Reverting Multiple Commits** - Batch undoing changes
4. **Handling Conflicts** - Resolving revert conflicts
5. **Best Practices** - Safe collaboration patterns

## Key Commands Demonstrated

```bash
# Revert the last commit
git revert HEAD

# Revert specific commit
git revert <commit-hash>

# Revert without auto-commit (useful for multiple reverts)
git revert --no-commit HEAD

# Revert multiple commits
git revert --no-commit HEAD HEAD~1 HEAD~2
git commit -m 'Revert features X, Y, Z'

# Revert a range of commits
git revert HEAD~3..HEAD

# Handle conflicts
git revert --continue
git revert --abort
```

## Revert vs Reset

| Feature | git reset | git revert |
|---------|-----------|------------|
| Rewrites history | YES ⚠️ | NO ✅ |
| Safe for shared branches | NO ❌ | YES ✅ |
| Creates new commit | NO | YES |
| Best for | Local commits | Pushed commits |
| Team-friendly | NO | YES |

## Usage

```bash
# First time setup
./setup.sh

# Run the interactive demo
./demo.sh

# Reset everything
./reset.sh
```

## When to Use Revert

Use `git revert` when:
- Commits have been pushed to a shared branch
- Working with a team
- You need to preserve complete history
- Operating on production/main branches
- You want a safe, reversible operation

## When NOT to Use Revert

Don't use `git revert` when:
- Commits are local and not pushed (use `git reset` instead)
- You want to clean up history (use `git reset` or interactive rebase)
- Working alone on a feature branch

## How Revert Works

```
Original history:
A → B → C (buggy) → D

After git revert C:
A → B → C (buggy) → D → E (reverts C)
```

The buggy commit `C` stays in history, but commit `E` undoes all its changes.

## Advanced Patterns

### Revert Multiple Commits
```bash
# Revert last 3 commits as a single new commit
git revert --no-commit HEAD HEAD~1 HEAD~2
git commit -m 'Revert features X, Y, and Z'
```

### Revert a Merge Commit
```bash
# -m 1 keeps the main branch parent
git revert -m 1 <merge-commit-hash>
```

### Interactive Revert
```bash
# Review changes before committing
git revert --no-commit HEAD
# Edit files if needed
git commit
```

## Safety and Recovery

- Revert creates new commits, so it's always safe
- If you make a mistake, you can revert the revert!
- No data is lost - original commits remain in history
- Perfect for "oh no, we need to roll back NOW" situations

## Best Practices

1. ✅ Always use revert for pushed commits
2. ✅ Use `--no-edit` to accept default commit messages
3. ✅ Use `--no-commit` when reverting multiple commits
4. ✅ Test thoroughly after reverting
5. ✅ Document why you're reverting in the commit message
6. ✅ For merge commits, use the `-m` flag correctly
