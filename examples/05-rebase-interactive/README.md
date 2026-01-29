# 04 - Interactive Rebase
> Clean up commit history before merging
**Time:** 4-5 minutes

## Quick Start
```bash
./setup.sh && ./demo.sh
```

## Key Commands
```bash
git rebase -i HEAD~N      # Rebase last N commits
git rebase -i --autosquash  # Auto-apply fixup commits
```

## Actions
- **pick**: keep commit
- **squash**: merge with previous, keep both messages
- **fixup**: merge with previous, discard this message
- **reword**: change commit message
- **drop**: remove commit
