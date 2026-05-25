import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wash_ed_app/config/app_config.dart';
import 'package:wash_ed_app/models/weather_forecast.dart';

class HttpWeatherDataSource {
  final http.Client _client;

  HttpWeatherDataSource({http.Client? client})
      : _client = client ?? http.Client();

  Future<WeatherApiResponse> fetchForecast(
    String municity,
    String province, {
    double? lat,
    double? lon,
  }) async {
    final uri = Uri.parse('${AppConfig.proxyBaseUrl}/weather').replace(
      queryParameters: {
        'municity': municity,
        'province': province,
        'lat':      (lat ?? AppConfig.defaultLat).toString(),
        'lon':      (lon ?? AppConfig.defaultLng).toString(),
      },
    );

    final response =
        await _client.get(uri).timeout(const Duration(seconds: 12));

    if (response.statusCode != 200) {
      throw Exception('Weather proxy error: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return WeatherApiResponse.fromJson(json);
  }
}
