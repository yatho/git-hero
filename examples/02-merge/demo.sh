#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

# ===============================
# Git Merge Demo
# ===============================

start_demo "Git Merge" "Understand and resolve merge conflicts"

# -------------------------
announce "📋 1. The Scenario"

echo "We have a shopping cart application with two new features:"
echo "  • feature/tax-calculation: Adds 20% VAT to purchases"
echo "  • feature/discount-system: Adds discount codes"
echo
echo "Both features modify the same function: calculateTotal()"
echo
pause

# -------------------------
announce "🌳 2. View the Branches"

run "git log --oneline --all --graph --decorate"
pause

# -------------------------
announce "✅ 3. Test Both Features Independently"

info "Testing tax calculation feature..."
run "git switch feature/tax-calculation"
echo
warning "Run the app to see tax in action:"
run "node cart.js"
echo
pause

info "Testing discount system feature..."
run "git switch feature/discount-system"
echo
warning "Run the app to see discounts in action:"
run "node cart.js"
echo
pause

# -------------------------
announce "🔀 4. Merge Tax Feature (Easy - No Conflict)"

run "git switch main"
run "git merge feature/tax-calculation -m 'Merge tax calculation feature'"
success "Tax feature merged successfully!"
pause

# -------------------------
announce "⚠️  5. Merge Discount Feature (CONFLICT!)"

info "Now let's try to merge the discount feature..."
echo
run "git merge feature/discount-system" || true
echo
error "CONFLICT! Both features modified calculateTotal()"
pause

# -------------------------
announce "🔍 6. Examine the Conflict"

run "git status"
pause

info "Let's look at the conflict markers in cart.js..."
echo
echo "The file now contains conflict markers:"
echo "  <<<<<<< HEAD           (our changes - tax)"
echo "  =======                (separator)"
echo "  >>>>>>> feature/discount-system  (their changes - discount)"
echo
warning "View the conflict: cat cart.js | grep -A 20 '<<<<<<'"
pause

# Enable diff3 conflict style (shows common ancestor)
info "How to know what BOTH sides changed?"
echo
run "git merge --abort"
run "git config merge.conflictstyle diff3"
run "git merge feature/discount-system" || true
echo
error "CONFLICT! Both features modified calculateTotal()"
pause
echo
echo "The file now contains conflict markers:"
echo "  <<<<<<< HEAD           (our changes - tax)"
echo "  ||||||| merged common ancestors  (original version)"
echo "  =======                (separator)"
echo "  >>>>>>> feature/discount-system  (their changes - discount)"
echo
warning "View the conflict: cat cart.js | grep -A 20 '<<<<<<'"
pause

# -------------------------
announce "🔧 7. Understanding diff3 Conflict Style"

echo "Git is configured to use 'diff3' conflict style."
echo
echo "This shows THREE versions:"
echo "  1. HEAD (our changes) - tax calculation"
echo "  2. Common ancestor - original simple version"
echo "  3. Incoming (their changes) - discount system"
echo
echo "This helps understand what BOTH sides changed!"
pause

# -------------------------
announce "✏️  8. Resolve the Conflict"

echo "We need to manually edit cart.js to include BOTH features:"
echo
echo "The resolved calculateTotal() should:"
echo "  1. Calculate subtotal"
echo "  2. Apply discount (from discount feature)"
echo "  3. Apply tax (from tax feature)"
echo "  4. Return all breakdown values"
echo
warning "In a real demo, you would now edit cart.js to resolve the conflict."
echo "For this automated demo, we'll simulate the resolution..."
pause

# Since this is automated, create the resolved version
cat > cart.js << 'EOF'
#!/usr/bin/env node

/**
 * Shopping Cart CLI
 * With BOTH tax and discount features integrated
 */

const items = [
  { id: 1, name: 'Laptop', price: 999.99 },
  { id: 2, name: 'Mouse', price: 29.99 },
  { id: 3, name: 'Keyboard', price: 79.99 },
  { id: 4, name: 'Monitor', price: 299.99 }
];

const TAX_RATE = 0.20;  // 20% VAT
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

  // Apply tax AFTER discount
  let afterDiscount = subtotal - discount;
  let tax = afterDiscount * TAX_RATE;

  // Calculate final total
  let total = afterDiscount + tax;

  return {
    subtotal: subtotal,
    discount: discount,
    tax: tax,
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

success "Conflict resolved! Both features are now integrated."
pause

# -------------------------
announce "✅ 9. Complete the Merge"

run "git add cart.js"
run "git commit -m 'Merge discount system with tax calculation'"
success "Merge completed successfully!"
pause

# -------------------------
announce "🎉 10. Test the Final Result"

info "Now the app has BOTH tax and discounts working together!"
echo
warning "Run the app to see both features:"
run "node cart.js"
echo
pause

# End demo
end_demo \
  "Merge conflicts occur when the same code is modified in different branches" \
  "diff3 conflict style shows the common ancestor for better understanding" \
  "Manual resolution requires understanding what both sides changed" \
  "Always test after resolving conflicts!"
