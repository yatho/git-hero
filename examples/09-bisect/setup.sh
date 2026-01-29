#!/bin/bash
set -e

echo "🔧 Setting up Git Bisect demonstration..."
echo

# Navigate to example directory
cd "$(dirname "$0")"

# Initialize new repo
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# ==========================================
# Commit 1: Initial version with basic game
# ==========================================
echo "Creating commit 1/18: Initial version..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const MIN = 1;
const MAX = 100;
let attempts = 0;

function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

function binarySearch(low, high) {
  return Math.floor((low + high) / 2);
}

async function playGame() {
  console.log('Think of a number between 1 and 100');
  console.log("I'll try to guess it!\n");

  let low = MIN;
  let high = MAX;
  attempts = 0;

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    if (answer.toLowerCase() === 'c') {
      console.log(`Yay! I guessed it in ${attempts} attempts!`);
      return true;
    } else if (answer.toLowerCase() === 'h') {
      high = guess - 1;
    } else if (answer.toLowerCase() === 'l') {
      low = guess + 1;
    }
  }

  return false;
}

async function main() {
  await playGame();
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

cat > number-guesser.test.js << 'EOF'
#!/usr/bin/env node
const { binarySearch } = require('./number-guesser.js');

function test() {
  const tests = [
    { low: 1, high: 100, expected: 50 },
    { low: 1, high: 10, expected: 5 },
    { low: 50, high: 100, expected: 75 }
  ];

  let failed = 0;
  for (const test of tests) {
    const result = binarySearch(test.low, test.high);
    if (result !== test.expected) {
      console.error(`❌ FAIL: binarySearch(${test.low}, ${test.high}) = ${result}, expected ${test.expected}`);
      failed++;
    }
  }

  if (failed > 0) {
    process.exit(1);
  } else {
    console.log(`✅ All tests passed`);
    process.exit(0);
  }
}

test();
EOF

git add .
git commit -m "feat: initial number guessing game with binary search"

# ==========================================
# Commit 2: Add score tracking
# ==========================================
echo "Creating commit 2/18: Add score tracking..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const MIN = 1;
const MAX = 100;
let attempts = 0;
let score = 0;

function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

function binarySearch(low, high) {
  return Math.floor((low + high) / 2);
}

async function playGame() {
  console.log('Think of a number between 1 and 100');
  console.log("I'll try to guess it!\n");

  let low = MIN;
  let high = MAX;
  attempts = 0;

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    if (answer.toLowerCase() === 'c') {
      score += Math.max(10 - attempts, 1);
      console.log(`Yay! I guessed it in ${attempts} attempts!`);
      console.log(`Score: ${score} points`);
      return true;
    } else if (answer.toLowerCase() === 'h') {
      high = guess - 1;
    } else if (answer.toLowerCase() === 'l') {
      low = guess + 1;
    }
  }

  return false;
}

async function main() {
  await playGame();
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "feat: add score tracking system"

# ==========================================
# Commit 3: Add helpful hints
# ==========================================
echo "Creating commit 3/18: Add hints..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const MIN = 1;
const MAX = 100;
let attempts = 0;
let score = 0;

function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

function binarySearch(low, high) {
  return Math.floor((low + high) / 2);
}

function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts`);
}

async function playGame() {
  console.log('Think of a number between 1 and 100');
  console.log("I'll try to guess it!\n");
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    if (answer.toLowerCase() === 'c') {
      score += Math.max(10 - attempts, 1);
      console.log(`Yay! I guessed it in ${attempts} attempts!`);
      console.log(`Score: ${score} points`);
      return true;
    } else if (answer.toLowerCase() === 'h') {
      high = guess - 1;
    } else if (answer.toLowerCase() === 'l') {
      low = guess + 1;
    }
  }

  return false;
}

async function main() {
  await playGame();
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "feat: add hints about expected performance"

# ==========================================
# Commit 4: Add replay functionality
# ==========================================
echo "Creating commit 4/18: Add replay functionality..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const MIN = 1;
const MAX = 100;
let attempts = 0;
let score = 0;

function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

function binarySearch(low, high) {
  return Math.floor((low + high) / 2);
}

function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts`);
}

async function playGame() {
  console.log('Think of a number between 1 and 100');
  console.log("I'll try to guess it!\n");
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    if (answer.toLowerCase() === 'c') {
      score += Math.max(10 - attempts, 1);
      console.log(`Yay! I guessed it in ${attempts} attempts!`);
      console.log(`Score: ${score} points`);
      return true;
    } else if (answer.toLowerCase() === 'h') {
      high = guess - 1;
    } else if (answer.toLowerCase() === 'l') {
      low = guess + 1;
    }
  }

  return false;
}

async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question('\nPlay again? (y/n): ');
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(`\nThanks for playing! Final score: ${score}`);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "feat: add replay functionality"

# ==========================================
# Commit 5: Add colors - TAG v1.0.0 here
# ==========================================
echo "Creating commit 5/18: Add colors (v1.0.0)..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const MIN = 1;
const MAX = 100;
let attempts = 0;
let score = 0;

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m'
};

function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

function binarySearch(low, high) {
  return Math.floor((low + high) / 2);
}

function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`${colors.yellow}Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts${colors.reset}`);
}

