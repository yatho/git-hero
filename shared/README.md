# Shared Demo Utilities

Common functions for interactive Git demonstrations in the Git Hero project.

## Overview

`demo-utils.sh` provides a consistent set of utilities for creating engaging, interactive Git demonstrations with typewriter effects, colored output, and user interaction controls.

## Usage

Source the utilities in your demo script:

```bash
#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

# Use the functions
announce "🎯 Demo Title"
run "git status"
pause
```

## Configuration

### Environment Variables

- `DELAY_BETWEEN_CHARS` - Delay between characters for typewriter effect (default: 0.09 seconds)
- `AUTO_PAUSE` - Enable/disable pauses (set to `false` with `--no-pause` flag)

### Command Line Flags

- `--no-pause` - Disable all pauses and typewriter effect for quick testing

Example:
```bash
./demo.sh --no-pause
```

## Core Functions

### typewriter
Display text with character-by-character typewriter effect.

```bash
typewriter "git status"
```

### run
Execute a command with typewriter effect and optional pause.

```bash
run "git log --oneline"           # Execute and pause
run "git checkout main" false     # Execute without pausing
```

### pause
Wait for user input. Allows entering ad-hoc commands during demo.

```bash
pause
```

**Interactive Feature:** During a pause, users can type commands to explore further. The command will be executed and another pause will follow.

### announce
Display section header with yellow highlighting.

```bash
announce "🔍 1. Finding the Bug with Git Bisect"
```

## Colored Output Functions

### success
Display green success message with checkmark.

```bash
success "Setup complete!"
```

### info
Display blue informational message.

```bash
info "Current branch: main"
```

### warning
Display yellow warning message.

```bash
warning "This will rewrite history!"
```

### error
Display red error message.

```bash
error "File not found"
```

## File Display Functions

### show_file
Display file contents with optional syntax highlighting (uses `bat` or `pygmentize` if available).

```bash
show_file "config.json"
```

### show_diff
Display git diff with enhanced formatting (uses `delta` if available).

```bash
show_diff                    # Show unstaged changes
show_diff --staged           # Show staged changes
show_diff main..feature      # Show branch differences
```

## Git Helper Functions

### git_log_pretty
Display formatted git log with graph.

```bash
git_log_pretty              # Last 10 commits
git_log_pretty 20           # Last 20 commits
```

### show_status
Display git status with informational header.

```bash
show_status
```

### show_branches
Display all branches with current branch highlighted.

```bash
show_branches
```

### show_current_commit
Display information about the current commit.

```bash
show_current_commit
```

## Utility Functions

### clear_screen
Clear screen with optional header.

```bash
clear_screen
clear_screen "Git Bisect Demo"
```

### confirm
Display yes/no confirmation prompt.

```bash
if confirm "Continue with rebase?"; then
    git rebase -i HEAD~5
fi
```

### separator
Display horizontal separator line.

```bash
separator
```

### box
Display text in a decorative box.

```bash
box "Git Hero" "Interactive Demonstrations" "NG Baguette Conf 2026"
```

## Demo Control Functions

### start_demo
Start demo with title and description in a box.

```bash
start_demo "Git Bisect" "Find bugs automatically with binary search"
```

### end_demo
End demo with summary and takeaways.

```bash
end_demo \
    "Git bisect finds bugs in log2(n) steps" \
    "Use 'git bisect run' for automated testing" \
    "Always tag known-good versions"
```

## Example Demo Script

```bash
#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

# Start demo
start_demo "Git Reflog" "Recover 'lost' commits with Git's safety net"

# Section 1
announce "📋 1. Create Some Commits"
run "echo 'Hello' > file.txt"
run "git add . && git commit -m 'Add file'"
pause

# Section 2
announce "😱 2. Accidentally Delete Branch"
run "git branch -D experimental"
pause

# Section 3
announce "🔧 3. Recover with Reflog"
run "git reflog"
run "git checkout -b experimental-recovered HEAD@{1}"
pause

# End demo
end_demo \
    "Reflog tracks all ref changes for 90 days" \
    "Use git reflog to find 'lost' commits" \
    "Git rarely loses data"
```

## Color Reference

| Function | Color | Icon |
|----------|-------|------|
| `success` | Green | ✅ |
| `info` | Blue | ℹ️ |
| `warning` | Yellow | ⚠️ |
| `error` | Red | ❌ |
| `announce` | Yellow | # |
| `run` | Green | $ |

## Dependencies

### Required
- Bash 4.0+
- Git 2.30+

### Optional (Enhanced Features)
- `bat` - Better syntax highlighting for `show_file`
- `delta` - Better diff display for `show_diff`
- `pygmentize` - Alternative syntax highlighting

Functions gracefully degrade to standard commands if optional tools are not available.

## Tips for Writing Demos

1. **Start with announce** - Begin each section with a clear header
2. **Use run for Git commands** - Shows command before executing
3. **Pause strategically** - Allow time for explanations and questions
4. **Add context** - Use info/warning before complex operations
5. **End with takeaways** - Summarize key learning points
6. **Test without pauses** - Use `--no-pause` for quick validation

## License

MIT

---

**Part of Git Hero for NG Baguette Conf 2026**
