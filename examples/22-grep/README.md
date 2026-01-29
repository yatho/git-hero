# Git Grep - Search Code in Your Repository

This demo showcases `git grep`, a powerful tool for searching code within your Git repository. It's faster than regular grep because it only searches tracked files and understands Git's index.

## What You'll Learn

1. **Basic Search** - Find text in tracked files
2. **Regex Patterns** - Use regular expressions
3. **Context Lines** - Show surrounding code
4. **File Filtering** - Limit search scope
5. **Search History** - Search across commits
6. **Combine with Log** - Find commits with changes

## Key Commands Demonstrated

```bash
# Basic search
git grep "pattern"

# Case insensitive
git grep -i "pattern"

# Show line numbers
git grep -n "pattern"

# Show context (3 lines before/after)
git grep -C 3 "pattern"

# Search specific file types
git grep "pattern" -- "*.js"

# Search in specific commit
git grep "pattern" abc123

# Count matches
git grep -c "pattern"

# Show only filenames
git grep -l "pattern"

# Extended regex
git grep -E "pattern1|pattern2"
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

## Git Grep vs Regular Grep

| Feature | git grep | grep/rg |
|---------|----------|---------|
| Searches tracked files only | Yes | No |
| Ignores .git directory | Yes | Manual |
| Respects .gitignore | Yes | No |
| Search specific commits | Yes | No |
| Faster on Git repos | Yes | Maybe |
| Works outside Git repo | No | Yes |

## Common Use Cases

### Find All TODO Comments
```bash
git grep -n "TODO"
git grep -n "FIXME\|TODO\|HACK"
```

### Find Function Definitions
```bash
git grep -n "function processOrder"
git grep -E "def\s+process_order"
```

### Find Hardcoded Values
```bash
git grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"  # IP addresses
git grep -E "password.*=.*['\"]"  # Hardcoded passwords
```

### Search in Specific Branches
```bash
git grep "pattern" main
git grep "pattern" feature-branch
```

### Search Across All Branches
```bash
git grep "pattern" $(git branch -a --format='%(refname:short)')
```

## Grep Options

| Option | Description |
|--------|-------------|
| `-n` | Show line numbers |
| `-i` | Case insensitive |
| `-w` | Match whole words only |
| `-l` | Show filenames only |
| `-c` | Show count per file |
| `-C n` | Show n context lines |
| `-B n` | Show n lines before |
| `-A n` | Show n lines after |
| `-E` | Extended regex (ERE) |
| `-P` | Perl regex (PCRE) |
| `-v` | Invert match |

## Important Notes

- `git grep` only searches tracked files
- Use `--` to separate patterns from paths
- Combine with `xargs` for bulk operations
- Use `-l` with `xargs git blame` for deep investigation
- Much faster than grep on large repositories