async function playGame() {
  console.log(`${colors.blue}Think of a number between 1 and 100${colors.reset}`);
  console.log("I'll try to guess it!\n");
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    if (answer.toLowerCase() === 'c') {
      score += Math.max(10 - attempts, 1);
      console.log(`${colors.green}Yay! I guessed it in ${attempts} attempts!${colors.reset}`);
      console.log(`${colors.green}Score: ${score} points${colors.reset}`);
      return true;
    } else if (answer.toLowerCase() === 'h') {
      high = guess - 1;
    } else if (answer.toLowerCase() === 'l') {
      low = guess + 1;
    }
  }

  return false;
}

async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question('\nPlay again? (y/n): ');
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(`\nThanks for playing! Final score: ${score}`);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "feat: add color output for better UX"

# Tag this as the last known good version
git tag -a v1.0.0 -m "Version 1.0.0 - Stable release"

# ==========================================
# Commit 6: Extract message constants
# ==========================================
echo "Creating commit 6/18: Extract message constants..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const MIN = 1;
const MAX = 100;
let attempts = 0;
let score = 0;

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m'
};

// Message constants
const MESSAGES = {
  INTRO: 'Think of a number between 1 and 100',
  INTRO_2: "I'll try to guess it!",
  PLAY_AGAIN: '\nPlay again? (y/n): ',
  THANKS: '\nThanks for playing! Final score: '
};

function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

function binarySearch(low, high) {
  return Math.floor((low + high) / 2);
}

function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`${colors.yellow}Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts${colors.reset}`);
}

async function playGame() {
  console.log(`${colors.blue}${MESSAGES.INTRO}${colors.reset}`);
  console.log(MESSAGES.INTRO_2);
  console.log();
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    if (answer.toLowerCase() === 'c') {
      score += Math.max(10 - attempts, 1);
      console.log(`${colors.green}Yay! I guessed it in ${attempts} attempts!${colors.reset}`);
      console.log(`${colors.green}Score: ${score} points${colors.reset}`);
      return true;
    } else if (answer.toLowerCase() === 'h') {
      high = guess - 1;
    } else if (answer.toLowerCase() === 'l') {
      low = guess + 1;
    }
  }

  return false;
}

async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question(MESSAGES.PLAY_AGAIN);
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(MESSAGES.THANKS + score);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "refactor: extract message constants"

# ==========================================
# Commit 7: Add input validation
# ==========================================
echo "Creating commit 7/18: Add input validation..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const MIN = 1;
const MAX = 100;
let attempts = 0;
let score = 0;

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m'
};

// Message constants
const MESSAGES = {
  INTRO: 'Think of a number between 1 and 100',
  INTRO_2: "I'll try to guess it!",
  PLAY_AGAIN: '\nPlay again? (y/n): ',
  THANKS: '\nThanks for playing! Final score: ',
  INVALID_INPUT: 'Invalid input! Please enter h, l, or c.'
};

function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

function binarySearch(low, high) {
  return Math.floor((low + high) / 2);
}

function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`${colors.yellow}Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts${colors.reset}`);
}

async function playGame() {
  console.log(`${colors.blue}${MESSAGES.INTRO}${colors.reset}`);
  console.log(MESSAGES.INTRO_2);
  console.log();
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    const input = answer.toLowerCase();

    if (input === 'c') {
      score += Math.max(10 - attempts, 1);
      console.log(`${colors.green}Yay! I guessed it in ${attempts} attempts!${colors.reset}`);
      console.log(`${colors.green}Score: ${score} points${colors.reset}`);
      return true;
    } else if (input === 'h') {
      high = guess - 1;
    } else if (input === 'l') {
      low = guess + 1;
    } else {
      console.log(`${colors.red}${MESSAGES.INVALID_INPUT}${colors.reset}`);
      attempts--;  // Don't count invalid attempts
    }
  }

  return false;
}

async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question(MESSAGES.PLAY_AGAIN);
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(MESSAGES.THANKS + score);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "feat: add input validation"

# ==========================================
# Commit 8: Improve error messages
# ==========================================
echo "Creating commit 8/18: Improve error messages..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const MIN = 1;
const MAX = 100;
let attempts = 0;
let score = 0;

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m'
};

// Message constants
const MESSAGES = {
  INTRO: 'Think of a number between 1 and 100',
  INTRO_2: "I'll try to guess it!",
  PLAY_AGAIN: '\nPlay again? (y/n): ',
  THANKS: '\nThanks for playing! Final score: ',
  INVALID_INPUT: 'Invalid input! Please enter:',
  INVALID_HELP: '  h = number is too high\n  l = number is too low\n  c = correct guess'
};

function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

function binarySearch(low, high) {
  return Math.floor((low + high) / 2);
}

function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`${colors.yellow}Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts${colors.reset}`);
}

async function playGame() {
  console.log(`${colors.blue}${MESSAGES.INTRO}${colors.reset}`);
  console.log(MESSAGES.INTRO_2);
  console.log();
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    const input = answer.toLowerCase();

    if (input === 'c') {
      score += Math.max(10 - attempts, 1);
      console.log(`${colors.green}Yay! I guessed it in ${attempts} attempts!${colors.reset}`);
      console.log(`${colors.green}Score: ${score} points${colors.reset}`);
      return true;
    } else if (input === 'h') {
      high = guess - 1;
    } else if (input === 'l') {
      low = guess + 1;
    } else {
      console.log(`${colors.red}${MESSAGES.INVALID_INPUT}${colors.reset}`);
      console.log(MESSAGES.INVALID_HELP);
      attempts--;  // Don't count invalid attempts
    }
  }

  return false;
}

