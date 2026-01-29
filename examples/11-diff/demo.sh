#!/bin/bash

# Load shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../shared/demo-utils.sh"

# ===============================
# Git Diff Demo
# ===============================

start_demo "Git Diff" "Master the art of viewing changes"

# -------------------------
announce "📝 1. Making Some Changes"

info "Let's modify our calculator with various types of changes..."
echo

# Add new method with some whitespace changes
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

  // New power function
  power(base, exponent) {
    return Math.pow(base, exponent);
  }

  // New modulo function
  modulo(a, b) {
       return a % b;
  }
}

module.exports = Calculator;
EOF

# Update package-lock.json (simulating npm install)
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
        "lodash": "^4.17.21",
        "chalk": "^4.1.2"
      }
    },
    "node_modules/lodash": {
      "version": "4.17.21",
      "resolved": "https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz",
      "integrity": "sha512-v2kDEe57lecTulaDIuNTPy3Ry4gLGJ6Z1O3vE1krgXZNrsQ+LFTGHVxVjcXPs17LhbZVGedAJv8XZ1tvj5FvSg=="
    },
    "node_modules/chalk": {
      "version": "4.1.2",
      "resolved": "https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz",
      "integrity": "sha512-oKnbhFyRIXpUuez8iBMmyEa4nbj4IOQyuhc/wy9kY7/WVPcwIO9VA668Pu8RkO7+0G76SLROeyw9CpQ061i4mA=="
    }
  },
  "dependencies": {
    "lodash": {
      "version": "4.17.21",
      "resolved": "https://registry.npmjs.org/lodash/-/lodash-4.17.21.tgz",
      "integrity": "sha512-v2kDEe57lecTulaDIuNTPy3Ry4gLGJ6Z1O3vE1krgXZNrsQ+LFTGHVxVjcXPs17LhbZVGedAJv8XZ1tvj5FvSg=="
    },
    "chalk": {
      "version": "4.1.2",
      "resolved": "https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz",
      "integrity": "sha512-oKnbhFyRIXpUuez8iBMmyEa4nbj4IOQyuhc/wy9kY7/WVPcwIO9VA668Pu8RkO7+0G76SLROeyw9CpQ061i4mA=="
    }
  }
}
EOF

success "Changes made: new methods + package-lock.json updated"
pause

# -------------------------
announce "🔍 2. Basic Diff"

info "The simplest way to see what changed:"
run "git diff"
echo
warning "Notice: Lots of noise from package-lock.json !"
pause

# -------------------------
announce "📊 3. Diff Statistics"

info "Sometimes you just want a summary:"
run "git diff --stat"
echo
success "Quick overview of changed files and lines"
pause

# -------------------------
announce "📊 4. Only one file"

info "Sometimes, only one file is necessary :"
run "git diff calculator.js"
echo
success "Much cleaner! Only shows calculator.js changes"
pause

# -------------------------
announce "🚫 5. Excluding Files from Diff"

info "Filter out package-lock.json to see real changes:"
run "git diff -- . ':(exclude)package-lock.json'"
echo
success "Much cleaner! Only shows not package-lock.json changes, actually only calculator.js"
pause

info "Alternative syntax using pathspec:"
run "git diff -- ':!package-lock.json'"
pause

info "You can exclude multiple patterns:"
echo "git diff -- . ':(exclude)*.lock' ':(exclude)*.log'"
pause

# -------------------------

announce "🙈 6. Ignoring Whitespace"

info "Let's create a more realistic scenario with whitespace changes..."
echo

# Create a version with mixed real changes AND whitespace changes
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

  // New power function
  power(base, exponent) {
    return Math.pow(base, exponent);
  }

  // New modulo function with actual logic change
  modulo(a, b) {
    if (b === 0) throw new Error('Modulo by zero');
    return a % b;
  }
}

module.exports = Calculator;
EOF

info "We now have a mix of changes:"
echo "  • Real change: modulo() now checks for zero"
echo "  • Whitespace: trailing space in subtract()"
echo "  • Whitespace: tabs instead of spaces in multiply()"
pause

info "Standard diff shows ALL differences (code + whitespace):"
run "git diff calculator.js"
echo
warning "Notice: Hard to spot the real logic change among whitespace noise!"
pause

info "Now let's focus ONLY on actual code changes..."
echo

info "Ignore ALL whitespace changes (-w or --ignore-all-space):"
run "git diff -w calculator.js"
echo
success "Much clearer! Only shows the modulo() logic change"
pause

info "Quick reference for whitespace options:"
echo "  • -w, --ignore-all-space       Ignore all whitespace when comparing"
echo "  • -b, --ignore-space-change    Ignore changes in amount of whitespace"
echo "  • --ignore-space-at-eol        Ignore whitespace at line end only"
echo "  • --ignore-blank-lines         Ignore changes in blank lines"
echo "  • --ws-error-highlight=all     Highlight problematic whitespace"
pause

