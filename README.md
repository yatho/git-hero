# Git Hero

> Master Git's powerful features through interactive demonstrations

Git Hero is a comprehensive collection of Git demonstrations for **NG Baguette Conf 2026** - making advanced Git features accessible through simple, practical examples.

## What's Inside

This repository contains two complementary approaches to learning Git:

### 📚 Simple Examples (`examples/`)

**24 focused demonstrations** - Each example isolates a specific Git feature:

| Feature                                                  | App             | Key Learning                      |
| -------------------------------------------------------- | --------------- | --------------------------------- |
| [01-stash](examples/01-stash/)                           | Email Templates | Temporary work storage            |
| [02-merge](examples/02-merge/)                           | -               | Resolve merge conflicts           |
| [03-restore](examples/03-restore/)                       | -               | Modern file restoration           |
| [04-reflog](examples/04-reflog/)                         | Notes App       | Recover "lost" commits            |
| [05-rebase-interactive](examples/05-rebase-interactive/) | Todo List       | Clean commit history              |
| [06-fixup](examples/06-fixup/)                           | Calculator      | Automatic commit squashing        |
| [07-reset](examples/07-reset/)                           | -               | Understanding reset modes         |
| [08-revert](examples/08-revert/)                         | -               | Safely undo commits               |
| [09-bisect](examples/09-bisect/)                         | -               | Find bugs with binary search      |
| [10-log](examples/10-log/)                               | -               | Search and filter Git history     |
| [11-diff](examples/11-diff/)                             | -               | View and filter changes           |
| [12-worktree](examples/12-worktree/)                     | API Docs        | Multiple branches simultaneously  |
| [13-cherry-pick](examples/13-cherry-pick/)               | -               | Select specific commits           |
| [14-submodules](examples/14-submodules/)                 | Plugin System   | Version-pinned dependencies       |
| [15-subtree](examples/15-subtree/)                       | Main App        | Simpler alternative to submodules |
| [16-filter-branch](examples/16-filter-branch/)           | -               | History rewriting                 |
| [17-rerere](examples/17-rerere/)                         | -               | Reuse conflict resolutions        |
| [18-checkout](examples/18-checkout/)                     | -               | File-level checkout operations    |
| [19-sparse-checkout](examples/19-sparse-checkout/)       | -               | Partial repository checkout       |
| [20-patch](examples/20-patch/)                           | -               | Create and apply patches          |
| [21-blame](examples/21-blame/)                           | Calculator      | Track line-by-line history        |
| [22-grep](examples/22-grep/)                             | -               | Search code in repository         |
| [23-range-diff](examples/23-range-diff/)                 | -               | Compare commit ranges             |
| [24-bundle](examples/24-bundle/)                         | -               | Offline repository transfer       |

Each example includes:

- ✅ Complete setup/demo/reset scripts
- ✅ Interactive typewriter-effect demonstrations
- ✅ Comprehensive README with manual exploration guide
- ✅ 3-5 minute presentation time

[📖 View All Examples →](examples/README.md)

## Quick Start

### Prerequisites

- **Node.js:** 18.0.0 or higher
- **Git:** 2.30 or higher
- **Terminal:** bash-compatible shell

### Try an Example

```bash
# Navigate to an example
cd examples/01-stash

# Run the setup (creates git scenario)
./setup.sh

# Run the interactive demo
./demo.sh

# Reset for a fresh start
./reset.sh
```

### Run All Examples

```bash
cd examples

# Setup all examples
for dir in */; do
  cd "$dir"
  ./setup.sh
  cd ..
done

# Run demos in sequence
for dir in */; do
  cd "$dir"
  ./demo.sh --no-pause  # Skip pauses for quick run
  cd ..
done
```

## Features

### Interactive Demonstrations

- **Typewriter Effect:** Commands appear character-by-character like a live presentation
- **Pausable:** Press Enter to advance, or type commands to explore
- **Ad-hoc Exploration:** During pauses, enter your own commands
- **Quick Mode:** Use `--no-pause` flag for faster testing

### Shared Utilities

All demos use common utilities from `shared/demo-utils.sh`:

- Color-coded output (success, info, warning, error)
- Git helper functions (pretty logs, status, diffs)
- Consistent demo flow (start, announce, end)

[📖 View Utilities Documentation →](shared/README.md)

## Presentation Tracks

### Beginner Track

Essential Git skills for daily development:

1. **Stash** (01) - Save work temporarily
2. **Merge** (02) - Resolve conflicts
3. **Restore** (03) - Discard unwanted changes
4. **Reflog** (04) - Git's safety net
5. **Reset** (07) - Understand reset modes
6. **Revert** (08) - Safely undo commits
7. **Bisect** (09) - Find bugs fast

### Advanced Track

Professional Git workflows:

1. **Rebase Interactive** (05) - Clean history
2. **Fixup** (06) - Smart workflow
3. **Log** (10) - Search history effectively
4. **Diff** (11) - Master change inspection
5. **Worktree** (12) - Parallel development
6. **Cherry-pick** (13) - Selective commits
7. **Rerere** (17) - Auto-resolve conflicts

### Expert Track

Advanced repository management:

1. **Submodules** (14) - Version-pinned dependencies
2. **Subtree** (15) - Embedded repositories
3. **Filter-branch** (16) - History rewriting
4. **Checkout** (18) - File-level operations
5. **Sparse-checkout** (19) - Partial repository checkout
6. **Patch** (20) - Create and apply patches
7. **Bundle** (24) - Offline repository transfer

### Power User Track

Code investigation and review:

1. **Blame** (21) - Track who changed what
2. **Grep** (22) - Search code efficiently
3. **Range-diff** (23) - Review rebased branches

### Complete Tour

All 24 examples in numerical order.

## For Presenters

### Tips

1. **Practice first** - Run each demo 2-3 times
2. **Explain the "why"** - Context makes commands memorable
3. **Use pauses** - Allow time for questions
4. **Show mistakes** - Demonstrate recovery techniques
5. **Adjust speed** - Edit `DELAY_BETWEEN_CHARS` in shared/demo-utils.sh

### Customization

```bash
# Faster typewriter effect
# Edit shared/demo-utils.sh
DELAY_BETWEEN_CHARS=0.05  # Default is 0.09

# Skip all pauses
./demo.sh --no-pause
```

## Project Structure

```
git-hero/
├── examples/              # 24 simple, focused demonstrations
│   ├── 01-stash/
│   ├── 02-merge/
│   ├── ...
│   ├── 24-bundle/
│   └── README.md         # Master index
├── shared/               # Common utilities
│   ├── demo-utils.sh    # Shared functions
│   └── README.md        # Utilities documentation
├── git-conf/            # Complex Angular demo (preserved)
│   ├── demo.sh
│   └── ...
└── README.md            # This file
```

## License

MIT

---

**Happy Git Learning! 🚀**

_Making advanced Git features accessible through simple examples_
