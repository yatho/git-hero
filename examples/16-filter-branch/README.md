# 10 - Git Filter-Branch
> Rewrite history to remove files
**Time:** 4-5 minutes

## Quick Start
```bash
./setup.sh && ./demo.sh
```

## Key Commands
```bash
git filter-branch --index-filter 'git rm --cached --ignore-unmatch <file>' HEAD
git filter-repo --path <file> --invert-paths  # Modern alternative
```

## ⚠️ Warning
This rewrites history! Only use on unshared branches or coordinate with team.
