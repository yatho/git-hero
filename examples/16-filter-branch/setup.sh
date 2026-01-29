#!/bin/bash
set -e
cd "$(dirname "$0")"
rm -rf .git logs config.json
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Create initial logger.js
cat > logger.js << 'EOF'
#!/usr/bin/env node
const fs = require('fs');

function log(level, message) {
  const entry = `[${new Date().toISOString()}] ${level}: ${message}\n`;
  console.log(entry.trim());
  if (fs.existsSync('logs')) {
    fs.appendFileSync('logs/app.log', entry);
  }
}

function demo() {
  log('INFO', 'Application started');
  log('WARN', 'Low memory');
  log('ERROR', 'Failed to connect');
}

if (require.main === module) demo();
module.exports = { log };
EOF

git add . && git commit -m "feat: initial logger"

# Accidentally commit config with fake API key
cat > config.json << 'EOF'
{
  "apiKey": "FAKE_API_KEY_demo-not-real-12345",
  "endpoint": "https://api.example.com"
}
EOF
git add config.json && git commit -m "feat: add configuration"

# Accidentally commit large log file
mkdir -p logs
dd if=/dev/zero of=logs/debug.log bs=1024 count=1024 2>/dev/null
git add logs && git commit -m "chore: add debug logs"

# More commits
echo "// v2" >> logger.js
git add logger.js && git commit -m "feat: improve logging"

echo "✅ Setup complete! Large file and secrets in history. Run ./demo.sh"
