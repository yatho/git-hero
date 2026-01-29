#!/bin/bash
set -e
cd "$(dirname "$0")"

# Initialize git repository
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Create initial file
cat > app.js << 'EOF'
class Application {
  constructor() {
    this.version = '1.0.0';
  }

  start() {
    console.log('App starting...');
  }
}

module.exports = Application;
EOF

git add . && git commit -m "Initial commit: basic app"

# Add feature 1
cat > app.js << 'EOF'
class Application {
  constructor() {
    this.version = '1.0.0';
    this.config = {};
  }

  start() {
    console.log('App starting...');
    this.loadConfig();
  }

  loadConfig() {
    console.log('Loading configuration...');
  }
}

module.exports = Application;
EOF

git add . && git commit -m "Add config loading"

# Add feature 2
cat > app.js << 'EOF'
class Application {
  constructor() {
    this.version = '1.0.0';
    this.config = {};
    this.database = null;
  }

  start() {
    console.log('App starting...');
    this.loadConfig();
    this.connectDatabase();
  }

  loadConfig() {
    console.log('Loading configuration...');
  }

  connectDatabase() {
    console.log('Connecting to database...');
  }
}

module.exports = Application;
EOF

git add . && git commit -m "Add database connection"

# Add feature 3
cat > app.js << 'EOF'
class Application {
  constructor() {
    this.version = '1.0.0';
    this.config = {};
    this.database = null;
    this.logger = console;
  }

  start() {
    this.logger.log('App starting...');
    this.loadConfig();
    this.connectDatabase();
  }

  loadConfig() {
    this.logger.log('Loading configuration...');
  }

  connectDatabase() {
    this.logger.log('Connecting to database...');
  }

  stop() {
    this.logger.log('App stopping...');
  }
}

module.exports = Application;
EOF

git add . && git commit -m "Add logger and stop method"

echo "✅ Setup complete! Run ./demo.sh to start the demonstration"
