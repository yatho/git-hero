# 01 - Git Bisect

> Find the commit that introduced a bug using binary search

**Presentation Time:** 3-4 minutes

## What You'll Learn

- How to use `git bisect` to automatically find buggy commits
- The power of binary search (finding bugs in log2(n) steps)
- Automating bisect with `git bisect run` and tests
- Best practices: tagging known-good versions

## The Application

A simple number guessing game where the computer tries to guess your number using binary search.

**The Bug:** In commit 5 of 8, the binary search midpoint calculation was accidentally changed from `(low + high) / 2` to `(low + high) / 2 + 5`, breaking the algorithm. The game starts guessing wildly instead of narrowing down efficiently.

**Purpose:** Demonstrates how `git bisect` can quickly find the exact commit that introduced a regression, even in a history with many commits.

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
- 8 commits showing feature evolution
- Tag `v1.0.0` at commit 4 (last known good version)
- Tag `v2.0.0` at commit 8 (current broken version)
- Bug introduced in commit 5

### 2. Run Demo

```bash
./demo.sh
```

Interactive demonstration with typewriter effect. Press Enter to advance through each step.

### 3. Reset

```bash
./reset.sh
```

Cleans up the repository for a fresh run.

## Demo Flow

1. **Show the bug** - Run the app and see binary search is broken
2. **Start bisect** - `git bisect start`
3. **Mark current as bad** - `git bisect bad`
4. **Mark known good version** - `git bisect good v1.0.0`
5. **Test manually** - Git checks out middle commit, run app to test
6. **Or automate** - `git bisect run npm test` to find bug automatically
7. **Find the culprit** - Git identifies the exact commit
8. **View the bug** - `git show` to see the problematic change
9. **Reset** - `git bisect reset` to return to normal
10. **Fix it** - Could use `git revert` or create a fix

## Key Commands

```bash
git bisect start                  # Begin bisect session
git bisect bad                    # Mark current commit as bad
git bisect good <commit>          # Mark a commit as good
git bisect run <command>          # Automate testing with a command
git bisect reset                  # End bisect and return to original HEAD
git show <commit>                 # View changes in the buggy commit
```

## Manual Exploration

After running setup, try exploring on your own:

```bash
# See the commit history
git log --oneline --all

# Try the app in different versions
git checkout v1.0.0
node number-guesser.js  # Works correctly

git checkout v2.0.0
node number-guesser.js  # Broken!

# Start bisect manually
git bisect start
git bisect bad
git bisect good v1.0.0

# Test each commit manually
node number-guesser.js
# Based on test, mark as good or bad
git bisect good   # or git bisect bad

# Keep testing until git finds the culprit

# Or automate it!
git bisect reset
git bisect start
git bisect bad
git bisect good v1.0.0
git bisect run npm test  # Runs tests automatically!

# View the bug
git show HEAD

# Clean up
git bisect reset
```

## Understanding Binary Search

With 8 commits, bisect finds the bug in just 3 steps (log2(8) = 3):

1. **Test commit 4** (middle of 1-8) → good
2. **Test commit 6** (middle of 5-8) → bad
3. **Test commit 5** (middle of 5-6) → bad ← **FOUND IT!**

Compare to linear search: could take up to 8 tests!

For 100 commits: bisect needs ~7 tests vs up to 100 linear tests.
For 1000 commits: bisect needs ~10 tests vs up to 1000 linear tests.

## The Bug Explained

**Working code (commits 1-4):**
```javascript
function binarySearch(low, high) {
  return Math.floor((low + high) / 2);
}
```

**Broken code (commits 5-8):**
```javascript
function binarySearch(low, high) {
  return Math.floor((low + high) / 2) + 5;  // ← Added +5 by mistake!
}
```

This causes the midpoint to be offset by 5, breaking the binary search algorithm.

## Automated Testing with Bisect Run

The `number-guesser.test.js` file contains automated tests:
- Tests the binarySearch function with known inputs
- Exits with code 0 (success) if tests pass → git marks commit as "good"
- Exits with code 1 (failure) if tests fail → git marks commit as "bad"

This allows `git bisect run npm test` to automatically find the bad commit!

## Real-World Applications

**When to use git bisect:**
- A test that used to pass now fails
- A feature that worked before is now broken
- Performance degraded but you're not sure when
- You have many commits and don't know which introduced the bug

**Best practices:**
- Maintain a test suite for automated bisecting
- Tag known-good releases (makes bisect easier)
- Keep commits focused (easier to identify bug source)
- Write good commit messages (helps understand what changed)

## Troubleshooting

**Problem:** Setup fails
**Solution:** Make sure you're in the `01-bisect` directory

**Problem:** Demo shows command not found
**Solution:** Run `chmod +x *.sh` to make scripts executable

**Problem:** Bisect session already in progress
**Solution:** Run `git bisect reset` to clear it

**Problem:** Tests don't run
**Solution:** Make sure Node.js 18+ is installed: `node --version`

## Learn More

- [Git Bisect Documentation](https://git-scm.com/docs/git-bisect)
- [Pro Git Book - Debugging with Git](https://git-scm.com/book/en/v2/Git-Tools-Debugging-with-Git)
- [Git Bisect Run Examples](https://git-scm.com/docs/git-bisect#_bisect_run)

## Part of Git Hero

This example is part of the [Git Hero](../README.md) demonstration series for NG Baguette Conf 2026.

**Other Examples:**
- [02 - Merge](../02-merge/) - Resolve merge conflicts
- [03 - Rerere](../03-rerere/) - Reuse conflict resolutions
- [04 - Rebase Interactive](../04-rebase-interactive/) - Clean commit history
- [All Examples](../README.md#quick-navigation)

---

**Git Hero** - Simple Git demonstrations for NG Baguette Conf 2026
