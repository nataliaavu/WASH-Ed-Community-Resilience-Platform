import 'package:wash_ed_app/config/app_config.dart';
import 'package:wash_ed_app/data/database_helper.dart';
import 'package:wash_ed_app/data/http_flood_data_source.dart';
import 'package:wash_ed_app/data/mock_flood_data_source.dart';
import 'package:wash_ed_app/models/flood_status.dart';

class FloodRepository {
  final DatabaseHelper _db;
  final MockFloodDataSource _mock;
  final HttpFloodDataSource _http;

  FloodRepository({
    DatabaseHelper? db,
    MockFloodDataSource? mock,
    HttpFloodDataSource? http,
  })  : _db = db ?? DatabaseHelper(),
        _mock = mock ?? MockFloodDataSource(),
        _http = http ?? HttpFloodDataSource();

  Future<List<FloodStatus>> getFloodStatuses({
    required bool isOnline,
    double lat = AppConfig.defaultLat,
    double lng = AppConfig.defaultLng,
    double radiusKm = AppConfig.defaultRadiusKm,
  }) async {
    if (!AppConfig.googleFloodApiEnabled) return [];
    if (!isOnline) return _fromCacheOrMock(lat, lng, radiusKm);

    try {
      final statuses = await _http.searchFloodStatus(lat, lng, radiusKm);
      await _db.clearFloodCache();
      await _db.cacheFloodStatuses(statuses);
      return statuses;
    } catch (_) {
      return _fromCacheOrMock(lat, lng, radiusKm);
    }
  }

  Future<List<FlashFloodEvent>> getFlashFloods({
    required bool isOnline,
    double lat = AppConfig.defaultLat,
    double lng = AppConfig.defaultLng,
    double radiusKm = AppConfig.defaultRadiusKm,
  }) async {
    if (!AppConfig.googleFloodApiEnabled) return [];
    if (!isOnline) return _mock.getFlashFloods(lat, lng, radiusKm);

    try {
      return await _http.searchFlashFloods(lat, lng, radiusKm);
    } catch (_) {
      return _mock.getFlashFloods(lat, lng, radiusKm);
    }
  }

  Future<List<FloodStatus>> _fromCacheOrMock(
      double lat, double lng, double radiusKm) async {
    bool inRadius(FloodStatus s) {
      final dx = (s.longitude - lng) * 90;
      final dy = (s.latitude - lat) * 111;
      return dx * dx + dy * dy <= radiusKm * radiusKm;
    }

    final cached = await _db.getCachedFloodStatuses();
    if (cached.isNotEmpty) {
      final filtered = cached.where(inRadius).toList();
      if (filtered.isNotEmpty) return filtered;
    }

    // Cache empty — seed from mock data so the UI is never blank offline.
    final statuses = _mock.getFloodStatuses(lat, lng, radiusKm);
    await _db.cacheFloodStatuses(statuses);
    return statuses;
  }
}
