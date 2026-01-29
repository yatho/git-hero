# Git Blame - Track Line-by-Line History

This demo showcases `git blame`, which shows who last modified each line of a file and when. Essential for understanding code evolution, debugging, and finding the right person to ask about code.

## What You'll Learn

1. **Basic Blame** - See who changed each line
2. **Ignore Whitespace** - Focus on real changes
3. **Date Ranges** - Blame at specific points in time
4. **Line Ranges** - Focus on specific sections
5. **Ignore Commits** - Skip formatting/refactoring commits
6. **Integration with Log** - Dig deeper into changes

## Key Commands Demonstrated

```bash
# Basic blame
git blame file.js

# Show email instead of name
git blame -e file.js

# Ignore whitespace changes
git blame -w file.js

# Blame specific lines
git blame -L 10,20 file.js

# Blame from a specific commit
git blame abc123 -- file.js

# Show commit that introduced the line
git blame -l file.js  # Full SHA

# Ignore specific commits (formatting, etc.)
git blame --ignore-rev abc123 file.js
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

## Common Use Cases

### Find Who Wrote This Code
```bash
git blame app.js | grep "buggy function"
```

### Understand Recent Changes
```bash
# Blame with relative dates
git blame --date=relative file.js
```

### Skip Formatting Commits
```bash
# Create ignore file for mass-formatting commits
echo "abc123" >> .git-blame-ignore-revs
git config blame.ignoreRevsFile .git-blame-ignore-revs
git blame file.js
```

### Find When a Bug Was Introduced
```bash
# Blame at specific points in time
git blame --since="2024-01-01" file.js
```

## Blame Output Explained

```
abc1234 (John Doe  2024-03-15 10:30 +0100  42) function calculateTotal() {
^^^^^^^  ^^^^^^^^^  ^^^^^^^^^^ ^^^^^        ^^   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  |         |           |       |           |              |
  |         |           |       |           |              +-- The actual line content
  |         |           |       |           +-- Line number
  |         |           |       +-- Timezone
  |         |           +-- Date and time
  |         +-- Author name
  +-- Commit SHA (short)
```

## Blame Options

| Option | Description |
|--------|-------------|
| `-L n,m` | Blame lines n to m only |
| `-L :function` | Blame specific function |
| `-e` | Show email instead of name |
| `-w` | Ignore whitespace |
| `-M` | Detect moved lines within file |
| `-C` | Detect copied lines from other files |
| `--since` | Ignore changes before date |
| `--ignore-rev` | Ignore specific commit |

## Important Notes

- Blame shows the **last** person who modified each line
- Use `-w` to ignore whitespace-only changes
- For bulk reformatting, use `.git-blame-ignore-revs`
- Combine with `git log -p` to see full change context
- IDE integrations make blame even more powerful
