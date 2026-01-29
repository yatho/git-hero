# 02 - Git Merge

> Understand and resolve merge conflicts effectively

**Presentation Time:** 3-4 minutes

## What You'll Learn

- How merge conflicts occur when the same code is modified in different branches
- Understanding diff3 conflict markers (HEAD, common ancestor, incoming)
- Manual conflict resolution strategies
- Testing after merging

## The Application

A shopping cart CLI that calculates purchase totals.

**The Conflict:** Two features both modify the `calculateTotal()` function:
- `feature/tax-calculation` - Adds 20% VAT to purchases
- `feature/discount-system` - Adds discount code support

When both are merged into main, Git cannot automatically combine them.

## Prerequisites

- Node.js 18+
- Git 2.30+
- Bash-compatible terminal

## Quick Start

### 1. Setup
```bash
./setup.sh
```

Creates git repository with:
- `main` - Basic cart with simple total
- `feature/tax-calculation` - Adds 20% tax
- `feature/discount-system` - Adds 10% discount codes
- Both features modify the same function

### 2. Run Demo
```bash
./demo.sh
```

### 3. Reset
```bash
./reset.sh
```

## Demo Flow

1. **View branches** - See the parallel development
2. **Test features independently** - Both work on their own branches
3. **Merge tax feature** - First merge succeeds (no conflict)
4. **Merge discount feature** - CONFLICT! Same function modified
5. **Examine conflict markers** - Understand the diff3 style
6. **Manual resolution** - Integrate both features
7. **Complete merge** - Commit the resolution
8. **Test result** - Verify both features work together

## Key Commands

```bash
git merge <branch>                    # Merge branch into current branch
git status                           # See which files have conflicts
git diff                             # View the conflict details
git add <file>                       # Mark conflict as resolved
git commit                           # Complete the merge
git merge --abort                    # Abandon merge and start over
git config merge.conflictstyle diff3 # Use 3-way conflict markers
```

## Understanding Conflict Markers

With `merge.conflictstyle diff3` enabled, conflicts show three versions:

```javascript
<<<<<<< HEAD
// YOUR changes (current branch)
let total = subtotal + tax;
||||||| merged common ancestors
// ORIGINAL version (before either change)
let total = subtotal;
=======
// THEIR changes (incoming branch)
let total = subtotal - discount;
>>>>>>> feature/discount-system
```

This helps you understand:
- What YOU changed (HEAD)
- What it was ORIGINALLY (ancestor)
- What THEY changed (incoming)

## Resolution Strategy

For this conflict, the resolution integrates both features:

```javascript
function calculateTotal(cart, discountCode = null) {
  let subtotal = cart.reduce((sum, item) => sum + item.price, 0);

  // Apply discount FIRST (from discount feature)
  let discount = 0;
  if (discountCode === 'SAVE10') {
    discount = subtotal * 0.10;
  }

  // Then apply tax (from tax feature)
  let afterDiscount = subtotal - discount;
  let tax = afterDiscount * 0.20;

  let total = afterDiscount + tax;

  return { subtotal, discount, tax, total };
}
```

## Manual Exploration

```bash
# View the branch structure
git log --oneline --all --graph

# Test tax feature
git checkout feature/tax-calculation
node cart.js

# Test discount feature
git checkout feature/discount-system
node cart.js

# Start merging
git checkout main
git merge feature/tax-calculation  # Success!
git merge feature/discount-system  # Conflict!

# View the conflict
git status
cat cart.js  # See conflict markers

# After manually resolving in your editor
git add cart.js
git commit -m "Merge discount system with tax calculation"

# Test the result
node cart.js
```

## Common Merge Scenarios

**Fast-forward merge:** When target branch hasn't diverged, Git just moves the pointer forward (no merge commit needed).

**Three-way merge:** When both branches have new commits, Git creates a merge commit combining both histories.

**Merge conflict:** When the same lines are modified in both branches, manual resolution is required.

## Tips for Avoiding/Resolving Conflicts

1. **Pull frequently** - Keep your branch up to date with main
2. **Small commits** - Easier to identify and resolve conflicts
3. **Communicate** - Let team know if you're modifying shared code
4. **Use diff3** - Shows common ancestor for better context
5. **Test after resolving** - Always verify the merge works correctly
6. **Use tools** - Many editors have merge conflict resolution UI

## Troubleshooting

**Problem:** Conflict markers still in file after commit
**Solution:** Search for `<<<<<<<` in all files before committing

**Problem:** Want to start over
**Solution:** `git merge --abort` cancels the merge

**Problem:** Accidentally committed conflict markers
**Solution:** `git reset HEAD~1`, fix conflicts, commit again

## Learn More

- [Git Merge Documentation](https://git-scm.com/docs/git-merge)
- [Pro Git Book - Basic Merging](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging)
- [About Merge Conflicts](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts)

## Part of Git Hero

This example is part of the [Git Hero](../README.md) demonstration series for NG Baguette Conf 2026.

**Other Examples:**
- [01 - Bisect](../01-bisect/) - Find bugs with binary search
- [03 - Rerere](../03-rerere/) - Reuse conflict resolutions
- [04 - Rebase Interactive](../04-rebase-interactive/) - Clean commit history
- [All Examples](../README.md#quick-navigation)
