#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

function loadUtils() {
  const utilsPath = 'lib/utils/index.js';
  if (fs.existsSync(utilsPath)) {
    return require(path.resolve(utilsPath));
  }
  return null;
}

function demo() {
  console.log('Main App with Shared Utils\n');

  const utils = loadUtils();

  if (!utils) {
    console.log('Utils library not loaded.');
    console.log('Run setup.sh to add utils as subtree.');
    return;
  }

  console.log('Using shared utils:');
  if (utils.formatDate) {
    console.log('  Current time:', utils.formatDate(new Date()));
  }
  if (utils.slugify) {
    console.log('  Slugify:', utils.slugify('Hello World!'));
  }
}

if (require.main === module) demo();
module.exports = { loadUtils };
