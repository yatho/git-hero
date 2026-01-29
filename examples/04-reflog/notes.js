#!/usr/bin/env node

/**
 * Simple Note Taking App
 * Demonstrates reflog for recovering "lost" commits
 */

const fs = require('fs');
const path = require('path');

const NOTES_FILE = 'notes-data.json';

const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  cyan: '\x1b[36m',
  red: '\x1b[31m'
};

function loadNotes() {
  if (fs.existsSync(NOTES_FILE)) {
    return JSON.parse(fs.readFileSync(NOTES_FILE, 'utf8'));
  }
  return [];
}

function saveNotes(notes) {
  fs.writeFileSync(NOTES_FILE, JSON.stringify(notes, null, 2));
}

function addNote(title, content) {
  const notes = loadNotes();
  const note = {
    id: Date.now(),
    title,
    content,
    created: new Date().toISOString()
  };
  notes.push(note);
  saveNotes(notes);
  console.log(`${colors.green}✅ Note added: "${title}"${colors.reset}`);
}

function listNotes() {
  const notes = loadNotes();

  console.log(`${colors.cyan}╔════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.cyan}║          My Notes              ║${colors.reset}`);
  console.log(`${colors.cyan}╚════════════════════════════════╝${colors.reset}`);
  console.log();

  if (notes.length === 0) {
    console.log('No notes yet.');
    return;
  }

  notes.forEach((note, index) => {
    console.log(`${colors.yellow}${index + 1}. ${note.title}${colors.reset}`);
    console.log(`   ${note.content}`);
    console.log(`   ${colors.blue}Created: ${new Date(note.created).toLocaleString()}${colors.reset}`);
    console.log();
  });
}

function demo() {
  console.log(`${colors.cyan}Notes App Demo${colors.reset}`);
  console.log();

  // Demo with some sample notes
  const sampleNotes = [
    { id: 1, title: 'Meeting Notes', content: 'Discuss Q4 roadmap', created: new Date().toISOString() },
    { id: 2, title: 'Ideas', content: 'New feature: Dark mode', created: new Date().toISOString() }
  ];

  saveNotes(sampleNotes);
  listNotes();
}

if (require.main === module) {
  const args = process.argv.slice(2);
  const command = args[0];

  if (command === 'add' && args.length >= 3) {
    addNote(args[1], args.slice(2).join(' '));
  } else if (command === 'list' || !command) {
    listNotes();
  } else {
    demo();
  }
}

module.exports = { addNote, listNotes, loadNotes, saveNotes };