async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question(MESSAGES.PLAY_AGAIN);
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(MESSAGES.THANKS + score);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "feat: improve error messages with help text"

# ==========================================
# Commit 9: Add JSDoc comments
# ==========================================
echo "Creating commit 9/18: Add JSDoc comments..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

/**
 * Number Guessing Game
 * The computer guesses a number you're thinking of using binary search
 */

const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const MIN = 1;
const MAX = 100;
let attempts = 0;
let score = 0;

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m'
};

// Message constants
const MESSAGES = {
  INTRO: 'Think of a number between 1 and 100',
  INTRO_2: "I'll try to guess it!",
  PLAY_AGAIN: '\nPlay again? (y/n): ',
  THANKS: '\nThanks for playing! Final score: ',
  INVALID_INPUT: 'Invalid input! Please enter:',
  INVALID_HELP: '  h = number is too high\n  l = number is too low\n  c = correct guess'
};

/**
 * Promisified readline question
 * @param {string} query - The question to ask
 * @returns {Promise<string>} User's answer
 */
function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

/**
 * Binary search algorithm to find midpoint
 * @param {number} low - Lower bound
 * @param {number} high - Upper bound
 * @returns {number} Midpoint
 */
function binarySearch(low, high) {
  return Math.floor((low + high) / 2);
}

/**
 * Display hint about binary search efficiency
 */
function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`${colors.yellow}Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts${colors.reset}`);
}

/**
 * Play one round of the guessing game
 * @returns {Promise<boolean>} True if game completed successfully
 */
async function playGame() {
  console.log(`${colors.blue}${MESSAGES.INTRO}${colors.reset}`);
  console.log(MESSAGES.INTRO_2);
  console.log();
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    const input = answer.toLowerCase();

    if (input === 'c') {
      score += Math.max(10 - attempts, 1);
      console.log(`${colors.green}Yay! I guessed it in ${attempts} attempts!${colors.reset}`);
      console.log(`${colors.green}Score: ${score} points${colors.reset}`);
      return true;
    } else if (input === 'h') {
      high = guess - 1;
    } else if (input === 'l') {
      low = guess + 1;
    } else {
      console.log(`${colors.red}${MESSAGES.INVALID_INPUT}${colors.reset}`);
      console.log(MESSAGES.INVALID_HELP);
      attempts--;  // Don't count invalid attempts
    }
  }

  return false;
}

/**
 * Main game loop
 */
async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question(MESSAGES.PLAY_AGAIN);
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(MESSAGES.THANKS + score);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "docs: add JSDoc comments for better documentation"

# ==========================================
# Commit 10: Refactor constants to top
# ==========================================
echo "Creating commit 10/18: Refactor constants..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

/**
 * Number Guessing Game
 * The computer guesses a number you're thinking of using binary search
 */

const readline = require('readline');

// Game configuration
const MIN = 1;
const MAX = 100;
const MAX_SCORE_ATTEMPTS = 10;
const MIN_POINTS = 1;

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m'
};

// Message constants
const MESSAGES = {
  INTRO: 'Think of a number between 1 and 100',
  INTRO_2: "I'll try to guess it!",
  PLAY_AGAIN: '\nPlay again? (y/n): ',
  THANKS: '\nThanks for playing! Final score: ',
  INVALID_INPUT: 'Invalid input! Please enter:',
  INVALID_HELP: '  h = number is too high\n  l = number is too low\n  c = correct guess'
};

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

let attempts = 0;
let score = 0;

/**
 * Promisified readline question
 * @param {string} query - The question to ask
 * @returns {Promise<string>} User's answer
 */
function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

/**
 * Binary search algorithm to find midpoint
 * @param {number} low - Lower bound
 * @param {number} high - Upper bound
 * @returns {number} Midpoint
 */
function binarySearch(low, high) {
  return Math.floor((low + high) / 2);
}

/**
 * Display hint about binary search efficiency
 */
function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`${colors.yellow}Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts${colors.reset}`);
}

/**
 * Play one round of the guessing game
 * @returns {Promise<boolean>} True if game completed successfully
 */
async function playGame() {
  console.log(`${colors.blue}${MESSAGES.INTRO}${colors.reset}`);
  console.log(MESSAGES.INTRO_2);
  console.log();
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    const input = answer.toLowerCase();

    if (input === 'c') {
      score += Math.max(MAX_SCORE_ATTEMPTS - attempts, MIN_POINTS);
      console.log(`${colors.green}Yay! I guessed it in ${attempts} attempts!${colors.reset}`);
      console.log(`${colors.green}Score: ${score} points${colors.reset}`);
      return true;
    } else if (input === 'h') {
      high = guess - 1;
    } else if (input === 'l') {
      low = guess + 1;
    } else {
      console.log(`${colors.red}${MESSAGES.INVALID_INPUT}${colors.reset}`);
      console.log(MESSAGES.INVALID_HELP);
      attempts--;  // Don't count invalid attempts
    }
  }

  return false;
}

/**
 * Main game loop
 */
async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question(MESSAGES.PLAY_AGAIN);
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(MESSAGES.THANKS + score);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "refactor: organize constants at top of file"

# ==========================================
# Commit 11: THE BUG - broken binary search
# ==========================================
echo "Creating commit 11/18: THE BUG is introduced..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

/**
 * Number Guessing Game
 * The computer guesses a number you're thinking of using binary search
 */

