#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

cd "$SCRIPT_DIR"

# ===============================
# Git Bundle Demo
# ===============================

start_demo "Git Bundle" "Package repositories for offline transfer"

# -------------------------
announce "1. The Source Repository"

info "We have a repository we want to share offline:"
cd source-repo

run "git log --oneline --all --graph"
pause

run "git branch -a"
pause

run "ls -la"
pause

cd ..

# -------------------------
announce "2. Create a Full Bundle"

info "Bundle the entire repository (all branches, all history):"
cd source-repo
run "git bundle create ../bundles/full-repo.bundle --all"
cd ..
pause

info "Check the bundle file:"
run "ls -lh bundles/full-repo.bundle"
pause

# -------------------------
announce "3. Verify the Bundle"

info "Verify bundle integrity before transfer:"
run "git bundle verify bundles/full-repo.bundle"
pause

success "Bundle is valid and complete!"
pause

# -------------------------
announce "4. List Bundle Contents"

info "See what's inside the bundle:"
run "git bundle list-heads bundles/full-repo.bundle"
pause

info "The bundle contains main, feature-login, and tags"
pause

# -------------------------
announce "5. Clone from Bundle"

info "Clone the repository from the bundle:"
run "git clone bundles/full-repo.bundle received-repo"
pause

info "Check the cloned repository:"
cd received-repo
run "git log --oneline --all --graph"
pause

run "git branch -a"
pause

run "ls -la"
pause

success "Complete repository restored from bundle!"
cd ..
pause

# -------------------------
announce "6. Bundle Specific Branches"

info "Bundle only the main branch:"
cd source-repo
run "git bundle create ../bundles/main-only.bundle main"
cd ..
pause

run "git bundle list-heads bundles/main-only.bundle"
pause

info "Compare sizes:"
run "ls -lh bundles/"
pause

# -------------------------
announce "7. Incremental Bundles"

info "For updates, bundle only new commits since v1.0:"
cd source-repo
run "git log --oneline v1.0..main"
pause

info "Create incremental bundle:"
run "git bundle create ../bundles/update-since-v1.bundle main ^v1.0"
cd ..
pause

info "Much smaller than full bundle:"
run "ls -lh bundles/"
pause

# -------------------------
announce "8. Verify Incremental Bundle"

info "Incremental bundles need the base commits:"
run "git bundle verify bundles/update-since-v1.bundle"
echo
info "It requires commits from v1.0 to exist"
pause

# -------------------------
announce "9. Fetch from Bundle"

info "Update existing repo from incremental bundle:"
cd received-repo

info "First, let's reset to v1.0 to simulate needing updates:"
run "git reset --hard v1.0"
run "git log --oneline"
pause

info "Fetch updates from bundle:"
run "git fetch ../bundles/update-since-v1.bundle main:refs/remotes/bundle/main"
pause

run "git log --oneline --all"
pause

info "Merge the updates:"
run "git merge bundle/main"
run "git log --oneline"
pause

success "Repository updated from incremental bundle!"
cd ..
pause

# -------------------------
announce "10. Use Bundle as Remote"

info "You can add a bundle as a remote:"
cd received-repo
echo "$ git remote add backup ../bundles/full-repo.bundle"
echo "$ git fetch backup"
echo
info "(This allows pulling updates from bundle files)"
cd ..
pause

# -------------------------
announce "11. Air-Gapped Workflow"

echo "Typical air-gapped system workflow:"
echo
echo "CONNECTED MACHINE:"
echo "  \$ git bundle create transfer.bundle --all"
echo "  # Copy to USB drive"
echo
echo "AIR-GAPPED MACHINE:"
echo "  # First time: clone from bundle"
echo "  \$ git clone transfer.bundle project"
echo
echo "  # Updates: fetch from new bundles"
echo "  \$ git fetch ../transfer-update.bundle main:main"
pause

# -------------------------
announce "12. Backup Strategy"

echo "Using bundles for backups:"
echo
echo "# Full backup"
echo "\$ git bundle create backup-full-\$(date +%Y%m%d).bundle --all"
echo
echo "# Tag the backed-up state"
echo "\$ git tag backup-\$(date +%Y%m%d)"
echo
echo "# Later, incremental backup"
echo "\$ git bundle create backup-inc-\$(date +%Y%m%d).bundle \\"
echo "    --all ^backup-20240101"
pause

# -------------------------
announce "13. Bundle vs Archive"

echo "git bundle vs git archive:"
echo
echo "git bundle:"
echo "  ✅ Contains full Git history"
echo "  ✅ Preserves branches and tags"
echo "  ✅ Can be cloned/fetched from"
echo "  ✅ Supports incremental updates"
echo
echo "git archive:"
echo "  ✅ Just the files (no .git)"
echo "  ✅ Smaller for distribution"
echo "  ✅ Good for releases/snapshots"
echo "  ❌ No history, can't clone"
pause

# -------------------------
announce "14. Security Note"

echo "Important security considerations:"
echo
warning "  ⚠️  Bundles are NOT encrypted!"
echo
echo "  For sensitive repositories:"
echo "  1. Encrypt the bundle file before transfer"
echo "     \$ gpg -c repo.bundle"
echo
echo "  2. Or use encrypted USB/transfer medium"
echo
echo "  3. Delete bundles after successful transfer"
pause

# -------------------------
announce "15. Key Commands Summary"

echo "# Create bundles"
echo "\$ git bundle create full.bundle --all        # Everything"
echo "\$ git bundle create branch.bundle main      # Specific branch"
echo "\$ git bundle create inc.bundle main ^v1.0   # Incremental"
echo
echo "# Inspect bundles"
echo "\$ git bundle verify file.bundle             # Check validity"
echo "\$ git bundle list-heads file.bundle         # List contents"
echo
echo "# Use bundles"
echo "\$ git clone file.bundle repo                # New clone"
echo "\$ git fetch file.bundle main:main           # Fetch updates"
echo "\$ git remote add bkp file.bundle            # Use as remote"
pause

# End demo
end_demo \
  "Bundles package Git objects for offline transfer" \
  "Use --all for full backups, ^tag for incremental" \
  "Bundles preserve full history, branches, and tags" \
  "Can clone from or fetch from bundle files" \
  "Remember: bundles are not encrypted!"
