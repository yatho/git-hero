# Git Checkout - File-Level Operations

Unlike `git switch` which only changes branches, `git checkout` can operate on individual files.

## Key Demonstrations

1. **Checkout files from other branches** - Get specific files without switching branches
2. **Restore files to previous versions** - Checkout files from specific commits
3. **Discard working changes** - Restore files to HEAD state

## Usage

```bash
./setup.sh   # Create scenario with multiple branches
./demo.sh    # Interactive demonstration
./reset.sh   # Clean up
```

## What You'll Learn

- `git checkout branch -- file`: Get a file from another branch
- `git checkout commit -- file`: Restore file to specific version
- `git checkout HEAD -- file`: Discard uncommitted changes
- Difference between `git switch` (branch-level) and `git checkout` (file-level)