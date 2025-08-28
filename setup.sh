#!/bin/bash
# ----------------------------
# Working Company Dashboard Setup Script for Raspberry Pi (Node 18 fetch)
# ----------------------------

# 1. Update system
sudo apt update && sudo apt upgrade -y

# 2. Install required packages
sudo apt install -y nodejs npm chromium-browser curl git

# 3. Create project directory
DASHBOARD_DIR=~/company_dashboard
mkdir -p $DASHBOARD_DIR
cd $DASHBOARD_DIR

# 4. Initialize Node.js project
npm init -y

# 5. Install only express (fetch is built-in in Node 18)
npm install express

# 6. Create server.js using built-in fetch
cat << 'EOF' > server.js
const express = require('express');
const app = express();
const PORT = 3000;

// Google Sheet CSV URL
const SHEET_CSV_URL = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTRgaWE0IopODFOjgxYYmA-Ni555OLnWtJCK1Fjl_ZXK8hdMIDzQlaAvhbLo9Fqj6bjCz8_ebUzd8Wl/pub?output=csv';

app.use(express.static('public'));

app.get('/api/schedule', async (req, res) => {
  try {
    const response = await fetch(SHEET_CSV_URL);
    const csvText = await response.text();

    const rows = csvText.split('\n').filter(Boolean);
    const headers = rows.shift().split(',');

    const schedule = rows.map(row => {
      const values = row.split(',');
      let obj = {};
      headers.forEach((h, i) => obj[h.trim()] = values[i] ? values[i].trim() : '');
      return obj;
    });

    res.json(schedule);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch schedule' });
  }
});

app.listen(PORT, () => console.log(`Server running at http://localhost:${PORT}`));
EOF