info "Pro tip: Use -w when reviewing after running auto-formatters or linters!"
pause

# -------------------------
announce "📝 7. Word Diff"

info "Let's make word-level changes to really see the difference..."
echo

# Create a version with word-level changes in existing lines
cat > calculator.js << 'EOF'
class Calculator {
  add(a, b) {
    return a + b;
  }

  subtract(a, b) {
    return a - b;
  }

  multiply(x, y) {
	return x * y;
  }

  divide(numerator, denominator) {
    if (denominator === 0) {
      throw new Error('Cannot divide by zero');
    }
    return numerator / denominator;
  }

  // New power function
  power(base, exponent) {
    return Math.pow(base, exponent);
  }

  // New modulo function with actual logic change
  modulo(dividend, divisor) {
    if (divisor === 0) throw new Error('Cannot calculate modulo by zero');
    return dividend % divisor;
  }
}

module.exports = Calculator;
EOF

info "We changed parameter names and error messages (word-level changes)"
pause

info "Standard diff shows whole lines as changed:"
run "git diff calculator.js"
echo
warning "Notice: Hard to see what exactly changed in each line!"
pause

info "Word diff mode shows exactly which words changed:"
run "git diff --word-diff calculator.js"
echo
success "Much clearer! You can see [-old words-] and {+new words+}"
pause

info "Color-words mode (even prettier, inline):"
run "git diff --color-words calculator.js"
echo
success "Perfect for reviewing small text changes like variable renames!"
pause

# -------------------------
announce "🎯 8. Staged vs Unstaged Changes"

info "Let's stage some changes..."
run "git add calculator.js"
pause

info "Now we have no unstaged changes:"
run "git diff"
echo
info "But we have staged changes:"
run "git diff --staged"
pause

info "Make another change to show the difference..."
cat >> calculator.js << 'EOF'

// TODO: Add square root function
EOF

run "git status"
pause

info "Unstaged changes (working directory vs staging area):"
run "git diff calculator.js"
pause

info "Staged changes (staging area vs last commit):"
run "git diff --staged calculator.js"
pause

# -------------------------
announce "📂 9. Diff Between Commits"

info "Let's commit our staged changes first..."
run "git commit -m 'Add power and modulo functions'"
pause

info "Compare current state with HEAD:"
run "git diff HEAD calculator.js"
pause

info "You can also compare specific commits:"
echo "git diff HEAD~1 HEAD           # Last commit changes"
echo "git diff abc123 def456         # Between two commits"
echo "git diff main..feature-branch  # Between branches"
pause

# -------------------------
announce "🎨 10. Compact and Custom Formats"

info "Compact summary format:"
run "git diff --compact-summary HEAD~1 HEAD"
pause

info "Name-only (just filenames):"
run "git diff --name-only HEAD~1 HEAD"
pause

info "Name-status (with modification type):"
run "git diff --name-status HEAD~1 HEAD"
pause

# -------------------------
announce "🔧 11. Practical Diff Aliases"

info "Pro tip: Create aliases for common diff patterns"
echo
echo "Add to ~/.gitconfig:"
echo
echo "[alias]"
echo "  # Diff excluding lock files"
echo "  dif = !git diff -- . ':(exclude)package-lock.json' ':(exclude)*.lock'"
echo "  "
echo "  # Diff ignoring whitespace"
echo "  difw = diff --ignore-all-space"
echo "  "
echo "  # Word diff with color"
echo "  difword = diff --color-words"
echo "  "
echo "  # Diff with stats"
echo "  difs = diff --stat"
echo
pause

# -------------------------
announce "💡 12. Advanced: Custom Diff Filters"

info "Use .gitattributes to customize diff behavior per file type:"
echo
echo "Example .gitattributes:"
echo "  *.lock -diff              # Don't show diffs for lock files"
echo "  package-lock.json -diff   # Don't show package-lock.json diffs"
echo "  *.min.js -diff            # Don't show diffs for minified files"
echo "  *.jpg binary              # Treat as binary"
echo "  *.pdf diff=pdf            # Use custom diff driver for PDFs"
pause

# -------------------------
announce "🎓 13. Diff Best Practices"

echo "✅ Use --stat for quick overview"
echo "✅ Exclude generated files (locks, builds, node_modules)"
echo "✅ Use --ignore-all-space when reviewing after formatting"
echo "✅ Use --word-diff or --color-words for detailed review"
echo "✅ Check both 'git diff' and 'git diff --staged' before commit"
echo "✅ Create aliases for your common diff patterns"
echo "✅ Use .gitattributes to ignore noise files permanently"
pause

# End demo
end_demo \
  "git diff -- . ':(exclude)pattern' filters out unwanted files" \
  "--ignore-all-space focuses on code changes, not formatting" \
  "--word-diff and --color-words show granular changes" \
  "git diff = working vs staging, git diff --staged = staging vs HEAD" \
  "--stat gives quick overview, --name-status shows modification types" \
  "Create aliases for your most-used diff commands"
