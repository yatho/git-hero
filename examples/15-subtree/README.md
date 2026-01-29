# 12 - Git Subtree
> Simpler alternative to submodules
**Time:** 4-5 minutes

## Quick Start
```bash
./setup.sh && ./demo.sh
```

## Key Commands
```bash
git subtree add --prefix=<path> <remote> <branch> --squash
git subtree pull --prefix=<path> <remote> <branch> --squash
git subtree push --prefix=<path> <remote> <branch>
```

## Comparison with Submodules
- **Easier**: No --recursive, no init, clone just works
- **Tradeoff**: Larger repo, mixed history
