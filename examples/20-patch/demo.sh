#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

cd "$SCRIPT_DIR"

# ===============================
# Git Patch Demo
# ===============================

start_demo "Git Patch" "Create and apply patches for sharing changes"

# -------------------------
announce "1. Current Repository State"

info "Let's see our commit history:"
run "git log --oneline"
pause

run "cat utils.js"
pause

# -------------------------
announce "2. Create a Single Patch"

info "Create a patch from the last commit:"
run "git format-patch -1"
pause

info "This creates a .patch file:"
run "ls -la *.patch"
pause

info "Let's examine the patch content:"
run "cat 0001-feat-add-truncate-utility-function.patch"
pause

info "Notice it includes:"
echo "  - From: author and email"
echo "  - Date: commit date"
echo "  - Subject: commit message"
echo "  - Full diff"
pause

# -------------------------
announce "3. Create Multiple Patches"

info "Create patches for the last 3 commits:"
run "git format-patch -3"
pause

run "ls -la *.patch"
pause

# -------------------------
announce "4. Output to Directory"

info "Create patches in a specific directory:"
run "git format-patch -3 -o patches/"
pause

run "ls -la patches/"
pause

# -------------------------
announce "5. Apply Patches to Another Branch"

info "Let's create a new branch from an earlier state:"
run "git switch -C patch-test HEAD~3"
pause

run "git log --oneline"
pause

run "cat utils.js"
echo
info "This version doesn't have the null checks or truncate"
pause

# -------------------------
announce "6. Patch Statistics"

info "Check what a patch does without applying:"
run "git apply --stat patches/0001-chore-bump-version-and-add-author.patch"
pause

info "Check if patch applies cleanly:"
run "git apply --check patches/0001-chore-bump-version-and-add-author.patch"
echo
success "No output means it would apply cleanly!"
pause

# -------------------------
announce "7. Apply Patch with git am"

info "Apply a patch preserving commit info:"
run "git am patches/0001-chore-bump-version-and-add-author.patch"
pause

run "git log --oneline"
pause

info "The commit was applied with original message and author!"
run "git log -1"
pause

# -------------------------
announce "8. Apply Multiple Patches"

info "Apply remaining patches:"
run "git am patches/0002-fix-handle-null-undefined-input-in-utils.patch"
pause

run "git log --oneline"
pause

# -------------------------
announce "9. Simple Diff Patch"

info "For uncommitted changes, use git diff:"
run "git switch main"
pause

info "Make some changes:"
cat >> utils.js << 'EOF'

function padStart(str, length, char = ' ') {
  while (str.length < length) {
    str = char + str;
  }
  return str;
}

module.exports.padStart = padStart;
EOF

run "git diff"
pause

info "Save as a simple patch:"
run "git diff > uncommitted.patch"
pause

run "cat uncommitted.patch"
pause

info "Restore the file and apply the patch:"
run "git restore utils.js"
run "git apply uncommitted.patch"
pause

run "git diff"
pause

# Reset
git restore utils.js

# -------------------------
announce "10. Email Workflow"

info "Traditional open source workflow:"
echo
echo "# Contributor creates patch"
echo "$ git format-patch -1 --stdout > my-fix.patch"
echo
echo "# Or send directly via email"
echo "$ git send-email --to=maintainer@project.org 0001-*.patch"
echo
echo "# Maintainer applies from email/file"
echo "$ git am < my-fix.patch"
pause

# -------------------------
announce "11. Signed-off-by"

info "For official contributions, add sign-off:"
run "git format-patch -1 --signoff --stdout | head -20"
pause

# -------------------------
announce "12. Cover Letter"

info "For patch series, create a cover letter:"
run "git format-patch -3 --cover-letter -o patches/with-cover/"
pause

run "ls patches/with-cover/"
pause

run "cat patches/with-cover/0000-cover-letter.patch"
echo
info "Edit this to explain your patch series!"
pause

# -------------------------
announce "13. Versioned Patches"

info "When resubmitting after review feedback:"
echo
echo "# First submission"
echo "$ git format-patch -1"
echo
echo "# After feedback, version 2"
echo "$ git format-patch -1 -v2"
echo "# Creates: v2-0001-commit-message.patch"
echo
echo "# Version 3, etc."
echo "$ git format-patch -1 -v3"
pause

# -------------------------
announce "14. Handling Conflicts"

info "When a patch doesn't apply cleanly:"
echo
echo "$ git am some-patch.patch"
echo "# CONFLICT!"
echo
echo "# Option 1: Abort"
echo "$ git am --abort"
echo
echo "# Option 2: Fix manually"
echo "$ # edit conflicting files"
echo "$ git add resolved-file.js"
echo "$ git am --continue"
echo
echo "# Option 3: Skip this patch"
echo "$ git am --skip"
pause

# -------------------------
announce "15. Key Commands Summary"

echo "# Create patches"
echo "$ git format-patch -1              # Last commit"
echo "$ git format-patch -3 -o patches/  # Last 3 to directory"
echo "$ git format-patch main..HEAD      # Since main"
echo
echo "# Inspect patches"
echo "$ git apply --stat file.patch      # Statistics"
echo "$ git apply --check file.patch     # Test apply"
echo
echo "# Apply patches"
echo "$ git am file.patch                # With commit info"
echo "$ git apply file.patch             # Just the diff"
echo
echo "# Simple diff patches"
echo "$ git diff > changes.patch         # Create"
echo "$ git apply changes.patch          # Apply"
pause

# Cleanup
git switch main 2>/dev/null || true
git branch -D patch-test 2>/dev/null || true
rm -f *.patch uncommitted.patch
rm -rf patches/with-cover

# End demo
end_demo \
  "format-patch creates patches with full commit metadata" \
  "git am applies patches preserving author and message" \
  "Patches are text files - easy to share via email" \
  "Use --signoff for open source contributions" \
  "Great for code review and offline collaboration"