const readline = require('readline');

// Game configuration
const MIN = 1;
const MAX = 100;
const MAX_SCORE_ATTEMPTS = 10;
const MIN_POINTS = 1;

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m'
};

// Message constants
const MESSAGES = {
  INTRO: 'Think of a number between 1 and 100',
  INTRO_2: "I'll try to guess it!",
  PLAY_AGAIN: '\nPlay again? (y/n): ',
  THANKS: '\nThanks for playing! Final score: ',
  INVALID_INPUT: 'Invalid input! Please enter:',
  INVALID_HELP: '  h = number is too high\n  l = number is too low\n  c = correct guess'
};

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

let attempts = 0;
let score = 0;

/**
 * Promisified readline question
 * @param {string} query - The question to ask
 * @returns {Promise<string>} User's answer
 */
function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

/**
 * Binary search algorithm to find midpoint
 * @param {number} low - Lower bound
 * @param {number} high - Upper bound
 * @returns {number} Midpoint
 */
function binarySearch(low, high) {
  // BUG: +5 breaks the algorithm
  return Math.floor((low + high) / 2) + 5;
}

/**
 * Display hint about binary search efficiency
 */
function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`${colors.yellow}Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts${colors.reset}`);
}

/**
 * Play one round of the guessing game
 * @returns {Promise<boolean>} True if game completed successfully
 */
async function playGame() {
  console.log(`${colors.blue}${MESSAGES.INTRO}${colors.reset}`);
  console.log(MESSAGES.INTRO_2);
  console.log();
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    const input = answer.toLowerCase();

    if (input === 'c') {
      score += Math.max(MAX_SCORE_ATTEMPTS - attempts, MIN_POINTS);
      console.log(`${colors.green}Yay! I guessed it in ${attempts} attempts!${colors.reset}`);
      console.log(`${colors.green}Score: ${score} points${colors.reset}`);
      return true;
    } else if (input === 'h') {
      high = guess - 1;
    } else if (input === 'l') {
      low = guess + 1;
    } else {
      console.log(`${colors.red}${MESSAGES.INVALID_INPUT}${colors.reset}`);
      console.log(MESSAGES.INVALID_HELP);
      attempts--;  // Don't count invalid attempts
    }
  }

  return false;
}

/**
 * Main game loop
 */
async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question(MESSAGES.PLAY_AGAIN);
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(MESSAGES.THANKS + score);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "refactor: optimize midpoint calculation"

# ==========================================
# Commit 12: Add welcome banner (bug still present)
# ==========================================
echo "Creating commit 12/18: Add welcome banner..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

/**
 * Number Guessing Game
 * The computer guesses a number you're thinking of using binary search
 */

const readline = require('readline');

// Game configuration
const MIN = 1;
const MAX = 100;
const MAX_SCORE_ATTEMPTS = 10;
const MIN_POINTS = 1;

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m'
};

// Message constants
const MESSAGES = {
  INTRO: 'Think of a number between 1 and 100',
  INTRO_2: "I'll try to guess it!",
  PLAY_AGAIN: '\nPlay again? (y/n): ',
  THANKS: '\nThanks for playing! Final score: ',
  INVALID_INPUT: 'Invalid input! Please enter:',
  INVALID_HELP: '  h = number is too high\n  l = number is too low\n  c = correct guess'
};

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

let attempts = 0;
let score = 0;

/**
 * Promisified readline question
 * @param {string} query - The question to ask
 * @returns {Promise<string>} User's answer
 */
function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

/**
 * Binary search algorithm to find midpoint
 * @param {number} low - Lower bound
 * @param {number} high - Upper bound
 * @returns {number} Midpoint
 */
function binarySearch(low, high) {
  // BUG: +5 breaks the algorithm
  return Math.floor((low + high) / 2) + 5;
}

/**
 * Display hint about binary search efficiency
 */
function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`${colors.yellow}Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts${colors.reset}`);
}

/**
 * Show welcome banner
 */
function showWelcome() {
  console.log(`${colors.blue}╔════════════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.blue}║   Number Guessing Game (Computer AI)  ║${colors.reset}`);
  console.log(`${colors.blue}╚════════════════════════════════════════╝${colors.reset}`);
  console.log();
}

/**
 * Play one round of the guessing game
 * @returns {Promise<boolean>} True if game completed successfully
 */
async function playGame() {
  showWelcome();
  console.log(MESSAGES.INTRO);
  console.log(MESSAGES.INTRO_2);
  console.log();
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    const input = answer.toLowerCase();

    if (input === 'c') {
      score += Math.max(MAX_SCORE_ATTEMPTS - attempts, MIN_POINTS);
      console.log(`${colors.green}Yay! I guessed it in ${attempts} attempts!${colors.reset}`);
      console.log(`${colors.green}Score: ${score} points${colors.reset}`);
      return true;
    } else if (input === 'h') {
      high = guess - 1;
    } else if (input === 'l') {
      low = guess + 1;
    } else {
      console.log(`${colors.red}${MESSAGES.INVALID_INPUT}${colors.reset}`);
      console.log(MESSAGES.INVALID_HELP);
      attempts--;  // Don't count invalid attempts
    }
  }

  return false;
}

/**
 * Main game loop
 */
async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question(MESSAGES.PLAY_AGAIN);
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(MESSAGES.THANKS + score);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "feat: add welcome banner"

