#!/bin/bash
set -e
cd "$(dirname "$0")"

# Initialize git repository
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Create initial JavaScript file
cat > calculator.js << 'EOF'
class Calculator {
  add(a, b) {
    return a + b;
  }

  subtract(a, b) {
    return a - b;
  }

  multiply(a, b) {
    return a * b;
  }

  divide(a, b) {
    if (b === 0) {
      throw new Error('Division by zero');
    }
    return a / b;
  }
}

module.exports = Calculator;
EOF

# Create package.json
cat > package.json << 'EOF'
{
  "name": "calculator-demo",
  "version": "1.0.0",
  "description": "Calculator for git diff demo",
  "main": "calculator.js",
  "scripts": {
    "test": "echo \"No tests yet\""
  },
  "dependencies": {
    "lodash": "^4.17.21"
  }
}
EOF

# Create a simple package-lock.json
cat > package-lock.json << 'EOF'
{
  "name": "calculator-demo",
  "version": "1.0.0",
  "lockfileVersion": 2,
  "requires": true,
  "packages": {
    "": {
      "name": "calculator-demo",
      "version": "1.0.0",
      "dependencies": {
        "lodash": "^4.17.21"
      }
    },
    "node_modules/lodash": {
      "version": "4.17.21",
      "resolved": "https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz",
      "integrity": "sha512-v2kDEe57lecTulaDIuNTPy3Ry4gLGJ6Z1O3vE1krgXZNrsQ+LFTGHVxVjcXPs17LhbZVGedAJv8XZ1tvj5FvSg=="
    }
  },
  "dependencies": {
    "lodash": {
      "version": "4.17.21",
      "resolved": "https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz",
      "integrity": "sha512-v2kDEe57lecTulaDIuNTPy3Ry4gLGJ6Z1O3vE1krgXZNrsQ+LFTGHVxVjcXPs17LhbZVGedAJv8XZ1tvj5FvSg=="
    }
  }
}
EOF

# Create README
cat > README-demo.md << 'EOF'
# Calculator Demo

A simple calculator for demonstrating git diff features.

## Features
- Addition
- Subtraction
- Multiplication
- Division
EOF

# Create .gitattributes to handle line endings consistently
cat > .gitattributes << 'EOF'
* text=auto
*.js text eol=lf
*.json text eol=lf
*.md text eol=lf
EOF

# Initial commit
git add .
git commit -m "Initial calculator implementation"

echo "✅ Setup complete! Run ./demo.sh to start the demonstration"
