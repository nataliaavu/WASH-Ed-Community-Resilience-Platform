import 'package:wash_ed_app/data/database_helper.dart';
import 'package:wash_ed_app/models/weather_api.dart';
import 'package:wash_ed_app/models/weather_forecast.dart';

class WeatherRepository {
  final DatabaseHelper _db;
  final WeatherApi _api;

  WeatherRepository({DatabaseHelper? db, WeatherApi? api})
      : _db = db ?? DatabaseHelper(),
        _api = api ?? WeatherApi();

  Future<WeatherApiResponse> getForecast({
    required String municity,
    required String province,
    required bool isOnline,
    double? lat,
    double? lon,
  }) async {
    if (!isOnline) return _fromCache(municity, province, lat, lon);

    try {
      final response =
          await _api.fetchForecast(municity, province, lat: lat, lon: lon);
      await _db.cacheWeather(
        response.data,
        response.metadata.issuanceDate,
        response.metadata.region,
      );
      return response;
    } catch (_) {
      return _fromCache(municity, province, lat, lon);
    }
  }

  Future<WeatherApiResponse> _fromCache(
      String municity, String province, double? lat, double? lon) async {
    final cached = await _db.getCachedWeather(municity);
    if (cached != null) {
      final issuanceDate = await _db.getCachedIssuanceDate(municity) ?? '';
      return WeatherApiResponse(
        data: cached,
        metadata: WeatherMetadata(
          requestNo:    0,
          api:          'Meteosource',
          forecast:     '10-day Forecast',
          issuanceDate: issuanceDate,
          region:       '',
          province:     province,
          municity:     municity,
        ),
      );
    }
    // No cache — attempt live fetch as last resort.
    return _api.fetchForecast(municity, province, lat: lat, lon: lon);
  }
}
