# Git Range-Diff - Compare Commit Ranges

This demo showcases `git range-diff`, which compares two sequences of commits. It's invaluable for reviewing rebased branches, understanding how a PR changed after review feedback, or comparing different implementations.

## What You'll Learn

1. **Basic Range-Diff** - Compare two commit ranges
2. **Review Rebases** - See what changed during rebase
3. **PR Iterations** - Compare PR versions after feedback
4. **Three-Dot Syntax** - Compare branch evolutions
5. **Color Coding** - Understand the output format

## Key Commands Demonstrated

```bash
# Compare two ranges
git range-diff base..old base..new

# Compare branch before/after rebase
git range-diff main..feature@{1} main..feature

# Three-dot syntax (shorthand)
git range-diff main..feature@{1}...main..feature

# Compare against upstream
git range-diff origin/main..origin/feature origin/main..feature
```

## Usage

```bash
# First time setup
./setup.sh

# Run the interactive demo
./demo.sh

# Reset everything
./reset.sh
```

## Understanding Range-Diff Output

```
1:  abc1234 = 1:  def5678 First commit message
2:  abc1235 ! 2:  def5679 Second commit (changed)
    @@ Commit message
     ## Some change description

    @@ file.js
     function example() {
    -  old code
    +  new code
     }
3:  abc1236 < -:  ------- Removed commit
-:  ------- > 3:  def567a New commit
```

Symbols:
- `=` : Identical commits
- `!` : Modified commits (same purpose, different content)
- `<` : Commit only in first range (removed)
- `>` : Commit only in second range (added)

## Common Use Cases

### Review What Changed After Rebase
```bash
# Before rebasing, save the reference
git branch feature-backup

# After rebasing
git range-diff main..feature-backup main..feature
```

### Compare PR Iterations
```bash
# Compare version 1 vs version 2 of a PR
git range-diff main..pr-v1 main..pr-v2
```

### Understand Force Push
```bash
# What changed in a force-pushed branch?
git range-diff origin/feature@{1}..feature origin/feature..feature
```

## Range-Diff Options

| Option | Description |
|--------|-------------|
| `--no-color` | Disable color output |
| `--stat` | Show diffstat |
| `--creation-factor=<n>` | Tune matching algorithm |
| `--left-only` | Show only left-side commits |
| `--right-only` | Show only right-side commits |

## Important Notes

- Range-diff is perfect for code review of rebased branches
- Use `@{n}` to reference previous states of a branch
- The algorithm tries to match commits by content similarity
- Works best when commit messages are preserved across rebases
- Requires Git 2.19 or newer
