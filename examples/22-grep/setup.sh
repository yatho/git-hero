#!/bin/bash
set -e
cd "$(dirname "$0")"

# Clean up any existing setup
rm -rf .git src tests docs
rm -f package.json .env.example

# Initialize git repository
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Create a realistic project structure
mkdir -p src/services src/utils src/controllers
mkdir -p tests/unit tests/integration
mkdir -p docs

# Main app
cat > src/app.js << 'EOF'
const express = require('express');
const userController = require('./controllers/userController');
const orderController = require('./controllers/orderController');
const { logger } = require('./utils/logger');

const app = express();

// TODO: Add rate limiting middleware
app.use(express.json());

// Routes
app.use('/api/users', userController);
app.use('/api/orders', orderController);

// FIXME: Error handling needs improvement
app.use((err, req, res, next) => {
  logger.error('Unhandled error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  logger.info(`Server running on port ${PORT}`);
});

module.exports = app;
EOF

# User controller
cat > src/controllers/userController.js << 'EOF'
const express = require('express');
const router = express.Router();
const userService = require('../services/userService');
const { validateEmail, validatePassword } = require('../utils/validators');

// TODO: Add authentication middleware
router.get('/', async (req, res) => {
  try {
    const users = await userService.getAllUsers();
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const user = await userService.getUserById(req.params.id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// HACK: Temporary workaround for email validation
router.post('/', async (req, res) => {
  const { email, password, name } = req.body;

  if (!validateEmail(email)) {
    return res.status(400).json({ error: 'Invalid email' });
  }

  if (!validatePassword(password)) {
    return res.status(400).json({ error: 'Password too weak' });
  }

  try {
    const user = await userService.createUser({ email, password, name });
    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
EOF

# Order controller
cat > src/controllers/orderController.js << 'EOF'
const express = require('express');
const router = express.Router();
const orderService = require('../services/orderService');

router.get('/', async (req, res) => {
  try {
    const orders = await orderService.getAllOrders();
    res.json(orders);
  } catch (error) {
    // TODO: Better error handling
    res.status(500).json({ error: error.message });
  }
});

router.post('/', async (req, res) => {
  try {
    const order = await orderService.createOrder(req.body);
    res.status(201).json(order);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Calculate order total
// NOTE: Prices are in cents to avoid floating point issues
function calculateTotal(items) {
  return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
}

module.exports = router;
EOF

# User service
cat > src/services/userService.js << 'EOF'
const { hashPassword } = require('../utils/crypto');

// TODO: Replace with database
const users = [];

async function getAllUsers() {
  return users.map(({ password, ...user }) => user);
}

async function getUserById(id) {
  const user = users.find(u => u.id === id);
  if (user) {
    const { password, ...safeUser } = user;
    return safeUser;
  }
  return null;
}

async function createUser({ email, password, name }) {
  const hashedPassword = await hashPassword(password);
  const user = {
    id: String(users.length + 1),
    email,
    password: hashedPassword,
    name,
    createdAt: new Date().toISOString()
  };
  users.push(user);
  const { password: _, ...safeUser } = user;
  return safeUser;
}

module.exports = { getAllUsers, getUserById, createUser };
EOF

# Order service
cat > src/services/orderService.js << 'EOF'
// TODO: Replace with database
const orders = [];

async function getAllOrders() {
  return orders;
}

async function createOrder(orderData) {
  const order = {
    id: String(orders.length + 1),
    ...orderData,
    status: 'pending',
    createdAt: new Date().toISOString()
  };
  orders.push(order);
  return order;
}

// FIXME: This doesn't handle concurrent updates
async function updateOrderStatus(id, status) {
  const order = orders.find(o => o.id === id);
  if (order) {
    order.status = status;
    return order;
  }
  return null;
}

module.exports = { getAllOrders, createOrder, updateOrderStatus };
EOF

# Logger utility
cat > src/utils/logger.js << 'EOF'
const LOG_LEVELS = {
  DEBUG: 0,
  INFO: 1,
  WARN: 2,
  ERROR: 3
};

const currentLevel = LOG_LEVELS[process.env.LOG_LEVEL] || LOG_LEVELS.INFO;

function formatMessage(level, message, ...args) {
  const timestamp = new Date().toISOString();
  return `[${timestamp}] [${level}] ${message} ${args.length ? JSON.stringify(args) : ''}`;
}

const logger = {
  debug: (message, ...args) => {
    if (currentLevel <= LOG_LEVELS.DEBUG) {
      console.log(formatMessage('DEBUG', message, ...args));
    }
  },
  info: (message, ...args) => {
    if (currentLevel <= LOG_LEVELS.INFO) {
      console.log(formatMessage('INFO', message, ...args));
    }
  },
  warn: (message, ...args) => {
    if (currentLevel <= LOG_LEVELS.WARN) {
      console.warn(formatMessage('WARN', message, ...args));
    }
  },
  error: (message, ...args) => {
    if (currentLevel <= LOG_LEVELS.ERROR) {
      console.error(formatMessage('ERROR', message, ...args));
    }
  }
};

module.exports = { logger, LOG_LEVELS };
EOF

# Validators
cat > src/utils/validators.js << 'EOF'
// Email validation regex
// TODO: Use a proper email validation library
const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// Password requirements:
// - At least 8 characters
// - At least one uppercase letter
// - At least one lowercase letter
// - At least one number
const PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;

function validateEmail(email) {
  return EMAIL_REGEX.test(email);
}

function validatePassword(password) {
  return PASSWORD_REGEX.test(password);
}

function validatePhoneNumber(phone) {
  // Matches formats: 123-456-7890, (123) 456-7890, 123.456.7890
  const PHONE_REGEX = /^[\d\s\-\.\(\)]+$/;
  return PHONE_REGEX.test(phone) && phone.replace(/\D/g, '').length >= 10;
}

module.exports = { validateEmail, validatePassword, validatePhoneNumber };
EOF

# Crypto utility
cat > src/utils/crypto.js << 'EOF'
const crypto = require('crypto');

// FIXME: Should use bcrypt in production
async function hashPassword(password) {
  return crypto.createHash('sha256').update(password).digest('hex');
}

async function comparePassword(password, hash) {
  const passwordHash = await hashPassword(password);
  return passwordHash === hash;
}

function generateToken(length = 32) {
  return crypto.randomBytes(length).toString('hex');
}

module.exports = { hashPassword, comparePassword, generateToken };
EOF

# Tests
cat > tests/unit/validators.test.js << 'EOF'
const { validateEmail, validatePassword } = require('../../src/utils/validators');

describe('Validators', () => {
  describe('validateEmail', () => {
    test('accepts valid email', () => {
      expect(validateEmail('user@example.com')).toBe(true);
    });

    test('rejects invalid email', () => {
      expect(validateEmail('invalid')).toBe(false);
    });

    // TODO: Add more edge cases
  });

  describe('validatePassword', () => {
    test('accepts strong password', () => {
      expect(validatePassword('SecurePass123')).toBe(true);
    });

    test('rejects weak password', () => {
      expect(validatePassword('weak')).toBe(false);
    });
  });
});
EOF

cat > tests/integration/api.test.js << 'EOF'
const request = require('supertest');
const app = require('../../src/app');

describe('API Endpoints', () => {
  describe('GET /api/users', () => {
    // TODO: Add authentication tests
    test('returns empty array initially', async () => {
      const response = await request(app).get('/api/users');
      expect(response.status).toBe(200);
      expect(response.body).toEqual([]);
    });
  });

  describe('POST /api/users', () => {
    test('creates user with valid data', async () => {
      const response = await request(app)
        .post('/api/users')
        .send({
          email: 'test@example.com',
          password: 'SecurePass123',
          name: 'Test User'
        });
      expect(response.status).toBe(201);
    });
  });
});
EOF

# Documentation
cat > docs/api.md << 'EOF'
# API Documentation

## Authentication

TODO: Document authentication endpoints

## Users

### GET /api/users
Returns a list of all users.

### GET /api/users/:id
Returns a specific user by ID.

### POST /api/users
Creates a new user.

**Request body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123",
  "name": "John Doe"
}
```

## Orders

### GET /api/orders
Returns all orders.

### POST /api/orders
Creates a new order.

<!-- FIXME: Document order schema -->
EOF

# Package.json
cat > package.json << 'EOF'
{
  "name": "git-grep-demo",
  "version": "1.0.0",
  "scripts": {
    "start": "node src/app.js",
    "test": "jest"
  },
  "dependencies": {
    "express": "^4.18.0"
  },
  "devDependencies": {
    "jest": "^29.0.0",
    "supertest": "^6.0.0"
  }
}
EOF

# Environment example
cat > .env.example << 'EOF'
PORT=3000
LOG_LEVEL=INFO
DATABASE_URL=postgresql://localhost:5432/myapp
# TODO: Add more config options
EOF

git add . && git commit -m "Initial project setup"

# Second commit with more code
cat > src/utils/constants.js << 'EOF'
// API Configuration
const API_VERSION = 'v1';
const API_BASE_URL = '/api';

// HTTP Status codes we commonly use
const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  INTERNAL_ERROR: 500
};

// Pagination defaults
const DEFAULT_PAGE_SIZE = 20;
const MAX_PAGE_SIZE = 100;

// DEPRECATED: Use HTTP_STATUS instead
const STATUS_CODES = HTTP_STATUS;

module.exports = {
  API_VERSION,
  API_BASE_URL,
  HTTP_STATUS,
  STATUS_CODES,
  DEFAULT_PAGE_SIZE,
  MAX_PAGE_SIZE
};
EOF

git add . && git commit -m "Add constants and configuration"

echo "✅ Setup complete! Run ./demo.sh to start the demonstration"