# 7. Create public folder and index.html
mkdir -p public
cat << 'EOF' > public/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Company Dashboard</title>
  <style>
    body { font-family: Arial; background: #f0f2f5; text-align:center; }
    table { width: 90%; border-collapse: collapse; margin: 20px auto; }
    th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
    .today { background: #fffa91; }
    #clock, #weather { font-size: 1.5em; margin: 10px; }
  </style>
</head>
<body>
  <div id="clock"></div>
  <div id="weather">Loading weather...</div>
  <table id="scheduleTable">
    <thead>
      <tr>
        <th>Name</th><th>Monday</th><th>Tuesday</th><th>Wednesday</th><th>Thursday</th><th>Friday</th><th>Saturday</th><th>Sunday</th>
      </tr>
    </thead>
    <tbody></tbody>
  </table>

<script>
  function updateClock() {
    const now = new Date();
    document.getElementById('clock').innerText = now.toLocaleString();
  }
  setInterval(updateClock, 1000);
  updateClock();

  // Weather (replace YOUR_OPENWEATHER_API_KEY and CITY)
  const API_KEY = 'YOUR_OPENWEATHER_API_KEY';
  const CITY = 'London';
  async function loadWeather() {
    try {
      const res = await fetch(`https://api.openweathermap.org/data/2.5/weather?q=${CITY}&appid=${API_KEY}&units=metric`);
      const data = await res.json();
      document.getElementById('weather').innerText = `${CITY}: ${data.main.temp}°C, ${data.weather[0].description}`;
    } catch(e) { document.getElementById('weather').innerText = 'Weather error'; }
  }
  loadWeather();
  setInterval(loadWeather, 10*60*1000);

  async function loadSchedule() {
    try {
      const res = await fetch('/api/schedule');
      const data = await res.json();
      const tbody = document.querySelector('#scheduleTable tbody');
      tbody.innerHTML = '';
      const todayIndex = new Date().getDay() - 1;
      data.forEach(worker => {
        const row = document.createElement('tr');
        Object.keys(worker).forEach((key, i) => {
          const td = document.createElement('td');
          td.innerText = worker[key];
          if(i === todayIndex + 1) td.classList.add('today');
          row.appendChild(td);
        });
        tbody.appendChild(row);
      });
    } catch(e) { console.error('Failed to load schedule'); }
  }
  loadSchedule();
  setInterval(loadSchedule, 5*60*1000);
</script>
</body>
</html>
EOF

# 8. Final instructions
echo "✅ Dashboard setup complete!"
echo "To run:"
echo "1. Start the server: cd $DASHBOARD_DIR && node server.js"
echo "2. Open Chromium in kiosk mode: chromium-browser --noerrdialogs --kiosk http://localhost:3000"
#!/bin/bash
# ----------------------------
# Working Company Dashboard Setup Script for Raspberry Pi (Node 18 fetch)
# ----------------------------

# 1. Update system
sudo apt update && sudo apt upgrade -y

# 2. Install required packages
sudo apt install -y nodejs npm chromium-browser curl git

# 3. Create project directory
DASHBOARD_DIR=~/company_dashboard
mkdir -p $DASHBOARD_DIR
cd $DASHBOARD_DIR

# 4. Initialize Node.js project
npm init -y

# 5. Install only express (fetch is built-in in Node 18)
npm install express

# 6. Create server.js using built-in fetch
cat << 'EOF' > server.js
const express = require('express');
const app = express();
const PORT = 3000;

// Google Sheet CSV URL
const SHEET_CSV_URL = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTRgaWE0IopODFOjgxYYmA-Ni555OLnWtJCK1Fjl_ZXK8hdMIDzQlaAvhbLo9Fqj6bjCz8_ebUzd8Wl/pub?output=csv';

app.use(express.static('public'));

app.get('/api/schedule', async (req, res) => {
  try {
    const response = await fetch(SHEET_CSV_URL);
    const csvText = await response.text();

    const rows = csvText.split('\n').filter(Boolean);
    const headers = rows.shift().split(',');

    const schedule = rows.map(row => {
      const values = row.split(',');
      let obj = {};
      headers.forEach((h, i) => obj[h.trim()] = values[i] ? values[i].trim() : '');
      return obj;
    });

    res.json(schedule);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch schedule' });
  }
});

app.listen(PORT, () => console.log(`Server running at http://localhost:${PORT}`));
EOF

# 7. Create public folder and index.html
mkdir -p public
cat << 'EOF' > public/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Company Dashboard</title>
  <style>
    body { font-family: Arial; background: #f0f2f5; text-align:center; }
    table { width: 90%; border-collapse: collapse; margin: 20px auto; }
    th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
    .today { background: #fffa91; }
    #clock, #weather { font-size: 1.5em; margin: 10px; }
  </style>
</head>
<body>
  <div id="clock"></div>
  <div id="weather">Loading weather...</div>
  <table id="scheduleTable">
    <thead>
      <tr>
        <th>Name</th><th>Monday</th><th>Tuesday</th><th>Wednesday</th><th>Thursday</th><th>Friday</th><th>Saturday</th><th>Sunday</th>
      </tr>
    </thead>
    <tbody></tbody>
  </table>

<script>
  function updateClock() {
    const now = new Date();
    document.getElementById('clock').innerText = now.toLocaleString();
  }
  setInterval(updateClock, 1000);
  updateClock();

  // Weather (replace YOUR_OPENWEATHER_API_KEY and CITY)
  const API_KEY = 'YOUR_OPENWEATHER_API_KEY';
  const CITY = 'London';
  async function loadWeather() {
    try {
      const res = await fetch(`https://api.openweathermap.org/data/2.5/weather?q=${CITY}&appid=${API_KEY}&units=metric`);
      const data = await res.json();
      document.getElementById('weather').innerText = `${CITY}: ${data.main.temp}°C, ${data.weather[0].description}`;
    } catch(e) { document.getElementById('weather').innerText = 'Weather error'; }
  }
  loadWeather();
  setInterval(loadWeather, 10*60*1000);

  async function loadSchedule() {
    try {
      const res = await fetch('/api/schedule');
      const data = await res.json();
      const tbody = document.querySelector('#scheduleTable tbody');
      tbody.innerHTML = '';
      const todayIndex = new Date().getDay() - 1;
      data.forEach(worker => {
        const row = document.createElement('tr');
        Object.keys(worker).forEach((key, i) => {
          const td = document.createElement('td');
          td.innerText = worker[key];
          if(i === todayIndex + 1) td.classList.add('today');
          row.appendChild(td);
        });
        tbody.appendChild(row);
      });
    } catch(e) { console.error('Failed to load schedule'); }
  }
  loadSchedule();
  setInterval(loadSchedule, 5*60*1000);
</script>
</body>
</html>
EOF

# 8. Final instructions
echo "✅ Dashboard setup complete!"
echo "To run:"
echo "1. Start the server: cd $DASHBOARD_DIR && node server.js"
echo "2. Open Chromium in kiosk mode: chromium-browser --noerrdialogs --kiosk http://localhost:3000"
