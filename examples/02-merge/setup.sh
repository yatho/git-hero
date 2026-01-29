#!/bin/bash
set -e

echo "🔧 Setting up Git Merge demonstration..."
echo

cd "$(dirname "$0")"

# Remove existing git repo
rm -rf .git

# Initialize new repo
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"
git config merge.conflictstyle merge

# ==========================================
# Commit 1: Basic shopping cart (no tax, no discount)
# ==========================================
echo "Creating main branch with basic cart..."

cat > cart.js << 'EOF'
#!/usr/bin/env node

/**
 * Shopping Cart CLI
 * Basic version without tax or discount
 */

const items = [
  { id: 1, name: 'Laptop', price: 999.99 },
  { id: 2, name: 'Mouse', price: 29.99 },
  { id: 3, name: 'Keyboard', price: 79.99 },
  { id: 4, name: 'Monitor', price: 299.99 }
];

// ANSI colors
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  cyan: '\x1b[36m'
};

function showItems() {
  console.log(`${colors.cyan}╔════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.cyan}║       Available Items          ║${colors.reset}`);
  console.log(`${colors.cyan}╚════════════════════════════════╝${colors.reset}`);
  console.log();

  items.forEach(item => {
    console.log(`${item.id}. ${item.name.padEnd(15)} €${item.price.toFixed(2)}`);
  });
  console.log();
}

function calculateTotal(cart) {
  // Simple total calculation
  let total = cart.reduce((sum, item) => sum + item.price, 0);
  return total;
}

function showCart(cart) {
  console.log(`${colors.blue}Shopping Cart:${colors.reset}`);

  if (cart.length === 0) {
    console.log('  (empty)');
    return;
  }

  cart.forEach((item, index) => {
    console.log(`  ${index + 1}. ${item.name} - €${item.price.toFixed(2)}`);
  });
  console.log();

  const total = calculateTotal(cart);
  console.log(`  ${colors.yellow}Total: €${total.toFixed(2)}${colors.reset}`);
  console.log();
}

// Demo usage
function demo() {
  console.log(`${colors.cyan}Shopping Cart Demo${colors.reset}`);
  console.log();

  showItems();

  const myCart = [
    items[0],  // Laptop
    items[1]   // Mouse
  ];

  showCart(myCart);
}

if (require.main === module) {
  demo();
}

module.exports = { calculateTotal, showCart, showItems };
EOF

git add .
git commit -m "feat: initial shopping cart with basic total calculation"

# ==========================================
# Branch: feature/tax-calculation
# ==========================================
echo "Creating feature/tax-calculation branch..."

git checkout -b feature/tax-calculation

cat > cart.js << 'EOF'
#!/usr/bin/env node

/**
 * Shopping Cart CLI
 * With tax calculation
 */

const items = [
  { id: 1, name: 'Laptop', price: 999.99 },
  { id: 2, name: 'Mouse', price: 29.99 },
  { id: 3, name: 'Keyboard', price: 79.99 },
  { id: 4, name: 'Monitor', price: 299.99 }
];

const TAX_RATE = 0.20;  // 20% VAT

// ANSI colors
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  cyan: '\x1b[36m'
};

function showItems() {
  console.log(`${colors.cyan}╔════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.cyan}║       Available Items          ║${colors.reset}`);
  console.log(`${colors.cyan}╚════════════════════════════════╝${colors.reset}`);
  console.log();

  items.forEach(item => {
    console.log(`${item.id}. ${item.name.padEnd(15)} €${item.price.toFixed(2)}`);
  });
  console.log();
}

function calculateTotal(cart) {
  // Calculate subtotal
  let subtotal = cart.reduce((sum, item) => sum + item.price, 0);

  // Apply tax
  let tax = subtotal * TAX_RATE;

  // Calculate final total
  let total = subtotal + tax;

  return {
    subtotal: subtotal,
    tax: tax,
    total: total
  };
}

function showCart(cart) {
  console.log(`${colors.blue}Shopping Cart:${colors.reset}`);

  if (cart.length === 0) {
    console.log('  (empty)');
    return;
  }

  cart.forEach((item, index) => {
    console.log(`  ${index + 1}. ${item.name} - €${item.price.toFixed(2)}`);
  });
  console.log();

  const breakdown = calculateTotal(cart);

  console.log(`  Subtotal:     €${breakdown.subtotal.toFixed(2)}`);
  console.log(`  Tax (20%):    €${breakdown.tax.toFixed(2)}`);
  console.log(`  ${colors.yellow}Total:        €${breakdown.total.toFixed(2)}${colors.reset}`);
  console.log();
}

