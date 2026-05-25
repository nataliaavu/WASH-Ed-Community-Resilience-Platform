class AppConfig {
  // ── Proxy server ───────────────────────────────────────────────────────────
  // The Flutter app talks to this proxy — the proxy holds the real API keys.
  // Change this to your deployed proxy URL (e.g. Render, Railway) when ready.
  static const String proxyBaseUrl = 'http://10.0.2.2:3000'; // Android emulator → localhost

  // ── Database ───────────────────────────────────────────────────────────────
  static const String dbName = 'washedapp.db';
  static const int dbVersion = 3;

  static const String defaultMunicity = 'Bulacan';
  static const String defaultProvince = 'Bulacan';

  // Default coordinates for Bulacan, Bulacan.
  static const double defaultLat = 14.7937;
  static const double defaultLng = 120.8783;
  static const double defaultRadiusKm = 50.0;
}
