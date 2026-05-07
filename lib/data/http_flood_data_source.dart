import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wash_ed_app/config/app_config.dart';
import 'package:wash_ed_app/models/flood_status.dart';

class HttpFloodDataSource {
  final http.Client _client;

  HttpFloodDataSource({http.Client? client})
      : _client = client ?? http.Client();

  // google.research.floodforecasting.v1.FloodsApi
  // Method: SearchLatestFloodStatusByArea
  Future<List<FloodStatus>> searchFloodStatus(
      double lat, double lng, double radiusKm) async {
    final uri = Uri.parse(
      '${AppConfig.googleFloodApiBaseUrl}/gauges:searchLatestFloodStatusByArea'
      '?key=${AppConfig.googleFloodApiKey}',
    );
    final body = jsonEncode({
      'location': {'latitude': lat, 'longitude': lng},
      'radius': {'value': radiusKm, 'unit': 'KILOMETERS'},
    });
    final response = await _client
        .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Google Flood API error: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['gaugeForecasts'] as List<dynamic>? ?? [];
    return items
        .map((e) => FloodStatus.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Method: SearchLatestFlashFloods
  Future<List<FlashFloodEvent>> searchFlashFloods(
      double lat, double lng, double radiusKm) async {
    final uri = Uri.parse(
      '${AppConfig.googleFloodApiBaseUrl}/events:searchLatestFlashFloods'
      '?key=${AppConfig.googleFloodApiKey}',
    );
    final body = jsonEncode({
      'location': {'latitude': lat, 'longitude': lng},
      'radius': {'value': radiusKm, 'unit': 'KILOMETERS'},
    });
    final response = await _client
        .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Google Flood API error: ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final items = json['flashFloodEvents'] as List<dynamic>? ?? [];
    return items
        .map((e) => FlashFloodEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
