# Git Log & Grep - Searching Git History

Learn how to effectively search and filter git commit history using `git log` and various grep patterns.

## What You'll Learn

- **Basic log viewing**: `--oneline`, `--graph`, `--all`
- **Filter by author**: Find commits by specific contributors
- **Filter by date**: Search commits in date ranges
- **Search messages**: Use `--grep` to find commits by message content
- **Search code changes**: Use `-S` and `-G` to find when code was added/removed
- **Filter by file**: See history for specific files
- **Work with tags**: Compare versions and releases
- **Custom formatting**: Create readable output formats
- **Combine filters**: Advanced multi-criteria searches
- **Statistics**: Analyze commit patterns and contributions

## Quick Start

```bash
# Setup the demo repository
./setup.sh

# Run the interactive demonstration
./demo.sh

# Clean up when done
./reset.sh
```

## Demo Repository Structure

The setup creates a realistic git history with:
- 15 commits from multiple authors
- Various commit types: feat, fix, refactor, docs, test, chore, hotfix
- Two version tags: v1.0.0, v2.0.0
- Special markers: CRITICAL, WIP, URGENT
- Multiple files: app.js, validation.js, config.js, etc.

## Essential Git Log Commands

### Basic Viewing
```bash
# Simple one-line format
git log --oneline

# With graph visualization
git log --oneline --graph --all

# Last N commits
git log -5
```

### Filter by Author
```bash
# Commits by specific author
git log --author="Alice"

# Multiple authors (OR)
git log --author="Alice\|Bob"
```

### Filter by Date
```bash
# Since a date
git log --since="2024-02-01"

# Date range
git log --since="2024-02-01" --until="2024-02-15"

# Relative dates
git log --since="1 week ago"
git log --since="2 days ago"
```

### Search Commit Messages
```bash
# Find by keyword (case sensitive)
git log --grep="fix"

# Case insensitive
git log --grep="FIX" -i

# Multiple patterns (OR)
git log --grep="CRITICAL\|URGENT"

# Regex patterns
git log --grep="#[0-9]+"
```

### Search Code Changes
```bash
# Find when text was added/removed (-S)
git log -S "validateTodoText"

# Find changes matching regex (-G)
git log -G "priority.*:"

# Show the actual changes
git log -S "completed" -p
```

### Filter by File
```bash
# Commits that modified a file
git log -- app.js

# With changes shown
git log -p -- validation.js

# Follow file renames
git log --follow -- oldname.js
```

### Work with Tags
```bash
# List tags
git tag

# Commits between tags
git log v1.0.0..v2.0.0

# Show tag details
git show v2.0.0
```

### Custom Formatting
```bash
# Custom format
git log --pretty=format:"%h - %an, %ar : %s"

# With colors
git log --pretty=format:"%C(yellow)%h%C(reset) - %s"

# Format specifiers:
# %h  = short hash
# %H  = full hash
# %an = author name
# %ae = author email
# %ad = author date
# %ar = author date (relative)
# %s  = subject (message)
# %b  = body
```

### Statistics
```bash
# Commit statistics
git log --stat

# Short statistics
git log --shortstat

# Commits by author
git shortlog -sn
```

## Combining Filters

```bash
# Bug fixes by Alice in February
git log --author="Alice" --grep="fix" --since="2024-02-01" --until="2024-02-28"

# Features added to app.js
git log --grep="feat" -- app.js

# All changes except merge commits
git log --oneline --no-merges
```

## Useful Aliases

Add these to your git config:

```bash
# Today's commits
git config --global alias.today 'log --oneline --since="00:00:00"'

# Feature commits
git config --global alias.features 'log --oneline --grep=feat -i'

# Bug fixes
git config --global alias.fixes 'log --oneline --grep=fix -i'

# Pretty log
git config --global alias.lg 'log --graph --pretty=format:"%C(yellow)%h%C(reset) - %s %C(blue)(%ar)%C(reset) %C(green)<%an>%C(reset)"'
```

## Pro Tips

1. **Search all branches**: Add `--all` to search entire repository
   ```bash
   git log --all --grep="pattern"
   ```

2. **Reverse chronological order**: See oldest commits first
   ```bash
   git log --reverse
   ```

3. **Track specific line changes**: Find commits that changed specific lines
   ```bash
   git log -L 10,20:app.js
   ```

4. **Follow main branch only**: Ignore merged branches
   ```bash
   git log --first-parent
   ```

5. **Exclude patterns**: Find commits NOT matching a pattern
   ```bash
   git log --grep="pattern" --invert-grep
   ```

6. **Machine-readable output**: For scripts
   ```bash
   git log --pretty=format:"%H,%an,%ad,%s" --date=iso
   ```

## Common Use Cases

### Find when a bug was introduced
```bash
git log -S "buggyFunction" --source --all
```

### Find all emergency fixes
```bash
git log --grep="CRITICAL\|URGENT\|HOTFIX" -i
```

### See what changed between releases
```bash
git log --oneline v1.0.0..v2.0.0
```

### Find commits with issue references
```bash
git log --grep="#[0-9]\+" --oneline
```

### Review work from last week
```bash
git log --author="$(git config user.name)" --since="1 week ago" --oneline
```

### Find large commits
```bash
git log --shortstat | grep -E "files? changed"
```

## Resources

- `git help log` - Complete git log documentation
- `git help grep` - Git's built-in grep command
- `man git-log` - Man page with all options

## What's Next?

After mastering git log and grep, explore:
- **git bisect**: Binary search to find bugs (see examples/01-bisect)
- **git reflog**: Recovery and history of HEAD movements
- **git blame**: Find who changed each line in a file
- **git diff**: Compare changes between commits
