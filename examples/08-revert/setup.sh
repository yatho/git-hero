#!/bin/bash
set -e
cd "$(dirname "$0")"

# Initialize git repository
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Create initial file
cat > server.js << 'EOF'
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Hello World!');
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF

git add . && git commit -m "Initial server setup"

# Add authentication (good feature)
cat > server.js << 'EOF'
const express = require('express');
const app = express();

// Authentication middleware
app.use((req, res, next) => {
  const token = req.headers['authorization'];
  if (token === 'valid-token') {
    next();
  } else {
    res.status(401).send('Unauthorized');
  }
});

app.get('/', (req, res) => {
  res.send('Hello World!');
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF

git add . && git commit -m "Add authentication middleware"

# Add another good feature
cat > server.js << 'EOF'
const express = require('express');
const app = express();

// Authentication middleware
app.use((req, res, next) => {
  const token = req.headers['authorization'];
  if (token === 'valid-token') {
    next();
  } else {
    res.status(401).send('Unauthorized');
  }
});

app.get('/', (req, res) => {
  res.send('Hello World!');
});

// Logging middleware
app.use((req, res, next) => {
  console.log(`${req.method} ${req.path}`);
  next();
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF

git add . && git commit -m "Add logging middleware"

# Add buggy feature (this will be reverted)
cat > server.js << 'EOF'
const express = require('express');
const app = express();

// Authentication middleware
app.use((req, res, next) => {
  const token = req.headers['authorization'];
  if (token === 'valid-token') {
    next();
  } else {
    res.status(401).send('Unauthorized');
  }
});

app.get('/', (req, res) => {
  res.send('Hello World!');
});

// BUGGY: This crashes the server!
app.get('/data', (req, res) => {
  const data = undefined;
  res.send(data.map(x => x * 2)); // TypeError: Cannot read property 'map' of undefined
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF

git add . && git commit -m "Add data endpoint"

echo "✅ Setup complete! Run ./demo.sh to start the demonstration"
