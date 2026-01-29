#!/bin/bash
set -e
cd "$(dirname "$0")"

# Clean up any existing setup
rm -rf .git monorepo-demo
mkdir monorepo-demo
cd monorepo-demo

# Initialize git repository
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Create a monorepo structure
mkdir -p apps/frontend/src apps/frontend/tests
mkdir -p apps/backend/src apps/backend/tests
mkdir -p apps/mobile/src apps/mobile/tests
mkdir -p packages/ui-components/src
mkdir -p packages/shared-utils/src
mkdir -p packages/api-client/src
mkdir -p infrastructure/terraform
mkdir -p infrastructure/kubernetes
mkdir -p docs/api docs/guides

# Frontend app
cat > apps/frontend/package.json << 'EOF'
{
  "name": "@monorepo/frontend",
  "version": "1.0.0",
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build"
  }
}
EOF

cat > apps/frontend/src/App.js << 'EOF'
import React from 'react';
import { Button } from '@monorepo/ui-components';

function App() {
  return (
    <div className="App">
      <h1>Frontend App</h1>
      <Button>Click me</Button>
    </div>
  );
}

export default App;
EOF

cat > apps/frontend/src/index.js << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

ReactDOM.render(<App />, document.getElementById('root'));
EOF

# Backend app
cat > apps/backend/package.json << 'EOF'
{
  "name": "@monorepo/backend",
  "version": "1.0.0",
  "scripts": {
    "start": "node src/server.js"
  }
}
EOF

cat > apps/backend/src/server.js << 'EOF'
const express = require('express');
const { formatResponse } = require('@monorepo/shared-utils');

const app = express();

app.get('/api/health', (req, res) => {
  res.json(formatResponse({ status: 'ok' }));
});

app.listen(3000, () => {
  console.log('Backend running on port 3000');
});
EOF

# Mobile app
cat > apps/mobile/package.json << 'EOF'
{
  "name": "@monorepo/mobile",
  "version": "1.0.0"
}
EOF

cat > apps/mobile/src/App.tsx << 'EOF'
import React from 'react';
import { View, Text } from 'react-native';

export default function App() {
  return (
    <View>
      <Text>Mobile App</Text>
    </View>
  );
}
EOF

# UI Components package
cat > packages/ui-components/package.json << 'EOF'
{
  "name": "@monorepo/ui-components",
  "version": "1.0.0",
  "main": "src/index.js"
}
EOF

cat > packages/ui-components/src/index.js << 'EOF'
export { Button } from './Button';
export { Input } from './Input';
export { Card } from './Card';
EOF

cat > packages/ui-components/src/Button.js << 'EOF'
import React from 'react';

export function Button({ children, onClick }) {
  return (
    <button className="btn" onClick={onClick}>
      {children}
    </button>
  );
}
EOF

# Shared utils package
cat > packages/shared-utils/package.json << 'EOF'
{
  "name": "@monorepo/shared-utils",
  "version": "1.0.0",
  "main": "src/index.js"
}
EOF

cat > packages/shared-utils/src/index.js << 'EOF'
export function formatResponse(data) {
  return {
    success: true,
    data,
    timestamp: new Date().toISOString()
  };
}

export function slugify(text) {
  return text.toLowerCase().replace(/\s+/g, '-');
}
EOF

# API client package
cat > packages/api-client/package.json << 'EOF'
{
  "name": "@monorepo/api-client",
  "version": "1.0.0"
}
EOF

cat > packages/api-client/src/index.js << 'EOF'
export class ApiClient {
  constructor(baseUrl) {
    this.baseUrl = baseUrl;
  }

  async get(endpoint) {
    const response = await fetch(`${this.baseUrl}${endpoint}`);
    return response.json();
  }
}
EOF

# Infrastructure
cat > infrastructure/terraform/main.tf << 'EOF'
provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "frontend" {
  bucket = "monorepo-frontend"
}
EOF

cat > infrastructure/kubernetes/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: monorepo/backend:latest
        ports:
        - containerPort: 3000
EOF

# Documentation
cat > docs/api/README.md << 'EOF'
# API Documentation

## Endpoints

### GET /api/health
Returns the health status of the API.

### GET /api/users
Returns a list of users.
EOF

cat > docs/guides/getting-started.md << 'EOF'
# Getting Started

## Prerequisites
- Node.js 18+
- pnpm

## Installation
```bash
pnpm install
```

## Running locally
```bash
pnpm dev
```
EOF

# Root files
cat > package.json << 'EOF'
{
  "name": "monorepo",
  "private": true,
  "workspaces": [
    "apps/*",
    "packages/*"
  ]
}
EOF

cat > README.md << 'EOF'
# Monorepo Example

This is a sample monorepo with multiple apps and shared packages.

## Structure
- `apps/` - Application code
- `packages/` - Shared libraries
- `infrastructure/` - DevOps configurations
- `docs/` - Documentation
EOF

# Commit everything
git add .
git commit -m "Initial monorepo setup with apps and packages"

# Add more commits
cat >> packages/shared-utils/src/index.js << 'EOF'

export function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1);
}
EOF
git add . && git commit -m "Add capitalize utility"

cat >> apps/frontend/src/utils.js << 'EOF'
export function debounce(fn, delay) {
  let timeout;
  return (...args) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => fn(...args), delay);
  };
}
EOF
git add . && git commit -m "Add debounce utility to frontend"

cd ..
echo "✅ Setup complete! Run ./demo.sh to start the demonstration"
