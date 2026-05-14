require('dotenv').config();
const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

const PORT = process.env.PORT || 3000;

const TENDAY_BASE_URL = 'https://api.pagasa.dost.gov.ph/tenday';
const GOOGLE_FLOOD_BASE_URL = 'https://floodforecasting.googleapis.com/v1';

// ── Health check ──────────────────────────────────────────────────────────────
// GET /health — lets you confirm the proxy is running
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ── TenDay Weather Forecast API ───────────────────────────────────────────────
// GET /weather?municity=Marikina+City&province=Metro+Manila
// Forwards to PAGASA TenDay API with the real API key added server-side
app.get('/weather', async (req, res) => {
  const { municity, province } = req.query;

  if (!municity || !province) {
    return res.status(400).json({ error: 'municity and province are required' });
  }

  if (!process.env.TENDAY_API_KEY) {
    return res.status(503).json({ error: 'TenDay API key not configured on server' });
  }

  try {
    const response = await axios.get(`${TENDAY_BASE_URL}/forecast`, {
      params: {
        municity,
        province,
        apikey: process.env.TENDAY_API_KEY,
      },
      timeout: 10000,
    });
    res.json(response.data);
  } catch (err) {
    const status = err.response?.status || 500;
    res.status(status).json({ error: err.message });
  }
});

// ── Google Flood Forecasting API ──────────────────────────────────────────────
// POST /flood/status
// Body: { location: { latitude, longitude }, radius: { value, unit } }
// Forwards to google.research.floodforecasting.v1 SearchLatestFloodStatusByArea
app.post('/flood/status', async (req, res) => {
  if (!process.env.GOOGLE_FLOOD_API_KEY) {
    return res.status(503).json({ error: 'Google Flood API key not configured on server' });
  }

  try {
    const response = await axios.post(
      `${GOOGLE_FLOOD_BASE_URL}/gauges:searchLatestFloodStatusByArea`,
      req.body,
      {
        params: { key: process.env.GOOGLE_FLOOD_API_KEY },
        headers: { 'Content-Type': 'application/json' },
        timeout: 10000,
      }
    );
    res.json(response.data);
  } catch (err) {
    const status = err.response?.status || 500;
    res.status(status).json({ error: err.message });
  }
});

// POST /flood/flashfloods
// Body: { location: { latitude, longitude }, radius: { value, unit } }
// Forwards to google.research.floodforecasting.v1 SearchLatestFlashFloods
app.post('/flood/flashfloods', async (req, res) => {
  if (!process.env.GOOGLE_FLOOD_API_KEY) {
    return res.status(503).json({ error: 'Google Flood API key not configured on server' });
  }

  try {
    const response = await axios.post(
      `${GOOGLE_FLOOD_BASE_URL}/events:searchLatestFlashFloods`,
      req.body,
      {
        params: { key: process.env.GOOGLE_FLOOD_API_KEY },
        headers: { 'Content-Type': 'application/json' },
        timeout: 10000,
      }
    );
    res.json(response.data);
  } catch (err) {
    const status = err.response?.status || 500;
    res.status(status).json({ error: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`WASH-Ed proxy running on port ${PORT}`);
  console.log(`TenDay key set:      ${!!process.env.TENDAY_API_KEY}`);
  console.log(`Google Flood key set: ${!!process.env.GOOGLE_FLOOD_API_KEY}`);
});
