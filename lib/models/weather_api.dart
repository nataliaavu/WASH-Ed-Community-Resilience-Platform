import 'package:wash_ed_app/data/http_weather_data_source.dart';
import 'package:wash_ed_app/models/weather_forecast.dart';

class WeatherApi {
  final HttpWeatherDataSource _http;

  WeatherApi({HttpWeatherDataSource? http})
      : _http = http ?? HttpWeatherDataSource();

  Future<WeatherApiResponse> fetchForecast(
    String municity,
    String province, {
    double? lat,
    double? lon,
  }) =>
      _http.fetchForecast(municity, province, lat: lat, lon: lon);
}
