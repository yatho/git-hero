#!/bin/bash
set -e
cd "$(dirname "$0")"
rm -rf .git
git init
git config user.name "Demo User"
git config user.email "yann-thomas@demo.fr"

# Main: 5 cities
cat > weather.js << 'E1'
#!/usr/bin/env node
const cities = {
  paris: { temp: 18, condition: 'Cloudy' },
  london: { temp: 15, condition: 'Rainy' },  // BUG: wrong temp
  berlin: { temp: 16, condition: 'Sunny' },
  madrid: { temp: 22, condition: 'Sunny' },
  rome: { temp: 20, condition: 'Partly Cloudy' }
};
function showWeather() {
  console.log('\n🌤️  Weather\n');
  Object.entries(cities).forEach(([city, data]) => {
    console.log(`${city} ${data.temp}°C ${data.condition}`);
  });
}
if (require.main === module) showWeather();
module.exports = { cities, showWeather };
E1
git add . && git commit -m "feat: initial weather app with 5 cities"

# Feature branch: add cities + redesign + fix bug
git switch -C feature/extended-cities

cat > weather.js << 'E2'
#!/usr/bin/env node
const cities = {
  paris: { temp: 18, condition: 'Cloudy' },
  london: { temp: 15, condition: 'Rainy' },  // BUG: wrong temp
  berlin: { temp: 16, condition: 'Sunny' },
  madrid: { temp: 22, condition: 'Sunny' },
  rome: { temp: 20, condition: 'Partly Cloudy' },
  amsterdam: { temp: 14, condition: 'Windy' },
  vienna: { temp: 17, condition: 'Clear' }
};
function showWeather() {
  console.log('\n🌤️  Weather\n');
  Object.entries(cities).forEach(([city, data]) => {
    console.log(`${city} ${data.temp}°C ${data.condition}`);
  });
}
if (require.main === module) showWeather();
module.exports = { cities, showWeather };
E2
git add weather.js && git commit -m "feat: add more cities"

cat > weather.js << 'E3'
#!/usr/bin/env node
const cities = {
  paris: { temp: 18, condition: 'Cloudy' },
  london: { temp: 15, condition: 'Rainy' },  // BUG: wrong temp
  berlin: { temp: 16, condition: 'Sunny' },
  madrid: { temp: 22, condition: 'Sunny' },
  rome: { temp: 20, condition: 'Partly Cloudy' },
  amsterdam: { temp: 14, condition: 'Windy' },
  vienna: { temp: 17, condition: 'Clear' }
};
function showWeather() {
  console.log('\n╔═══════════════════════╗');
  console.log('║   Weather Report      ║');
  console.log('╚═══════════════════════╝\n');
  Object.entries(cities).forEach(([city, data]) => {
    console.log(`${city.padEnd(12)} ${data.temp}°C  ${data.condition}`);
  });
  console.log();
}
if (require.main === module) showWeather();
module.exports = { cities, showWeather };
E3
git add weather.js && git commit -m "style: redesign output format"

cat > weather.js << 'E4'
#!/usr/bin/env node
const cities = {
  paris: { temp: 18, condition: 'Cloudy' },
  london: { temp: 12, condition: 'Rainy' },  // FIXED: correct temperature
  berlin: { temp: 16, condition: 'Sunny' },
  madrid: { temp: 22, condition: 'Sunny' },
  rome: { temp: 20, condition: 'Partly Cloudy' },
  amsterdam: { temp: 14, condition: 'Windy' },
  vienna: { temp: 17, condition: 'Clear' }
};
function showWeather() {
  console.log('\n╔═══════════════════════╗');
  console.log('║   Weather Report      ║');
  console.log('╚═══════════════════════╝\n');
  Object.entries(cities).forEach(([city, data]) => {
    console.log(`${city.padEnd(12)} ${data.temp}°C  ${data.condition}`);
  });
  console.log();
}
if (require.main === module) showWeather();
module.exports = { cities, showWeather };
E4
git add weather.js && git commit -m "fix: correct London temperature"

git checkout main
echo "✅ Setup complete! Fix is in feature branch. Run ./demo.sh"
