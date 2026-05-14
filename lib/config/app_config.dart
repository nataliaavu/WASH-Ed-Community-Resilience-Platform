class AppConfig {
  // ── Proxy server ───────────────────────────────────────────────────────────
  // The Flutter app talks to this proxy — the proxy holds the real API keys.
  // Change this to your deployed proxy URL (e.g. Render, Railway) when ready.
  static const String proxyBaseUrl = 'http://10.0.2.2:3000'; // Android emulator → localhost

  // ── Real API base URLs (used by the proxy server, not the Flutter app) ─────
  // Kept here for reference only.
  static const String tenDayApiBaseUrl = 'https://api.pagasa.dost.gov.ph/tenday';
  static const String googleFloodApiBaseUrl =
      'https://floodforecasting.googleapis.com/v1';

  // ── Mock / real switch ─────────────────────────────────────────────────────
  // true  → use mock data (no server needed)
  // false → call the proxy server (which calls the real APIs)
  static const bool useMockApi = true;

  // ── Database ───────────────────────────────────────────────────────────────
  static const String dbName = 'washedapp.db';
  static const int dbVersion = 2;

  static const String defaultMunicity = 'Marikina City';
  static const String defaultProvince = 'Metro Manila';
}
