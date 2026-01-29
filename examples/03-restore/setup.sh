#!/bin/bash
set -e
cd "$(dirname "$0")"

# Initialize git repository
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Create initial files
cat > config.json << 'EOF'
{
  "name": "my-app",
  "version": "1.0.0",
  "port": 3000,
  "database": {
    "host": "localhost",
    "port": 5432,
    "name": "myapp_db"
  }
}
EOF

cat > utils.js << 'EOF'
function formatDate(date) {
  return date.toISOString();
}

function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}

module.exports = { formatDate, capitalize };
EOF

cat > app.js << 'EOF'
const config = require('./config.json');
const utils = require('./utils');

console.log(`Starting ${config.name} v${config.version}`);
console.log(`Port: ${config.port}`);
EOF

git add . && git commit -m "Initial project setup"

# Create a second commit
cat > config.json << 'EOF'
{
  "name": "my-app",
  "version": "1.1.0",
  "port": 8080,
  "database": {
    "host": "localhost",
    "port": 5432,
    "name": "myapp_db"
  },
  "features": {
    "auth": true,
    "logging": true
  }
}
EOF

git add . && git commit -m "Update config: version and port"

echo "✅ Setup complete! Run ./demo.sh to start the demonstration"
