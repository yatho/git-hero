# Git Diff - Master the Art of Viewing Changes

This demo showcases the powerful features of `git diff` for inspecting changes in your repository.

## What You'll Learn

1. **Basic Diff** - Understanding what changed
2. **Diff Statistics** - Quick overview with `--stat`
3. **Excluding Files** - Filter out noise like `package-lock.json`
4. **Whitespace Handling** - Show or ignore whitespace differences
5. **Word Diff** - Granular, word-by-word change view
6. **Staged vs Unstaged** - Understanding the three states
7. **Diff Between Commits** - Compare any two points in history
8. **Custom Formats** - Compact, name-only, and more
9. **Practical Aliases** - Boost your productivity
10. **Advanced Filters** - Using `.gitattributes` for smarter diffs

## Key Commands Demonstrated

```bash
# Exclude files from diff
git diff -- . ':(exclude)package-lock.json'
git diff -- ':!*.lock'

# Whitespace handling
git diff --ignore-all-space
git diff --ws-error-highlight=all

# Word-level changes
git diff --color-words
git diff --word-diff

# Different views
git diff --stat
git diff --name-status
git diff --compact-summary

# Staged vs unstaged
git diff              # Working dir vs staging
git diff --staged     # Staging vs HEAD
git diff HEAD         # Working dir vs HEAD
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

## What Makes This Demo Special

- Shows how to filter out noise files (lock files, build artifacts)
- Demonstrates whitespace diff options for post-formatting reviews
- Teaches the difference between working directory, staging area, and commits
- Provides practical aliases you can use immediately
- Interactive and educational format