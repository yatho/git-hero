#!/bin/bash
set -e
cd "$(dirname "$0")"
rm -rf .git
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Commit 1: add
cat > calc.js << 'E1'
function add(a, b) { return a + b; }
if (require.main === module) console.log('5 + 3 =', add(5, 3));
module.exports = { add };
E1
git add . && git commit -m "feat: add addition"

# Commit 2: subtract  
cat > calc.js << 'E2'
function add(a, b) { return a + b; }
function subtract(a, b) { return a - b; }
if (require.main === module) {
  console.log('5 + 3 =', add(5, 3));
  console.log('5 - 3 =', subtract(5, 3));
}
module.exports = { add, subtract };
E2
git add calc.js && git commit -m "feat: add subtraction"

# Commit 3: multiply (BUG)
cat > calc.js << 'E3'
function multiply(a, b) { return a + b; }
function add(a, b) { return a + b; }
function subtract(a, b) { return a - b; }
if (require.main === module) {
  console.log('5 + 3 =', add(5, 3));
  console.log('5 - 3 =', subtract(5, 3));
  console.log('5 * 3 =', multiply(5, 3));
}
module.exports = { add, subtract, multiply };
E3
git add calc.js && git commit -m "feat: add multiplication"

# Commit 4: divide
cat > calc.js << 'E4'
function multiply(a, b) { return a + b; }
function add(a, b) { return a + b; }
function subtract(a, b) { return a - b; }
function divide(a, b) { return a / b; }
if (require.main === module) {
  console.log('5 + 3 =', add(5, 3));
  console.log('5 - 3 =', subtract(5, 3));
  console.log('5 * 3 =', multiply(5, 3));
  console.log('6 / 2 =', divide(6, 2));
}
module.exports = { add, subtract, multiply, divide };
E4
git add calc.js && git commit -m "feat: add division"

echo "✅ Setup complete! Bug in commit 3. Run ./demo.sh"
