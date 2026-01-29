#!/bin/bash
set -e
cd "$(dirname "$0")"

# Clean up any existing setup
rm -rf .git
rm -f calculator.js utils.js config.json .git-blame-ignore-revs

# Initialize git repository
git init
git config user.name "Alice Developer"
git config user.email "alice@example.com"

# Create initial file by Alice
cat > calculator.js << 'EOF'
// Calculator module

function add(a, b) {
  return a + b;
}

function subtract(a, b) {
  return a - b;
}

module.exports = { add, subtract };
EOF

git add . && git commit -m "Initial calculator with add and subtract"

# Bob adds multiply
git config user.name "Bob Engineer"
git config user.email "bob@example.com"

cat > calculator.js << 'EOF'
// Calculator module

function add(a, b) {
  return a + b;
}

function subtract(a, b) {
  return a - b;
}

function multiply(a, b) {
  return a * b;
}

module.exports = { add, subtract, multiply };
EOF

git add . && git commit -m "Add multiply function"

# Carol adds divide with bug
git config user.name "Carol Coder"
git config user.email "carol@example.com"

cat > calculator.js << 'EOF'
// Calculator module

function add(a, b) {
  return a + b;
}

function subtract(a, b) {
  return a - b;
}

function multiply(a, b) {
  return a * b;
}

function divide(a, b) {
  return a / b;
}

module.exports = { add, subtract, multiply, divide };
EOF

git add . && git commit -m "Add divide function"

# Alice adds validation
git config user.name "Alice Developer"
git config user.email "alice@example.com"

cat > calculator.js << 'EOF'
// Calculator module

function add(a, b) {
  return a + b;
}

function subtract(a, b) {
  return a - b;
}

function multiply(a, b) {
  return a * b;
}

function divide(a, b) {
  if (b === 0) {
    throw new Error('Division by zero');
  }
  return a / b;
}

module.exports = { add, subtract, multiply, divide };
EOF

git add . && git commit -m "Add division by zero validation"

# Format commit (whitespace changes) by DevOps
git config user.name "DevOps Bot"
git config user.email "devops@example.com"

cat > calculator.js << 'EOF'
// Calculator module

function add(a, b) {
    return a + b;
}

function subtract(a, b) {
    return a - b;
}

function multiply(a, b) {
    return a * b;
}

function divide(a, b) {
    if (b === 0) {
        throw new Error('Division by zero');
    }
    return a / b;
}

module.exports = { add, subtract, multiply, divide };
EOF

git add . && git commit -m "Format: convert tabs to 4 spaces"

# Save formatting commit hash
FORMAT_COMMIT=$(git rev-parse HEAD)
echo "$FORMAT_COMMIT" > .formatting-commit

# Bob adds power function
git config user.name "Bob Engineer"
git config user.email "bob@example.com"

cat > calculator.js << 'EOF'
// Calculator module

function add(a, b) {
    return a + b;
}

function subtract(a, b) {
    return a - b;
}

function multiply(a, b) {
    return a * b;
}

function divide(a, b) {
    if (b === 0) {
        throw new Error('Division by zero');
    }
    return a / b;
}

function power(base, exponent) {
    return Math.pow(base, exponent);
}

module.exports = { add, subtract, multiply, divide, power };
EOF

git add . && git commit -m "Add power function"

# Carol adds modulo
git config user.name "Carol Coder"
git config user.email "carol@example.com"

cat > calculator.js << 'EOF'
// Calculator module

function add(a, b) {
    return a + b;
}

function subtract(a, b) {
    return a - b;
}

function multiply(a, b) {
    return a * b;
}

function divide(a, b) {
    if (b === 0) {
        throw new Error('Division by zero');
    }
    return a / b;
}

function power(base, exponent) {
    return Math.pow(base, exponent);
}

function modulo(a, b) {
    if (b === 0) {
        throw new Error('Modulo by zero');
    }
    return a % b;
}

module.exports = { add, subtract, multiply, divide, power, modulo };
EOF

git add . && git commit -m "Add modulo function with zero check"

# Create utils.js with multiple contributors
git config user.name "Alice Developer"
git config user.email "alice@example.com"

cat > utils.js << 'EOF'
// Utility functions

function isNumber(value) {
    return typeof value === 'number' && !isNaN(value);
}

module.exports = { isNumber };
EOF

git add . && git commit -m "Add isNumber utility"

git config user.name "Bob Engineer"
git config user.email "bob@example.com"

cat > utils.js << 'EOF'
// Utility functions

function isNumber(value) {
    return typeof value === 'number' && !isNaN(value);
}

function round(value, decimals = 2) {
    return Number(Math.round(value + 'e' + decimals) + 'e-' + decimals);
}

module.exports = { isNumber, round };
EOF

git add . && git commit -m "Add round utility function"

# Reset user for demo
git config user.name "Demo User"
git config user.email "demo@example.com"

echo "✅ Setup complete! Run ./demo.sh to start the demonstration"
