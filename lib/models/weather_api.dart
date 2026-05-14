import 'package:wash_ed_app/config/app_config.dart';
import 'package:wash_ed_app/data/http_weather_data_source.dart';
import 'package:wash_ed_app/data/mock_weather_data_source.dart';
import 'package:wash_ed_app/models/weather_forecast.dart';

// API Layer — decides mock vs real HTTP based on AppConfig.useMockApi.
// WeatherRepository calls this; it never calls data sources directly.
class WeatherApi {
  final MockWeatherDataSource _mock;
  final HttpWeatherDataSource _http;

  WeatherApi({
    MockWeatherDataSource? mock,
    HttpWeatherDataSource? http,
  })  : _mock = mock ?? MockWeatherDataSource(),
        _http = http ?? HttpWeatherDataSource();

  Future<TenDayApiResponse> fetchForecast(
      String municity, String province) async {
    if (AppConfig.useMockApi) {
      return _mock.fetchForecast(municity, province);
    }
    return _http.fetchForecast(municity, province);
  }
}
