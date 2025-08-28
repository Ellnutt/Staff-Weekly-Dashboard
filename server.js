const express = require('express');
const path = require('path');

const app = express();
const PORT = 3000;

// Google Sheet CSV URL
const SHEET_CSV_URL = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTRgaWE0IopODFOjgxYYmA-Ni555OLnWtJCK1Fjl_ZXK8hdMIDzQlaAvhbLo9Fqj6bjCz8_ebUzd8Wl/pub?output=csv';

// Serve static files from /public
app.use(express.static(path.join(__dirname, 'public')));

// API endpoint to fetch schedule
app.get('/api/schedule', async (req, res) => {
  try {
    // Use Node 18 built-in fetch
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

// Serve index.html
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Start server
app.listen(PORT, () => console.log(`Server running at http://localhost:${PORT}`));