# ==========================================
# Commit 13: Improve hints with emoji
# ==========================================
echo "Creating commit 13/18: Improve hints..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

/**
 * Number Guessing Game
 * The computer guesses a number you're thinking of using binary search
 */

const readline = require('readline');

// Game configuration
const MIN = 1;
const MAX = 100;
const MAX_SCORE_ATTEMPTS = 10;
const MIN_POINTS = 1;

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m'
};

// Message constants
const MESSAGES = {
  INTRO: 'Think of a number between 1 and 100',
  INTRO_2: "I'll try to guess it using binary search!",
  PLAY_AGAIN: '\nPlay again? (y/n): ',
  THANKS: '\nThanks for playing! Final score: ',
  INVALID_INPUT: 'Invalid input! Please enter:',
  INVALID_HELP: '  h = number is too high\n  l = number is too low\n  c = correct guess'
};

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

let attempts = 0;
let score = 0;

/**
 * Promisified readline question
 * @param {string} query - The question to ask
 * @returns {Promise<string>} User's answer
 */
function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

/**
 * Binary search algorithm to find midpoint
 * @param {number} low - Lower bound
 * @param {number} high - Upper bound
 * @returns {number} Midpoint
 */
function binarySearch(low, high) {
  // BUG: +5 breaks the algorithm
  return Math.floor((low + high) / 2) + 5;
}

/**
 * Display hint about binary search efficiency
 */
function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`${colors.yellow}💡 Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts${colors.reset}`);
}

/**
 * Show welcome banner
 */
function showWelcome() {
  console.log(`${colors.blue}╔════════════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.blue}║   Number Guessing Game (Computer AI)  ║${colors.reset}`);
  console.log(`${colors.blue}╚════════════════════════════════════════╝${colors.reset}`);
  console.log();
}

/**
 * Play one round of the guessing game
 * @returns {Promise<boolean>} True if game completed successfully
 */
async function playGame() {
  showWelcome();
  console.log(MESSAGES.INTRO);
  console.log(MESSAGES.INTRO_2);
  console.log();
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    const input = answer.toLowerCase();

    if (input === 'c') {
      score += Math.max(MAX_SCORE_ATTEMPTS - attempts, MIN_POINTS);
      console.log(`${colors.green}✅ Yay! I guessed it in ${attempts} attempts!${colors.reset}`);
      console.log(`${colors.green}Score: ${score} points${colors.reset}`);
      return true;
    } else if (input === 'h') {
      high = guess - 1;
    } else if (input === 'l') {
      low = guess + 1;
    } else {
      console.log(`${colors.red}${MESSAGES.INVALID_INPUT}${colors.reset}`);
      console.log(MESSAGES.INVALID_HELP);
      attempts--;  // Don't count invalid attempts
    }
  }

  return false;
}

/**
 * Main game loop
 */
async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question(MESSAGES.PLAY_AGAIN);
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(MESSAGES.THANKS + score);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "feat: improve hints with emoji"

# ==========================================
# Commit 14: Add attempt counter display
# ==========================================
echo "Creating commit 14/18: Add attempt counter..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

/**
 * Number Guessing Game
 * The computer guesses a number you're thinking of using binary search
 */

const readline = require('readline');

// Game configuration
const MIN = 1;
const MAX = 100;
const MAX_SCORE_ATTEMPTS = 10;
const MIN_POINTS = 1;

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m'
};

// Message constants
const MESSAGES = {
  INTRO: 'Think of a number between 1 and 100',
  INTRO_2: "I'll try to guess it using binary search!",
  PLAY_AGAIN: '\nPlay again? (y/n): ',
  THANKS: '\nThanks for playing! Final score: ',
  INVALID_INPUT: 'Invalid input! Please enter:',
  INVALID_HELP: '  h = number is too high\n  l = number is too low\n  c = correct guess'
};

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

let attempts = 0;
let score = 0;

/**
 * Promisified readline question
 * @param {string} query - The question to ask
 * @returns {Promise<string>} User's answer
 */
function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

/**
 * Binary search algorithm to find midpoint
 * @param {number} low - Lower bound
 * @param {number} high - Upper bound
 * @returns {number} Midpoint
 */
function binarySearch(low, high) {
  // BUG: +5 breaks the algorithm
  return Math.floor((low + high) / 2) + 5;
}

/**
 * Display hint about binary search efficiency
 */
function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`${colors.yellow}💡 Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts${colors.reset}`);
}

/**
 * Show welcome banner
 */
function showWelcome() {
  console.log(`${colors.blue}╔════════════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.blue}║   Number Guessing Game (Computer AI)  ║${colors.reset}`);
  console.log(`${colors.blue}╚════════════════════════════════════════╝${colors.reset}`);
  console.log();
}

/**
 * Play one round of the guessing game
 * @returns {Promise<boolean>} True if game completed successfully
 */
async function playGame() {
  showWelcome();
  console.log(MESSAGES.INTRO);
  console.log(MESSAGES.INTRO_2);
  console.log();
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  console.log(`${colors.blue}Ready? Let's begin!${colors.reset}\n`);

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    const input = answer.toLowerCase();

    if (input === 'c') {
      score += Math.max(MAX_SCORE_ATTEMPTS - attempts, MIN_POINTS);
      console.log(`${colors.green}✅ Yay! I guessed it in ${attempts} attempts!${colors.reset}`);
      console.log(`${colors.green}Score: ${score} points${colors.reset}`);
      return true;
    } else if (input === 'h') {
      high = guess - 1;
    } else if (input === 'l') {
      low = guess + 1;
    } else {
      console.log(`${colors.red}${MESSAGES.INVALID_INPUT}${colors.reset}`);
      console.log(MESSAGES.INVALID_HELP);
      attempts--;  // Don't count invalid attempts
    }
  }

  console.log('Something went wrong with my algorithm!');
  return false;
}

