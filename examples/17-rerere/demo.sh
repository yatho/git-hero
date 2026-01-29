#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

start_demo "Git Rerere" "Reuse recorded conflict resolutions"

announce "📋 Current State"
run "git log --oneline --graph --all -n 5"
info "Main has imperial units, nutritional-info has metric + calories"
pause

announce "😫 1. The Pain: Merge Conflict"
run "git merge feature/nutritional-info" || true
warning "Conflict! Imperial vs Metric units + different display text!"
run "git merge --abort"
pause

announce "💡 3. Enable Rerere"
run "git config rerere.enabled true"
info "Rerere = Reuse Recorded Resolution"
pause

announce "🔧 2. Resolve Conflict Once"
run "git merge feature/nutritional-info" || true
cat > recipes.js << 'EOF'
#!/usr/bin/env node
const recipes = {
  pasta: { name: 'Pasta', ingredients: ['7oz pasta', '3.5oz tomato'], calories: 350, time: '20 min' }
};
function showRecipes() {
  console.log('\n📖 Recipes (Imperial + Nutrition)\n');
  Object.values(recipes).forEach(r => {
    console.log(`${r.name}: ${r.ingredients.join(', ')} - ${r.calories} cal`);
  });
}
if (require.main === module) showRecipes();
module.exports = { recipes, showRecipes };
EOF
run "git add recipes.js"
run "git commit -m 'Merge nutritional info with imperial units'"
info "Rerere recorded this resolution!"
pause

announce "✨ 3. Magic: Auto-Resolution"
run "git reset --hard HEAD~1"
run "git merge feature/nutritional-info"
success "Rerere auto-resolved the conflict!"
run "git diff HEAD"
pause

end_demo \
  "Rerere records how you resolve conflicts" \
  "Same conflicts auto-resolve in future" \
  "Saves hours during rebases/merges"
