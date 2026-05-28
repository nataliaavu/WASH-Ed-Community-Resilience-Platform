import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wash_ed_app/config/app_config.dart';
import 'package:wash_ed_app/models/flood_status.dart';
import 'package:wash_ed_app/models/module_model.dart';
import 'package:wash_ed_app/models/weather_forecast.dart';
import 'package:wash_ed_app/repositories/flood_repository.dart';
import 'package:wash_ed_app/repositories/modules_repository.dart';
import 'package:wash_ed_app/repositories/weather_repository.dart';

// Central controller: all views call only this class.
// Add new GET functions here as the app grows.
class ApiController {
  final ModulesRepository _modulesRepo;
  final WeatherRepository _weatherRepo;
  final FloodRepository _floodRepo;

  ApiController({
    ModulesRepository? modulesRepo,
    WeatherRepository? weatherRepo,
    FloodRepository? floodRepo,
  })  : _modulesRepo = modulesRepo ?? ModulesRepository(),
        _weatherRepo = weatherRepo ?? WeatherRepository(),
        _floodRepo = floodRepo ?? FloodRepository();

  // ── Connectivity ──────────────────────────────────────────────────────────

  Future<bool> isOnline() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  // ── Learning Modules (always local SQLite) ────────────────────────────────

  Future<List<LearningModule>> getModules() => _modulesRepo.getAllModules();

  Future<List<LearningModule>> getModulesByCategory(String category) =>
      _modulesRepo.getModulesByCategory(category);

  // userRole comes from UserProfile.role ('student' | 'parent' | 'educator')
  Future<List<LearningModule>> getModulesByRole(String userRole) =>
      _modulesRepo.getModulesByRole(userRole);

  // ── Weather Forecast (Meteosource) ───────────────────────────────────────

  Future<WeatherApiResponse> getForecast(
      String municity, String province, {double? lat, double? lon}) async {
    final online = await isOnline();
    return _weatherRepo.getForecast(
      municity: municity,
      province: province,
      isOnline: online,
      lat: lat,
      lon: lon,
    );
  }

  // ── Google Flood Forecasting API ──────────────────────────────────────────

  Future<List<FloodStatus>> getFloodStatuses({
    double lat = AppConfig.defaultLat,
    double lng = AppConfig.defaultLng,
    double radiusKm = AppConfig.defaultRadiusKm,
  }) async {
    final online = await isOnline();
    return _floodRepo.getFloodStatuses(
      isOnline: online,
      lat: lat,
      lng: lng,
      radiusKm: radiusKm,
    );
  }

  Future<List<FlashFloodEvent>> getFlashFloods({
    double lat = 14.5995,
    double lng = 120.9842,
    double radiusKm = 200,
  }) async {
    final online = await isOnline();
    return _floodRepo.getFlashFloods(
      isOnline: online,
      lat: lat,
      lng: lng,
      radiusKm: radiusKm,
    );
  }
}