/**
 * Main game loop
 */
async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question(MESSAGES.PLAY_AGAIN);
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(MESSAGES.THANKS + score);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "feat: add ready message before game starts"

# ==========================================
# Commit 15: Add cyan color
# ==========================================
echo "Creating commit 15/18: Add cyan color..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

/**
 * Number Guessing Game
 * The computer guesses a number you're thinking of using binary search
 */

const readline = require('readline');

// Game configuration
const MIN = 1;
const MAX = 100;
const MAX_SCORE_ATTEMPTS = 10;
const MIN_POINTS = 1;

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  cyan: '\x1b[36m'
};

// Message constants
const MESSAGES = {
  INTRO: 'Think of a number between 1 and 100',
  INTRO_2: "I'll try to guess it using binary search!",
  PLAY_AGAIN: '\nPlay again? (y/n): ',
  THANKS: '\nThanks for playing! Final score: ',
  INVALID_INPUT: 'Invalid input! Please enter:',
  INVALID_HELP: '  h = number is too high\n  l = number is too low\n  c = correct guess'
};

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

let attempts = 0;
let score = 0;

/**
 * Promisified readline question
 * @param {string} query - The question to ask
 * @returns {Promise<string>} User's answer
 */
function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

/**
 * Binary search algorithm to find midpoint
 * @param {number} low - Lower bound
 * @param {number} high - Upper bound
 * @returns {number} Midpoint
 */
function binarySearch(low, high) {
  // BUG: +5 breaks the algorithm
  return Math.floor((low + high) / 2) + 5;
}

/**
 * Display hint about binary search efficiency
 */
function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`${colors.yellow}💡 Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts${colors.reset}`);
}

/**
 * Show welcome banner
 */
function showWelcome() {
  console.log(`${colors.cyan}╔════════════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.cyan}║   Number Guessing Game (Computer AI)  ║${colors.reset}`);
  console.log(`${colors.cyan}╚════════════════════════════════════════╝${colors.reset}`);
  console.log();
}

/**
 * Play one round of the guessing game
 * @returns {Promise<boolean>} True if game completed successfully
 */
async function playGame() {
  showWelcome();
  console.log(MESSAGES.INTRO);
  console.log(MESSAGES.INTRO_2);
  console.log();
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  console.log(`${colors.blue}Ready? Let's begin!${colors.reset}\n`);

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    const input = answer.toLowerCase();

    if (input === 'c') {
      score += Math.max(MAX_SCORE_ATTEMPTS - attempts, MIN_POINTS);
      console.log(`${colors.green}✅ Yay! I guessed it in ${attempts} attempts!${colors.reset}`);
      console.log(`${colors.green}Score: ${score} points${colors.reset}`);
      return true;
    } else if (input === 'h') {
      high = guess - 1;
    } else if (input === 'l') {
      low = guess + 1;
    } else {
      console.log(`${colors.red}${MESSAGES.INVALID_INPUT}${colors.reset}`);
      console.log(MESSAGES.INVALID_HELP);
      attempts--;  // Don't count invalid attempts
    }
  }

  console.log('Something went wrong with my algorithm!');
  return false;
}

/**
 * Main game loop
 */
async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question(MESSAGES.PLAY_AGAIN);
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(MESSAGES.THANKS + score);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "feat: improve colors with cyan for banner"

# ==========================================
# Commit 16: Add goodbye message
# ==========================================
echo "Creating commit 16/18: Add goodbye message..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

/**
 * Number Guessing Game
 * The computer guesses a number you're thinking of using binary search
 */

const readline = require('readline');

// Game configuration
const MIN = 1;
const MAX = 100;
const MAX_SCORE_ATTEMPTS = 10;
const MIN_POINTS = 1;

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  cyan: '\x1b[36m'
};

// Message constants
const MESSAGES = {
  INTRO: 'Think of a number between 1 and 100',
  INTRO_2: "I'll try to guess it using binary search!",
  PLAY_AGAIN: '\nPlay again? (y/n): ',
  THANKS: '\nThanks for playing! Final score: ',
  GOODBYE: 'Goodbye! 👋',
  INVALID_INPUT: 'Invalid input! Please enter:',
  INVALID_HELP: '  h = number is too high\n  l = number is too low\n  c = correct guess'
};

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

let attempts = 0;
let score = 0;

/**
 * Promisified readline question
 * @param {string} query - The question to ask
 * @returns {Promise<string>} User's answer
 */
function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

/**
 * Binary search algorithm to find midpoint
 * @param {number} low - Lower bound
 * @param {number} high - Upper bound
 * @returns {number} Midpoint
 */
function binarySearch(low, high) {
  // BUG: +5 breaks the algorithm
  return Math.floor((low + high) / 2) + 5;
}

/**
 * Display hint about binary search efficiency
 */
function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`${colors.yellow}💡 Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts${colors.reset}`);
}

/**
 * Show welcome banner
 */
