# Git Sparse-Checkout - Partial Repository Checkout

This demo showcases `git sparse-checkout`, which allows you to check out only specific directories or files from a repository. Essential for working with monorepos or large repositories.

## What You'll Learn

1. **Enable Sparse-Checkout** - Initialize sparse checkout mode
2. **Select Directories** - Choose what to check out
3. **Cone Mode** - Modern, faster pattern matching
4. **Add/Remove Paths** - Dynamically change what's checked out
5. **Monorepo Workflows** - Practical use cases

## Key Commands Demonstrated

```bash
# Enable sparse-checkout
git sparse-checkout init --cone

# Set directories to checkout
git sparse-checkout set dir1 dir2

# Add more directories
git sparse-checkout add dir3

# List current patterns
git sparse-checkout list

# Disable sparse-checkout
git sparse-checkout disable
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

### Working with Monorepos
```bash
# Clone without checking out files
git clone --no-checkout https://github.com/large/monorepo.git
cd monorepo

# Enable sparse-checkout
git sparse-checkout init --cone

# Only checkout the frontend app
git sparse-checkout set apps/frontend shared/utils

# Checkout files
git checkout main
```

### Reducing Clone Size
```bash
# Combine with partial clone for large repos
git clone --filter=blob:none --sparse https://github.com/large/repo.git
cd repo
git sparse-checkout set needed/directory
```

### Switching Between Projects
```bash
# Start with project A
git sparse-checkout set projects/project-a

# Later, switch to project B
git sparse-checkout set projects/project-b

# Or work on both
git sparse-checkout set projects/project-a projects/project-b
```

## Sparse-Checkout Modes

### Cone Mode (Recommended)
```bash
git sparse-checkout init --cone
git sparse-checkout set dir1 dir2
```
- Faster pattern matching
- Simpler mental model (directories only)
- Better performance on large repos

### Non-Cone Mode (Legacy)
```bash
git sparse-checkout init
git sparse-checkout set '*.md' 'src/**/*.js'
```
- Supports gitignore-style patterns
- More flexible but slower
- Use only when needed

## Practical Scenarios

### Scenario 1: Frontend Developer in Monorepo
```bash
git sparse-checkout set \
  apps/frontend \
  packages/ui-components \
  packages/shared-utils
```

### Scenario 2: Documentation Contributor
```bash
git sparse-checkout set docs
```

### Scenario 3: DevOps Focus
```bash
git sparse-checkout set \
  infrastructure \
  .github \
  scripts
```

## Important Notes

- Sparse-checkout only affects the working tree, not the repository
- Git still tracks all files (for commits, diffs, etc.)
- Use `--cone` mode for best performance
- Combine with `--filter=blob:none` for truly partial clones
- Changes to excluded files won't appear in `git status`
