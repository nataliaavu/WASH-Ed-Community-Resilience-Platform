import 'package:wash_ed_app/data/database_helper.dart';
import 'package:wash_ed_app/models/weather_api.dart';
import 'package:wash_ed_app/models/weather_forecast.dart';

// Model Layer — owns caching and offline fallback for weather data.
// Calls WeatherApi (API Layer) for raw data; persists results to SQLite.
class WeatherRepository {
  final DatabaseHelper _db;
  final WeatherApi _api;

  WeatherRepository({DatabaseHelper? db, WeatherApi? api})
      : _db = db ?? DatabaseHelper(),
        _api = api ?? WeatherApi();

  Future<TenDayApiResponse> getForecast({
    required String municity,
    required String province,
    required bool isOnline,
  }) async {
    if (!isOnline) {
      return _fromCacheOrApi(municity, province);
    }

    try {
      final response = await _api.fetchForecast(municity, province);
      await _db.cacheWeather(
        response.data,
        response.metadata.issuanceDate,
        response.metadata.region,
      );
      return response;
    } catch (_) {
      return _fromCacheOrApi(municity, province);
    }
  }

  Future<TenDayApiResponse> _fromCacheOrApi(
      String municity, String province) async {
    final cached = await _db.getCachedWeather(municity);
    if (cached != null) {
      final issuanceDate = await _db.getCachedIssuanceDate(municity) ?? '';
      return TenDayApiResponse(
        data: cached,
        metadata: TenDayMetadata(
          requestNo: 0,
          api: 'Forecast by Date',
          forecast: '10-day Forecast',
          issuanceDate: issuanceDate,
          region: '',
          province: province,
          municity: municity,
        ),
      );
    }

    final response = await _api.fetchForecast(municity, province);
    await _db.cacheWeather(
      response.data,
      response.metadata.issuanceDate,
      response.metadata.region,
    );
    return response;
  }
}
