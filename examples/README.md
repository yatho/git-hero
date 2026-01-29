# Git Hero - Simple Examples

18 standalone demonstrations of powerful Git features, each taking 3-5 minutes.

Perfect for learning, teaching, and presenting at conferences!

**Examples are organized by presentation track** - see oral.md for the complete 1-hour presentation guide.

## Quick Navigation

### Block 1: Daily Developer Workflow
| # | Feature | App | Key Learning | Time |
|---|---------|-----|--------------|------|
| 01 | [Stash](./01-stash/) | Email Templates | Save work temporarily without commits | 3-4 min |
| 02 | [Merge](./02-merge/) | Shopping Cart | Resolve merge conflicts effectively | 3-4 min |
| 03 | [Restore](./03-restore/) | File Operations | Modern file restoration commands | 4-5 min |
| 04 | [Reflog](./04-reflog/) | Note Taker | Recover "lost" commits | 3-4 min |

### Block 2: Clean History
| # | Feature | App | Key Learning | Time |
|---|---------|-----|--------------|------|
| 05 | [Rebase Interactive](./05-rebase-interactive/) | Todo List | Clean up commit history | 4-5 min |
| 06 | [Fixup](./06-fixup/) | Calculator | Mark commits for automatic squashing | 3-4 min |
| 07 | [Reset](./07-reset/) | Reset Modes | Understand --soft, --mixed, --hard | 4-5 min |
| 08 | [Revert](./08-revert/) | Safe Undo | Safely undo commits without rewriting history | 4-5 min |

### Block 3: Debugging & Investigation
| # | Feature | App | Key Learning | Time |
|---|---------|-----|--------------|------|
| 09 | [Bisect](./09-bisect/) | Number Guesser | Find bugs automatically with binary search | 3-4 min |
| 10 | [Log](./10-log/) | History Search | Search and filter git history | 4-5 min |
| 11 | [Diff](./11-diff/) | Diff Viewing | Master viewing changes | 4-5 min |

### Block 4: Advanced Workflows
| # | Feature | App | Key Learning | Time |
|---|---------|-----|--------------|------|
| 12 | [Worktree](./12-worktree/) | API Docs | Work on multiple branches simultaneously | 4-5 min |
| 13 | [Cherry-pick](./13-cherry-pick/) | Weather CLI | Select specific commits across branches | 3-4 min |
| 14 | [Submodules](./14-submodules/) | Plugin System | Version-pin external dependencies | 4-5 min |
| 15 | [Subtree](./15-subtree/) | Shared Utils | Simpler alternative to submodules | 4-5 min |
| 16 | [Filter-branch](./16-filter-branch/) | Logger | Rewrite history to remove files/secrets | 4-5 min |
| 17 | [Rerere](./17-rerere/) | Recipe Book | Reuse recorded conflict resolutions | 4-5 min |
| 18 | [Checkout](./18-checkout/) | File Operations | Legacy file-level operations | 3-4 min |

## Prerequisites

Before running any example:

- **Node.js:** 18.0.0 or higher
- **Git:** 2.30 or higher
- **Terminal:** bash-compatible shell
- **Time:** 3-5 minutes per example

Check your versions:
```bash
node --version    # Should be v18.0.0+
git --version     # Should be 2.30+
```

## How to Use

Each example is completely self-contained with its own Git repository.

### Basic Usage

```bash
cd {example-directory}
./setup.sh    # Initialize demo scenario (creates commits, branches, etc.)
./demo.sh     # Run interactive demonstration with typewriter effect
./reset.sh    # Clean up for next run
```

### Example Session

```bash
# Try the stash example (first in presentation order)
cd 01-stash
./setup.sh
# ✅ Setup complete!

./demo.sh
# Interactive demo begins...
# Press Enter to advance through steps
# Or type commands to explore on your own

./reset.sh
# 🔄 Reset complete!
```

### Quick Testing Mode

Disable pauses and typewriter effect for faster testing:

```bash
./demo.sh --no-pause
```

## Running Multiple Examples

### Sequential Demos (for presentations)

```bash
# Run demos in presentation order (Block 1: Daily Workflow)
for dir in 01-stash 02-merge 03-restore 04-reflog; do
  cd "$dir"
  ./setup.sh
  ./demo.sh
  cd ..
done
```

### Setup All Examples

```bash
# Prepare all examples
for dir in */; do
  cd "$dir"
  if [ -f "setup.sh" ]; then
    ./setup.sh
  fi
  cd ..
done
```

## Presentation Tracks

**NEW:** See [oral.md](../oral.md) for the complete 1-hour presentation guide organized by themes.

### Block 1: Daily Developer Workflow (15 minutes)
Essential Git skills for daily development:

1. **[01-stash](./01-stash/)** - Save work temporarily (3 min)
2. **[02-merge](./02-merge/)** - Resolve conflicts (4 min)
3. **[03-restore](./03-restore/)** - Modern file operations (4 min)
4. **[04-reflog](./04-reflog/)** - Git's safety net (4 min)

### Block 2: Clean History (15 minutes)
Professional Git workflows for clean commit history:

1. **[05-rebase-interactive](./05-rebase-interactive/)** - Clean history (4 min)
2. **[06-fixup](./06-fixup/)** - Smart fixup workflow (4 min)
3. **[07-reset](./07-reset/)** - Understand reset modes (4 min)
4. **[08-revert](./08-revert/)** - Safe undo (3 min)

### Block 3: Debugging & Investigation (15 minutes)
Find and understand issues:

