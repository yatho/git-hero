#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

function loadPlugins() {
  const plugins = [];
  const pluginsDir = 'plugins';

  if (!fs.existsSync(pluginsDir)) return plugins;

  fs.readdirSync(pluginsDir).forEach(dir => {
    const pluginPath = path.join(pluginsDir, dir, 'index.js');
    if (fs.existsSync(pluginPath)) {
      plugins.push(require(path.resolve(pluginPath)));
    }
  });

  return plugins;
}

function demo() {
  console.log('Plugin System Demo\n');

  const plugins = loadPlugins();

  if (plugins.length === 0) {
    console.log('No plugins loaded.');
    console.log('Run setup.sh to add plugins as submodules.');
    return;
  }

  plugins.forEach(plugin => {
    console.log(`Plugin: ${plugin.name}`);
    if (plugin.add) console.log('  5 + 3 =', plugin.add(5, 3));
    if (plugin.reverse) console.log('  reverse("hello") =', plugin.reverse('hello'));
    console.log();
  });
}

if (require.main === module) demo();
module.exports = { loadPlugins };
