#!/usr/bin/env node
const fs = require('fs');
const FILE = 'todos.json';

function load() {
  if (fs.existsSync(FILE)) return JSON.parse(fs.readFileSync(FILE));
  return [];
}

function save(todos) {
  fs.writeFileSync(FILE, JSON.stringify(todos, null, 2));
}

function add(task) {
  const todos = load();
  todos.push({ id: Date.now(), task, done: false });
  save(todos);
  console.log('✅ Added:', task);
}

function list() {
  const todos = load();
  console.log('\n📝 Todo List:\n');
  todos.forEach((t, i) => console.log(`${i+1}. [${t.done ? 'x' : ' '}] ${t.task}`));
  console.log();
}

if (require.main === module) {
  const cmd = process.argv[2];
  if (cmd === 'add') add(process.argv.slice(3).join(' '));
  else list();
}
module.exports = { add, list, load, save };
