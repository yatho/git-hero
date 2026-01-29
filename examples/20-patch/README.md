# Git Patch - Create and Apply Patches

This demo showcases Git's patch functionality using `git format-patch` and `git am`. Patches are a powerful way to share changes via email, review commits offline, or contribute to projects without direct push access.

## What You'll Learn

1. **Create Patches** - Export commits as patch files
2. **Apply Patches** - Import patches with full commit info
3. **Email Workflow** - Traditional open source contribution method
4. **Patch Review** - Inspect changes before applying
5. **Conflict Resolution** - Handle patch conflicts

## Key Commands Demonstrated

```bash
# Create patches from commits
git format-patch -1           # Last commit
git format-patch -3           # Last 3 commits
git format-patch main..HEAD   # All commits since main
git format-patch -o patches/  # Output to directory

# Apply patches
git am patch-file.patch       # Apply with commit info
git apply patch-file.patch    # Apply without commit

# Handle conflicts
git am --abort                # Abort failed apply
git am --skip                 # Skip current patch
git am --continue             # Continue after fixing

# Create diff patches (simpler)
git diff > changes.patch
git apply changes.patch
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

### Contributing to Open Source
```bash
# Make your changes and commit
git commit -m "Fix: resolve null pointer issue"

# Create patch for maintainer
git format-patch -1 --stdout > fix-null-pointer.patch

# Email the patch or attach to issue
```

### Code Review Offline
```bash
# Export colleague's work as patches
git format-patch origin/main..feature-branch -o review/

# Read and review each patch file
# Apply if approved
git am review/*.patch
```

### Backup Uncommitted Changes
```bash
# Save work-in-progress as patch
git diff > wip.patch

# Later, restore
git apply wip.patch
```

### Cherry-pick Without Merge
```bash
# Create patch from specific commit
git format-patch -1 abc123

# Apply to another branch
git checkout target-branch
git am 0001-commit-message.patch
```

## Format-Patch Options

| Option | Description |
|--------|-------------|
| `-n` | Create patches for last n commits |
| `-o <dir>` | Output patches to directory |
| `--stdout` | Output to stdout (for piping) |
| `-s` | Add Signed-off-by line |
| `--cover-letter` | Generate cover letter template |
| `-v2` | Mark as version 2 of patch series |

## Apply Options

| Command | Description |
|---------|-------------|
| `git am` | Apply with full commit metadata |
| `git apply` | Apply diff only, no commit |
| `git apply --check` | Test if patch applies cleanly |
| `git apply --stat` | Show patch statistics |

## Important Notes

- `format-patch` preserves commit message, author, and date
- `am` (apply mailbox) is designed for email workflows
- Patches are portable text files, easy to share
- Use `--signoff` for Signed-off-by in open source projects
- Patches can be edited before applying
