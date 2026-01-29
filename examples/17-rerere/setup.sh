#!/bin/bash
set -e
cd "$(dirname "$0")"
rm -rf .git
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"
git config rerere.enabled false  # Start with rerere disabled

# Main: metric units
cat > recipes.js << 'E1'
#!/usr/bin/env node
const recipes = {
  pasta: { name: 'Pasta', ingredients: ['200g pasta', '100g tomato'], time: '20 min' }
};
function showRecipes() {
  console.log('\n📖 Recipes\n');
  Object.values(recipes).forEach(r => {
    console.log(`${r.name}: ${r.ingredients.join(', ')}`);
  });
}
if (require.main === module) showRecipes();
module.exports = { recipes, showRecipes };
E1
git add . && git commit -m "feat: initial recipe book (metric)"

# Branch: imperial units
git checkout -b feature/imperial-units
cat > recipes.js << 'E2'
#!/usr/bin/env node
const recipes = {
  pasta: { name: 'Pasta', ingredients: ['7oz pasta', '3.5oz tomato'], time: '20 min' }
};
function showRecipes() {
  console.log('\n📖 Recipes (Imperial)\n');
  Object.values(recipes).forEach(r => {
    console.log(`${r.name}: ${r.ingredients.join(', ')}`);
  });
}
if (require.main === module) showRecipes();
module.exports = { recipes, showRecipes };
E2
git add recipes.js && git commit -m "feat: convert to imperial units"

# Branch: nutritional info
git checkout main
git checkout -b feature/nutritional-info
cat > recipes.js << 'E3'
#!/usr/bin/env node
const recipes = {
  pasta: { name: 'Pasta', ingredients: ['200g pasta', '100g tomato'], calories: 350, time: '20 min' }
};
function showRecipes() {
  console.log('\n📖 Recipes (with Nutrition)\n');
  Object.values(recipes).forEach(r => {
    console.log(`${r.name}: ${r.ingredients.join(', ')} - ${r.calories} cal`);
  });
}
if (require.main === module) showRecipes();
module.exports = { recipes, showRecipes };
E3
git add recipes.js && git commit -m "feat: add nutritional information"

git checkout main
git merge feature/imperial-units --no-edit  # Main now has imperial units
echo "✅ Setup complete! Main has imperial units, nutritional-info will conflict. Run ./demo.sh"
