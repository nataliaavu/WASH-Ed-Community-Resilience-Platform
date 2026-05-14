import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wash_ed_app/config/app_config.dart';
import 'package:wash_ed_app/models/weather_forecast.dart';

// Calls the backend proxy — the proxy adds the real TenDay API key server-side.
class HttpWeatherDataSource {
  final http.Client _client;

  HttpWeatherDataSource({http.Client? client})
      : _client = client ?? http.Client();

  Future<TenDayApiResponse> fetchForecast(
      String municity, String province) async {
    final uri = Uri.parse('${AppConfig.proxyBaseUrl}/weather').replace(
      queryParameters: {
        'municity': municity,
        'province': province,
      },
    );

    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Proxy weather error: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return TenDayApiResponse.fromJson(json);
  }
}
