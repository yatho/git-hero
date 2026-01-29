# Git Bundle - Offline Repository Transfer

This demo showcases `git bundle`, which packages Git objects and references into a single file for offline transfer. Perfect for air-gapped systems, sneakernet workflows, or backing up repositories.

## What You'll Learn

1. **Create Bundles** - Package repository content
2. **Full vs Incremental** - Different bundle types
3. **Verify Bundles** - Check bundle integrity
4. **Clone from Bundle** - Create repo from bundle
5. **Update with Bundles** - Incremental updates

## Key Commands Demonstrated

```bash
# Create a full bundle
git bundle create repo.bundle --all

# Create bundle of specific branch
git bundle create feature.bundle main

# Incremental bundle (only new commits)
git bundle create update.bundle main ^origin/main

# Verify bundle
git bundle verify repo.bundle

# List references in bundle
git bundle list-heads repo.bundle

# Clone from bundle
git clone repo.bundle my-repo

# Fetch from bundle
git fetch repo.bundle main:refs/remotes/origin/main
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

### Air-Gapped Systems
```bash
# On connected machine
git bundle create transfer.bundle --all

# Copy transfer.bundle to air-gapped system (USB, etc.)

# On air-gapped system
git clone transfer.bundle project
```

### Offline Code Review
```bash
# Developer creates bundle of feature branch
git bundle create feature-review.bundle main..feature

# Reviewer (offline) fetches the bundle
git fetch feature-review.bundle feature:review/feature
git diff main...review/feature
```

### Backup Repository
```bash
# Full backup
git bundle create backup-$(date +%Y%m%d).bundle --all

# Incremental backup
git bundle create incremental.bundle --all ^backup-tag
git tag backup-tag
```

### Share Without Server
```bash
# No GitHub? No problem!
git bundle create my-project.bundle --all

# Email the bundle or share via USB
# Recipient clones it
git clone my-project.bundle
```

## Bundle Types

### Full Bundle
```bash
git bundle create full.bundle --all
```
Contains entire repository history and all branches.

### Branch Bundle
```bash
git bundle create branch.bundle main feature
```
Contains only specified branches.

### Incremental Bundle
```bash
git bundle create incremental.bundle main ^v1.0
```
Contains only commits since v1.0 tag.

## Bundle Commands

| Command | Description |
|---------|-------------|
| `create` | Create a new bundle file |
| `verify` | Check if bundle is valid |
| `list-heads` | List references in bundle |
| `unbundle` | Low-level extraction |

## Important Notes

- Bundles are portable binary files
- They contain Git objects and references
- Can be used as a remote (`git remote add bundle /path/to/file.bundle`)
- Incremental bundles require the base commits to exist
- Great for bandwidth-limited or offline scenarios
- Bundles are NOT encrypted - don't bundle sensitive repos without encryption
