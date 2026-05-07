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
    double lat = 14.5995,
    double lng = 120.9842,
    double radiusKm = 200,
  }) async {
    if (AppConfig.useMockApi || !isOnline) {
      return _fromMockOrCache();
    }

    try {
      final statuses = await _http.searchFloodStatus(lat, lng, radiusKm);
      await _db.clearFloodCache();
      await _db.cacheFloodStatuses(statuses);
      return statuses;
    } catch (_) {
      return _fromMockOrCache();
    }
  }

  Future<List<FloodStatus>> _fromMockOrCache() async {
    final cached = await _db.getCachedFloodStatuses();
    if (cached.isNotEmpty) return cached;

    final statuses = _mock.getFloodStatuses();
    await _db.cacheFloodStatuses(statuses);
    return statuses;
  }

  Future<List<FlashFloodEvent>> getFlashFloods({
    required bool isOnline,
    double lat = 14.5995,
    double lng = 120.9842,
    double radiusKm = 200,
  }) async {
    if (AppConfig.useMockApi || !isOnline) {
      return _mock.getFlashFloods();
    }

    try {
      return await _http.searchFlashFloods(lat, lng, radiusKm);
    } catch (_) {
      return _mock.getFlashFloods();
    }
  }
}