// Demo usage
function demo() {
  console.log(`${colors.cyan}Shopping Cart Demo${colors.reset}`);
  console.log();

  showItems();

  const myCart = [
    items[0],  // Laptop
    items[1]   // Mouse
  ];

  showCart(myCart);
}

if (require.main === module) {
  demo();
}

module.exports = { calculateTotal, showCart, showItems };
EOF

git add cart.js
git commit -m "feat: add tax calculation (20% VAT)"

# ==========================================
# Branch: feature/discount-system
# ==========================================
echo "Creating feature/discount-system branch..."

git checkout main
git checkout -b feature/discount-system

cat > cart.js << 'EOF'
#!/usr/bin/env node

/**
 * Shopping Cart CLI
 * With discount code system
 */

const items = [
  { id: 1, name: 'Laptop', price: 999.99 },
  { id: 2, name: 'Mouse', price: 29.99 },
  { id: 3, name: 'Keyboard', price: 79.99 },
  { id: 4, name: 'Monitor', price: 299.99 }
];

const DISCOUNT_CODE = 'SAVE10';
const DISCOUNT_RATE = 0.10;  // 10% discount

// ANSI colors
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  cyan: '\x1b[36m'
};

function showItems() {
  console.log(`${colors.cyan}╔════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.cyan}║       Available Items          ║${colors.reset}`);
  console.log(`${colors.cyan}╚════════════════════════════════╝${colors.reset}`);
  console.log();

  items.forEach(item => {
    console.log(`${item.id}. ${item.name.padEnd(15)} €${item.price.toFixed(2)}`);
  });
  console.log();
}

function calculateTotal(cart, discountCode = null) {
  // Calculate subtotal
  let subtotal = cart.reduce((sum, item) => sum + item.price, 0);

  // Apply discount if code is valid
  let discount = 0;
  if (discountCode && discountCode === DISCOUNT_CODE) {
    discount = subtotal * DISCOUNT_RATE;
  }

  // Calculate final total
  let total = subtotal - discount;

  return {
    subtotal: subtotal,
    discount: discount,
    total: total
  };
}

function showCart(cart, discountCode = null) {
  console.log(`${colors.blue}Shopping Cart:${colors.reset}`);

  if (cart.length === 0) {
    console.log('  (empty)');
    return;
  }

  cart.forEach((item, index) => {
    console.log(`  ${index + 1}. ${item.name} - €${item.price.toFixed(2)}`);
  });
  console.log();

  const breakdown = calculateTotal(cart, discountCode);

  console.log(`  Subtotal:     €${breakdown.subtotal.toFixed(2)}`);

  if (breakdown.discount > 0) {
    console.log(`  ${colors.green}Discount:     -€${breakdown.discount.toFixed(2)}${colors.reset}`);
  }

  console.log(`  ${colors.yellow}Total:        €${breakdown.total.toFixed(2)}${colors.reset}`);
  console.log();
}

// Demo usage
function demo() {
  console.log(`${colors.cyan}Shopping Cart Demo${colors.reset}`);
  console.log();

  showItems();

  const myCart = [
    items[0],  // Laptop
    items[1]   // Mouse
  ];

  console.log('Cart without discount:');
  showCart(myCart);

  console.log(`Cart with discount code "${DISCOUNT_CODE}":`);
  showCart(myCart, DISCOUNT_CODE);
}

if (require.main === module) {
  demo();
}

module.exports = { calculateTotal, showCart, showItems };
EOF

git add cart.js
git commit -m "feat: add discount code system (10% off)"

# Return to main
git checkout main

echo
echo "✅ Setup complete!"
echo
echo "Git repository created with:"
echo "  • main: Basic cart"
echo "  • feature/tax-calculation: Adds 20% tax"
echo "  • feature/discount-system: Adds discount codes"
echo "  • Both branches modify calculateTotal() → CONFLICT!"
echo
echo "Run the demo with: ./demo.sh"
echo "Or explore manually: git log --oneline --all --graph"
