class AppConfig {
  // ── Proxy server ───────────────────────────────────────────────────────────
  // The Flutter app talks to this proxy — the proxy holds the real API keys.
  // Change this to your deployed proxy URL (e.g. Render, Railway) when ready.
  static const String proxyBaseUrl = 'https://wash-ed-community-resilience-platform.onrender.com'; // Android emulator → localhost

  // ── Database ───────────────────────────────────────────────────────────────
  static const String dbName = 'washedapp.db';
  static const int dbVersion = 4;

  static const String defaultMunicity = 'Bulacan';
  static const String defaultProvince = 'Bulacan';

  // Default coordinates for Bulacan, Bulacan.
  static const double defaultLat = 14.7937;
  static const double defaultLng = 120.8783;
  static const double defaultRadiusKm = 50.0;

  // ── Feature flags ──────────────────────────────────────────────────────────
  // Set to true once a Google Flood Forecasting API key has been obtained.
  // When enabled, the river gauge widget will appear on the home screen and
  // flood API calls will be made to the proxy server.
  static const bool googleFloodApiEnabled = false;
}