function showWelcome() {
  console.log(`${colors.cyan}╔════════════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.cyan}║   Number Guessing Game (Computer AI)  ║${colors.reset}`);
  console.log(`${colors.cyan}╚════════════════════════════════════════╝${colors.reset}`);
  console.log();
}

/**
 * Play one round of the guessing game
 * @returns {Promise<boolean>} True if game completed successfully
 */
async function playGame() {
  showWelcome();
  console.log(MESSAGES.INTRO);
  console.log(MESSAGES.INTRO_2);
  console.log();
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  console.log(`${colors.blue}Ready? Let's begin!${colors.reset}\n`);

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    const input = answer.toLowerCase();

    if (input === 'c') {
      score += Math.max(MAX_SCORE_ATTEMPTS - attempts, MIN_POINTS);
      console.log(`${colors.green}✅ Yay! I guessed it in ${attempts} attempts!${colors.reset}`);
      console.log(`${colors.green}Score: ${score} points${colors.reset}`);
      return true;
    } else if (input === 'h') {
      high = guess - 1;
    } else if (input === 'l') {
      low = guess + 1;
    } else {
      console.log(`${colors.red}${MESSAGES.INVALID_INPUT}${colors.reset}`);
      console.log(MESSAGES.INVALID_HELP);
      attempts--;  // Don't count invalid attempts
    }
  }

  console.log('Something went wrong with my algorithm!');
  return false;
}

/**
 * Main game loop
 */
async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question(MESSAGES.PLAY_AGAIN);
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(`${colors.cyan}${MESSAGES.THANKS}${score}${colors.reset}`);
  console.log(`${colors.cyan}${MESSAGES.GOODBYE}${colors.reset}\n`);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "feat: add goodbye message"

# ==========================================
# Commit 17: Add statistics tracking
# ==========================================
echo "Creating commit 17/18: Add statistics tracking..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

/**
 * Number Guessing Game
 * The computer guesses a number you're thinking of using binary search
 */

const readline = require('readline');

// Game configuration
const MIN = 1;
const MAX = 100;
const MAX_SCORE_ATTEMPTS = 10;
const MIN_POINTS = 1;

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  cyan: '\x1b[36m'
};

// Message constants
const MESSAGES = {
  INTRO: 'Think of a number between 1 and 100',
  INTRO_2: "I'll try to guess it using binary search!",
  PLAY_AGAIN: '\nPlay again? (y/n): ',
  THANKS: '\nThanks for playing! Final score: ',
  GOODBYE: 'Goodbye! 👋',
  INVALID_INPUT: 'Invalid input! Please enter:',
  INVALID_HELP: '  h = number is too high\n  l = number is too low\n  c = correct guess'
};

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

let attempts = 0;
let score = 0;
let gamesPlayed = 0;
let totalAttempts = 0;

/**
 * Promisified readline question
 * @param {string} query - The question to ask
 * @returns {Promise<string>} User's answer
 */
function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

/**
 * Binary search algorithm to find midpoint
 * @param {number} low - Lower bound
 * @param {number} high - Upper bound
 * @returns {number} Midpoint
 */
function binarySearch(low, high) {
  // BUG: +5 breaks the algorithm
  return Math.floor((low + high) / 2) + 5;
}

/**
 * Display hint about binary search efficiency
 */
function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`${colors.yellow}💡 Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts${colors.reset}`);
}

/**
 * Show welcome banner
 */
function showWelcome() {
  console.log(`${colors.cyan}╔════════════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.cyan}║   Number Guessing Game (Computer AI)  ║${colors.reset}`);
  console.log(`${colors.cyan}╚════════════════════════════════════════╝${colors.reset}`);
  console.log();
}

/**
 * Play one round of the guessing game
 * @returns {Promise<boolean>} True if game completed successfully
 */
