import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wash_ed_app/config/app_config.dart';
import 'package:wash_ed_app/models/flood_status.dart';

// Calls the backend proxy — the proxy adds the real Google Flood API key server-side.
class HttpFloodDataSource {
  final http.Client _client;

  HttpFloodDataSource({http.Client? client})
      : _client = client ?? http.Client();

  Future<List<FloodStatus>> searchFloodStatus(
      double lat, double lng, double radiusKm) async {
    final uri = Uri.parse('${AppConfig.proxyBaseUrl}/flood/status');
    final body = jsonEncode({
      'location': {'latitude': lat, 'longitude': lng},
      'radius': {'value': radiusKm, 'unit': 'KILOMETERS'},
    });

    final response = await _client
        .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Proxy flood error: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['gaugeForecasts'] as List<dynamic>? ?? [];
    return items
        .map((e) => FloodStatus.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<FlashFloodEvent>> searchFlashFloods(
      double lat, double lng, double radiusKm) async {
    final uri = Uri.parse('${AppConfig.proxyBaseUrl}/flood/flashfloods');
    final body = jsonEncode({
      'location': {'latitude': lat, 'longitude': lng},
      'radius': {'value': radiusKm, 'unit': 'KILOMETERS'},
    });

    final response = await _client
        .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Proxy flash flood error: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['flashFloodEvents'] as List<dynamic>? ?? [];
    return items
        .map((e) => FlashFloodEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
