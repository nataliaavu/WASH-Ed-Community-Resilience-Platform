require('dotenv').config();
const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

const PORT = process.env.PORT || 3000;

const METEOSOURCE_BASE_URL = 'https://www.meteosource.com/api/v1/startup';
const GOOGLE_FLOOD_BASE_URL = 'https://floodforecasting.googleapis.com/v1';

// ── Helpers ───────────────────────────────────────────────────────────────────

function mapCloudCover(pct) {
  if (pct < 20) return 'CLEAR';
  if (pct < 40) return 'PARTLY CLOUDY';
  if (pct < 70) return 'MOSTLY CLOUDY';
  if (pct < 90) return 'CLOUDY';
  return 'OVERCAST';
}

function mapRainfallDesc(precipTotal, precipType, summary) {
  if (precipTotal === 0 || precipType === 'none') {
    return summary?.toUpperCase() || 'NO RAIN';
  }
  if (precipTotal < 2.5)  return 'LIGHT RAINS';
  if (precipTotal < 7.5)  return 'MODERATE RAINS';
  if (precipTotal < 15)   return 'HEAVY RAINS';
  if (precipTotal < 30)   return 'VERY HEAVY RAINS';
  return 'TORRENTIAL RAINS';
}

// Transforms Meteosource response into the same shape the Flutter app expects.
function transformToFlutterFormat(meteosource, municity, province) {
  const current    = meteosource.current || {};
  const todayAll   = meteosource.daily?.data?.[0]?.all_day || {};
  const firstHrly  = meteosource.hourly?.data?.[0] || {};

  const rainfallTotal  = current.precipitation?.total ?? 0;
  const precipType     = current.precipitation?.type ?? 'none';
  const cloudCoverPct  = typeof current.cloud_cover === 'number'
    ? current.cloud_cover
    : (current.cloud_cover?.total ?? 0);

  // humidity: present in hourly on Startup tier, may be absent on free
  const humidity = firstHrly.humidity ?? current.humidity ?? 75;

  const hourly = (meteosource.hourly?.data || []).slice(0, 5).map(h => {
    const date = new Date(h.date);
    const hrs  = date.getHours();
    const ampm = hrs >= 12 ? 'PM' : 'AM';
    const disp = hrs % 12 || 12;
    const cloudPct = typeof h.cloud_cover === 'number'
      ? h.cloud_cover
      : (h.cloud_cover?.total ?? 0);
    return {
      time:               `${disp}${ampm}`,
      temperature:        h.temperature ?? 0,
      weather:            h.weather ?? 'sunny',
      precipitation_total: h.precipitation?.total ?? 0,
      precipitation_type:  h.precipitation?.type ?? 'none',
      cloud_cover:         cloudPct,
    };
  });

  return {
    metadata: {
      request_no:    0,
      api:           'Meteosource',
      forecast:      '10-day Forecast',
      issuance_date: new Date().toLocaleDateString('en-PH'),
      region:        'Philippines',
      province,
      municity,
    },
    data: {
      date:           new Date().toLocaleDateString('en-PH'),
      province,
      municity,
      rainfall_desc:  mapRainfallDesc(rainfallTotal, precipType, current.summary),
      rainfall_total: rainfallTotal,
      cloud_cover:    mapCloudCover(cloudCoverPct),
      tmean:          current.temperature ?? 0,
      tmin:           todayAll.temperature_min ?? current.temperature ?? 0,
      tmax:           todayAll.temperature_max ?? current.temperature ?? 0,
      humidity,
      wind_speed:     current.wind?.speed ?? 0,
      wind_direction: current.wind?.dir ?? 'N',
    },
    hourly,
  };
}

// ── Health check ──────────────────────────────────────────────────────────────

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ── Weather (Meteosource) ─────────────────────────────────────────────────────
// GET /weather?lat=15.03&lon=120.69&municity=San+Fernando+City&province=Pampanga

app.get('/weather', async (req, res) => {
  const { lat, lon, municity, province } = req.query;

  if (!municity || !province) {
    return res.status(400).json({ error: 'municity and province are required' });
  }

  if (!process.env.METEOSOURCE_API_KEY) {
    return res.status(503).json({ error: 'Meteosource API key not configured on server' });
  }

  try {
    // Build location params — prefer lat/lon, fall back to place name search.
    let locationParams = {};

    if (lat && lon) {
      locationParams = { lat, lon };
    } else {
      // Look up place_id from city name (costs 1 extra call).
      const placeRes = await axios.get(`${METEOSOURCE_BASE_URL}/find_places`, {
        params: { text: municity, key: process.env.METEOSOURCE_API_KEY },
        timeout: 8000,
      });
      const places = placeRes.data;
      // Prefer a Philippine result.
      const ph = places.find(p =>
        p.country?.toLowerCase().includes('philipp')
      ) || places[0];

      if (!ph) {
        return res.status(404).json({ error: `Location not found: ${municity}` });
      }
      locationParams = { place_id: ph.place_id };
    }

    const response = await axios.get(`${METEOSOURCE_BASE_URL}/point`, {
      params: {
        ...locationParams,
        sections:  'current,hourly,daily',
        timezone:  'Asia/Manila',
        language:  'en',
        units:     'metric',
        key:       process.env.METEOSOURCE_API_KEY,
      },
      timeout: 10000,
    });

    const transformed = transformToFlutterFormat(
      response.data, municity, province
    );
    res.json(transformed);
  } catch (err) {
    const status = err.response?.status || 500;
    res.status(status).json({ error: err.message });
  }
});

// ── Google Flood Forecasting API ──────────────────────────────────────────────

app.post('/flood/status', async (req, res) => {
  if (!process.env.GOOGLE_FLOOD_API_KEY) {
    return res.status(503).json({ error: 'Google Flood API key not configured on server' });
  }

  try {
    const response = await axios.post(
      `${GOOGLE_FLOOD_BASE_URL}/gauges:searchLatestFloodStatusByArea`,
      req.body,
      {
        params:  { key: process.env.GOOGLE_FLOOD_API_KEY },
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

app.post('/flood/flashfloods', async (req, res) => {
  if (!process.env.GOOGLE_FLOOD_API_KEY) {
    return res.status(503).json({ error: 'Google Flood API key not configured on server' });
  }

  try {
    const response = await axios.post(
      `${GOOGLE_FLOOD_BASE_URL}/events:searchLatestFlashFloods`,
      req.body,
      {
        params:  { key: process.env.GOOGLE_FLOOD_API_KEY },
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
  console.log(`Meteosource key set:  ${!!process.env.METEOSOURCE_API_KEY}`);
  console.log(`Google Flood key set: ${!!process.env.GOOGLE_FLOOD_API_KEY}`);
});