async function playGame() {
  showWelcome();
  console.log(MESSAGES.INTRO);
  console.log(MESSAGES.INTRO_2);
  console.log();
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  console.log(`${colors.blue}Ready? Let's begin!${colors.reset}\n`);

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `Attempt ${attempts}: Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    const input = answer.toLowerCase();

    if (input === 'c') {
      score += Math.max(MAX_SCORE_ATTEMPTS - attempts, MIN_POINTS);
      gamesPlayed++;
      totalAttempts += attempts;
      console.log(`${colors.green}✅ Yay! I guessed it in ${attempts} attempts!${colors.reset}`);
      console.log(`${colors.green}Score: ${score} points${colors.reset}`);
      return true;
    } else if (input === 'h') {
      high = guess - 1;
    } else if (input === 'l') {
      low = guess + 1;
    } else {
      console.log(`${colors.red}${MESSAGES.INVALID_INPUT}${colors.reset}`);
      console.log(MESSAGES.INVALID_HELP);
      attempts--;  // Don't count invalid attempts
    }
  }

  console.log('Something went wrong with my algorithm!');
  return false;
}

/**
 * Main game loop
 */
async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question(MESSAGES.PLAY_AGAIN);
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(`${colors.cyan}${MESSAGES.THANKS}${score}${colors.reset}`);
  if (gamesPlayed > 0) {
    const avgAttempts = (totalAttempts / gamesPlayed).toFixed(1);
    console.log(`${colors.cyan}Games played: ${gamesPlayed} | Average attempts: ${avgAttempts}${colors.reset}`);
  }
  console.log(`${colors.cyan}${MESSAGES.GOODBYE}${colors.reset}\n`);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "feat: add statistics tracking"

# ==========================================
# Commit 18: Final polish - TAG v2.0.0 here
# ==========================================
echo "Creating commit 18/18: Final polish (v2.0.0)..."

cat > number-guesser.js << 'EOF'
#!/usr/bin/env node

/**
 * Number Guessing Game
 * The computer guesses a number you're thinking of using binary search
 */

const readline = require('readline');

// Game configuration
const MIN = 1;
const MAX = 100;
const MAX_SCORE_ATTEMPTS = 10;
const MIN_POINTS = 1;

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  cyan: '\x1b[36m',
  magenta: '\x1b[35m'
};

// Message constants
const MESSAGES = {
  INTRO: 'Think of a number between 1 and 100',
  INTRO_2: "I'll try to guess it using binary search!",
  PLAY_AGAIN: '\nPlay again? (y/n): ',
  THANKS: '\n✨ Thanks for playing! Final score: ',
  GOODBYE: 'Goodbye! 👋',
  INVALID_INPUT: '⚠️  Invalid input! Please enter:',
  INVALID_HELP: '  h = number is too high\n  l = number is too low\n  c = correct guess'
};

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

let attempts = 0;
let score = 0;
let gamesPlayed = 0;
let totalAttempts = 0;

/**
 * Promisified readline question
 * @param {string} query - The question to ask
 * @returns {Promise<string>} User's answer
 */
function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

/**
 * Binary search algorithm to find midpoint
 * @param {number} low - Lower bound
 * @param {number} high - Upper bound
 * @returns {number} Midpoint
 */
function binarySearch(low, high) {
  // BUG: +5 breaks the algorithm
  return Math.floor((low + high) / 2) + 5;
}

/**
 * Display hint about binary search efficiency
 */
function showHint() {
  const totalPossible = Math.log2(MAX - MIN + 1);
  console.log(`${colors.yellow}💡 Hint: Binary search should find any number in ~${Math.ceil(totalPossible)} attempts${colors.reset}`);
}

/**
 * Show welcome banner
 */
function showWelcome() {
  console.log(`${colors.cyan}╔════════════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.cyan}║   Number Guessing Game (Computer AI)  ║${colors.reset}`);
  console.log(`${colors.cyan}╚════════════════════════════════════════╝${colors.reset}`);
  console.log();
}

/**
 * Play one round of the guessing game
 * @returns {Promise<boolean>} True if game completed successfully
 */
async function playGame() {
  showWelcome();
  console.log(MESSAGES.INTRO);
  console.log(MESSAGES.INTRO_2);
  console.log();
  showHint();
  console.log();

  let low = MIN;
  let high = MAX;
  attempts = 0;

  console.log(`${colors.blue}🎮 Ready? Let's begin!${colors.reset}\n`);

  while (low <= high) {
    attempts++;
    const guess = binarySearch(low, high);

    const answer = await question(
      `${colors.magenta}Attempt ${attempts}:${colors.reset} Is your number ${guess}? (h=too high, l=too low, c=correct): `
    );

    const input = answer.toLowerCase();

    if (input === 'c') {
      score += Math.max(MAX_SCORE_ATTEMPTS - attempts, MIN_POINTS);
      gamesPlayed++;
      totalAttempts += attempts;
      console.log(`${colors.green}✅ Yay! I guessed it in ${attempts} attempts!${colors.reset}`);
      console.log(`${colors.green}📊 Score: ${score} points${colors.reset}`);
      return true;
    } else if (input === 'h') {
      high = guess - 1;
    } else if (input === 'l') {
      low = guess + 1;
    } else {
      console.log(`${colors.red}${MESSAGES.INVALID_INPUT}${colors.reset}`);
      console.log(MESSAGES.INVALID_HELP);
      attempts--;  // Don't count invalid attempts
    }
  }

  console.log('Something went wrong with my algorithm!');
  return false;
}

/**
 * Main game loop
 */
async function main() {
  let playAgain = true;

  while (playAgain) {
    await playGame();

    const answer = await question(MESSAGES.PLAY_AGAIN);
    playAgain = answer.toLowerCase() === 'y';
  }

  console.log(`${colors.cyan}${MESSAGES.THANKS}${score}${colors.reset}`);
  if (gamesPlayed > 0) {
    const avgAttempts = (totalAttempts / gamesPlayed).toFixed(1);
    console.log(`${colors.cyan}📈 Games played: ${gamesPlayed} | Average attempts: ${avgAttempts}${colors.reset}`);
  }
  console.log(`${colors.cyan}${MESSAGES.GOODBYE}${colors.reset}\n`);
  rl.close();
}

if (require.main === module) {
  main();
}

module.exports = { binarySearch };
EOF

git add number-guesser.js
git commit -m "feat: add final polish with emojis and magenta color"

# Tag this as the current (broken) version
git tag -a v2.0.0 -m "Version 2.0.0 - Feature complete (but has a bug!)"

# ==========================================
# Final setup
# ==========================================

echo
echo "✅ Setup complete!"
echo
echo "Git repository created with:"
echo "  • 18 commits showing feature evolution"
echo "  • v1.0.0 tagged at commit 5 (working)"
echo "  • v2.0.0 tagged at commit 18 (broken)"
echo "  • Bug introduced in commit 11"
echo "  • 13 commits between tags (~4 bisect steps needed)"
echo
echo "Run the demo with: ./demo.sh"
echo "Or explore manually: git log --oneline --all"
echo
