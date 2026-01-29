#!/bin/bash
set -e
cd "$(dirname "$0")"
rm -rf .git
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Main: Initial app with config and database
cat > app.js << 'E1'
#!/usr/bin/env node
const config = require('./config.js');
const db = require('./database.js');

console.log('🚀 App starting...');
console.log(`Environment: ${config.env}`);
console.log(`Database: ${db.connection}`);
console.log('✅ App ready!');
E1

cat > config.js << 'E2'
module.exports = {
  env: 'development',
  port: 3000,
  timeout: 30
};
E2

cat > database.js << 'E3'
module.exports = {
  connection: 'localhost:5432',
  poolSize: 10
};
E3

git add . && git commit -m "feat: initial app with config and database"

# Update config for staging
cat > config.js << 'STAGE'
module.exports = {
  env: 'staging',
  port: 8080,
  timeout: 30,
  debug: true
};
STAGE

git add . && git commit -m "feat: update config for staging environment"

# Feature branch: add new feature with modified config
git switch -C feature/api-integration

cat > api-client.js << 'E4'
#!/usr/bin/env node
module.exports = {
  endpoint: 'https://api.example.com',
  timeout: 5000,
  retries: 3,

  async fetch(path) {
    console.log(`📡 Fetching ${this.endpoint}${path}`);
    return { status: 'ok', data: [] };
  }
};
E4

cat > config.js << 'E5'
module.exports = {
  env: 'development',
  port: 3000,
  timeout: 60,  // Increased for API calls
  apiKey: 'sk_test_123456'
};
E5

git add . && git commit -m "feat: add API client with updated config"

# Production branch: optimized database config
git checkout main
git switch -C production/optimized-db

cat > database.js << 'E6'
module.exports = {
  connection: 'db.prod.example.com:5432',
  poolSize: 50,  // Optimized for production
  maxRetries: 5,
  ssl: true
};
E6

cat > config.js << 'E7'
module.exports = {
  env: 'production',
  port: 8080,
  timeout: 30,
  logLevel: 'error'
};
E7

git add . && git commit -m "feat: production-ready database config"

git switch main

echo "✅ Setup complete!"
echo "• main: basic app"
echo "• feature/api-integration: has api-client.js + updated config"
echo "• production/optimized-db: has production database.js"
echo "Run ./demo.sh"
