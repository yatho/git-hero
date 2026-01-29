#!/usr/bin/env node
/**
 * API Documentation Generator
 * @param {string} name - Function name
 * @param {string} description - What it does
 */
function generateDoc(name, description) {
  return `## ${name}\n${description}\n`;
}

function demo() {
  console.log('API Documentation Generator\n');
  console.log(generateDoc('add', 'Adds two numbers'));
  console.log(generateDoc('subtract', 'Subtracts two numbers'));
}

if (require.main === module) demo();
module.exports = { generateDoc };