1. **[09-bisect](./09-bisect/)** - Find bugs fast (4 min)
2. **[10-log](./10-log/)** - Search history (4 min)
3. **[11-diff](./11-diff/)** - Master diff viewing (4 min)

### Block 4: Advanced Workflows (10 minutes)
Power user features:

1. **[12-worktree](./12-worktree/)** - Parallel development (4 min)
2. **[13-cherry-pick](./13-cherry-pick/)** - Selective commits (3 min)
3. **[14-submodules](./14-submodules/)** - Version dependencies (quick mention)
4. **[15-subtree](./15-subtree/)** - Simpler submodules (quick mention)
5. **[16-filter-branch](./16-filter-branch/)** - History rewriting (quick mention)

### Complete Tour (60 minutes)
All 18 examples in the new thematic order for comprehensive coverage.

### Workshop Format
Hands-on learning:
- Students follow along with simple examples
- Practice each Git feature individually
- Build confidence before tackling complex projects

## Example Structure

Each example directory contains:

```
example-name/
├── README.md               # Complete documentation
├── package.json            # Node.js configuration (minimal dependencies)
├── {app-name}.js          # Simple CLI application
├── {app-name}.test.js     # Tests (for automated bisect, etc.)
├── setup.sh               # Creates Git scenario
├── demo.sh                # Interactive demonstration
└── reset.sh               # Cleanup script
```

## Applications Used

Each example uses a different simple Node.js CLI application to keep things interesting:

- **Number Guesser** - Binary search game (demonstrates bisect)
- **Shopping Cart** - E-commerce calculator (demonstrates merge)
- **Recipe Book** - Recipe manager (demonstrates rerere)
- **Todo List** - Task tracker (demonstrates rebase)
- **Calculator** - Basic math operations (demonstrates fixup)
- **Weather CLI** - Weather forecasts (demonstrates cherry-pick)
- **Note Taker** - Note management (demonstrates reflog)
- **Email Templates** - Template generator (demonstrates stash)
- **API Docs** - Documentation generator (demonstrates worktree)
- **Logger** - Application logger (demonstrates filter-branch)
- **Plugin System** - Extensible app (demonstrates submodules)
- **Shared Utils** - Utility library (demonstrates subtree)

All apps are intentionally simple - the focus is on Git, not the code!

## Interactive Features

### During Pauses

While a demo is paused (waiting for Enter), you can:

1. **Press Enter** - Continue to next step
2. **Type a command** - Execute it and see the result
3. **Explore freely** - Try variations of the demo commands

Example:
```bash
# Demo pauses after showing git status
# You can type:
git log --oneline      # Explore commit history
git branch -a          # See all branches
# Press Enter when ready to continue
```

### Ad-hoc Exploration

The demos encourage experimentation! The pause system allows:
- Testing variations of commands
- Exploring repository state at any point
- Answering audience questions live

## Shared Utilities

All demos use common utilities from `../shared/demo-utils.sh`:

- **Typewriter effect** - Character-by-character command display
- **Colored output** - Success, info, warning, error messages
- **Git helpers** - Pretty logs, status, branch displays
- **Interactive pauses** - Audience-friendly flow control

See [../shared/README.md](../shared/README.md) for full documentation.

## Tips for Presenters

1. **Practice first** - Run each demo 2-3 times to internalize the flow
2. **Explain the "why"** - Git commands are powerful when context is clear
3. **Pause for questions** - The pause system makes this natural
4. **Show mistakes** - Demonstrate recovery techniques (reflog, etc.)
5. **Compare before/after** - Show problem, then solution
6. **Use --no-pause for setup** - Quick validation before presenting

## Troubleshooting

### Demo won't start
```bash
# Check if setup was run
./setup.sh

# Check file permissions
chmod +x setup.sh demo.sh reset.sh
```

### Commands not found
```bash
# Verify Git installation
git --version

# Verify Node.js installation
node --version
```

### Typewriter effect too slow/fast
Edit `../shared/demo-utils.sh`:
```bash
DELAY_BETWEEN_CHARS=0.05  # Faster
DELAY_BETWEEN_CHARS=0.15  # Slower
```

### Demo state is broken
```bash
# Reset and start fresh
./reset.sh
./setup.sh
./demo.sh
```

## Related Projects

### git-conf/ - Complex Angular Demo
This repository also contains a full Angular application demonstration in `../git-conf/`:

- **Scope**: Comprehensive 45-60 minute demo
- **Complexity**: Real-world production application
- **Features**: Multiple Git features integrated together
- **Audience**: Developers familiar with Angular

The `examples/` directory (this one) complements `git-conf/` by:
- Breaking features into focused demonstrations
- Using simple, easy-to-understand apps
- Allowing modular presentation (pick and choose)
- Providing hands-on workshop material

## Contributing

Improvements welcome! Each example should:

- ✅ Take 3-5 minutes to demonstrate
- ✅ Use a simple, understandable Node.js app
- ✅ Focus on ONE Git feature clearly
- ✅ Include comprehensive README.md
- ✅ Work independently of other examples
- ✅ Use shared utilities for consistency

## Credits

Created for **NG Baguette Conf 2026** - Angular Conference in Paris

- **Date:** May 29, 2026
- **Focus:** Git workflows for modern development
- **Approach:** Learning through simple, practical examples

## License

MIT

---

## Quick Links

- [Shared Utilities Documentation](../shared/README.md)
- [Git-Conf Complex Demo](../git-conf/README.md)
- [Git Hero Main README](../README.md)

**Happy Git Learning! 🚀**
