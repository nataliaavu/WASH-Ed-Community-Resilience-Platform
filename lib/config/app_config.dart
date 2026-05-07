class AppConfig {
  // TenDay Weather Forecast API (PAGASA)
  static const String tenDayApiBaseUrl = 'https://api.pagasa.dost.gov.ph/tenday';
  static const String tenDayApiKey = 'REPLACE_WITH_REAL_KEY';

  // Google Flood Forecasting API
  static const String googleFloodApiBaseUrl =
      'https://floodforecasting.googleapis.com/v1';
  static const String googleFloodApiKey = 'REPLACE_WITH_REAL_KEY';

  // Flip to false when real API keys are available
  static const bool useMockApi = true;

  static const String dbName = 'washedapp.db';
  static const int dbVersion = 1;

  static const String defaultMunicity = 'Marikina City';
  static const String defaultProvince = 'Metro Manila';
}
