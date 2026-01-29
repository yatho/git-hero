# 07 - Git Reflog

> Recover "lost" commits with Git's safety net

**Time:** 3-4 minutes

## What You'll Learn
- Reflog tracks all ref changes
- Recover deleted branches
- Git's 90-day safety net

## The App
Simple note-taking app demonstrating commit recovery.

## Quick Start
```bash
./setup.sh  # Create repo with experimental branch
./demo.sh   # Delete branch, then recover it
./reset.sh  # Clean up
```

## Key Commands
```bash
git reflog              # Show all ref changes
git reflog show HEAD    # HEAD's history
git checkout -b <branch> <hash>  # Recover from reflog
```

## Learn More
- [Git Reflog Docs](https://git-scm.com/docs/git-reflog)
