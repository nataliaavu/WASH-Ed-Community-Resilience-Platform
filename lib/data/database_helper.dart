import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wash_ed_app/config/app_config.dart';
import 'package:wash_ed_app/models/flood_status.dart';
import 'package:wash_ed_app/models/module_model.dart';
import 'package:wash_ed_app/models/weather_forecast.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConfig.dbName);
    return openDatabase(
      path,
      version: AppConfig.dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE learning_modules (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        title       TEXT NOT NULL,
        description TEXT NOT NULL,
        category    TEXT NOT NULL,
        asset_path  TEXT NOT NULL,
        is_downloaded INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Column names intentionally match TenDay API JSON keys for fromMap reuse.
    await db.execute('''
      CREATE TABLE weather_cache (
        id             INTEGER PRIMARY KEY AUTOINCREMENT,
        date           TEXT NOT NULL,
        province       TEXT NOT NULL,
        municity       TEXT NOT NULL,
        rainfall_desc  TEXT NOT NULL,
        rainfall_total REAL NOT NULL,
        cloud_cover    TEXT NOT NULL,
        tmean          REAL NOT NULL,
        tmin           REAL NOT NULL,
        tmax           REAL NOT NULL,
        humidity       INTEGER NOT NULL,
        wind_speed     REAL NOT NULL,
        wind_direction TEXT NOT NULL,
        issuance_date  TEXT NOT NULL,
        region         TEXT NOT NULL,
        fetched_at     TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE flood_cache (
        id               INTEGER PRIMARY KEY AUTOINCREMENT,
        gauge_id         TEXT NOT NULL,
        gauge_name       TEXT NOT NULL,
        latitude         REAL NOT NULL,
        longitude        REAL NOT NULL,
        severity         TEXT NOT NULL,
        flood_status_code TEXT NOT NULL,
        water_level      REAL NOT NULL,
        alert_level      REAL NOT NULL,
        issue_time       TEXT NOT NULL,
        river            TEXT NOT NULL,
        province         TEXT NOT NULL,
        fetched_at       TEXT NOT NULL
      )
    ''');

    await _seedModules(db);
  }

  // ── Seed ──────────────────────────────────────────────────────────────────
  // Update asset_path values to match your actual PDF filenames in assets/pdfs/

  Future<void> _seedModules(Database db) async {
    const modules = [
      LearningModule(
        title: 'Water Purification at Home',
        description:
            'Learn how to make water safe to drink using boiling, '
            'chlorination, and SODIS. Essential knowledge during flood events.',
        category: 'water',
        assetPath: 'assets/pdfs/water_purification.pdf',
      ),
      LearningModule(
        title: 'Community Sanitation Basics',
        description:
            'Proper waste disposal, latrine use, and sanitation practices '
            'that prevent disease outbreaks after flooding.',
        category: 'sanitation',
        assetPath: 'assets/pdfs/sanitation_basics.pdf',
      ),
      LearningModule(
        title: 'Handwashing and Personal Hygiene',
        description:
            'Correct handwashing technique and hygiene practices that stop '
            'the spread of cholera and leptospirosis during flood season.',
        category: 'hygiene',
        assetPath: 'assets/pdfs/hygiene_handwashing.pdf',
      ),
      LearningModule(
        title: 'Flood Safety and Evacuation',
        description:
            'PAGASA flood warning signals, 72-hour go-bag checklist, safe '
            'evacuation routes, and what to do when floodwaters enter your home.',
        category: 'flood',
        assetPath: 'assets/pdfs/flood_safety.pdf',
      ),
    ];

    for (final m in modules) {
      await db.insert('learning_modules', m.toMap());
    }
  }

  // ── Modules CRUD ──────────────────────────────────────────────────────────

  Future<List<LearningModule>> getAllModules() async {
    final db = await database;
    final rows = await db.query('learning_modules');
    return rows.map(LearningModule.fromMap).toList();
  }

  Future<List<LearningModule>> getModulesByCategory(String category) async {
    final db = await database;
    final rows = await db.query(
      'learning_modules',
      where: 'category = ?',
      whereArgs: [category],
    );
    return rows.map(LearningModule.fromMap).toList();
  }

  Future<int> insertModule(LearningModule module) async {
    final db = await database;
    return db.insert('learning_modules', module.toMap());
  }

  // ── Weather cache ─────────────────────────────────────────────────────────

  Future<void> cacheWeather(WeatherForecast forecast, String issuanceDate,
      String region) async {
    final db = await database;
    final map = forecast.toJson();
    map['issuance_date'] = issuanceDate;
    map['region'] = region;
    map['fetched_at'] = DateTime.now().toIso8601String();

    final existing = await db.query(
      'weather_cache',
      where: 'municity = ?',
      whereArgs: [forecast.municity],
    );
    if (existing.isEmpty) {
      await db.insert('weather_cache', map);
    } else {
      await db.update(
        'weather_cache',
        map,
        where: 'municity = ?',
        whereArgs: [forecast.municity],
      );
    }
  }

  Future<WeatherForecast?> getCachedWeather(String municity) async {
    final db = await database;
    final rows = await db.query(
      'weather_cache',
      where: 'municity = ?',
      whereArgs: [municity],
    );
    if (rows.isEmpty) return null;
    return WeatherForecast.fromMap(rows.first);
  }

  Future<String?> getCachedIssuanceDate(String municity) async {
    final db = await database;
    final rows = await db.query(
      'weather_cache',
      columns: ['issuance_date'],
      where: 'municity = ?',
      whereArgs: [municity],
    );
    if (rows.isEmpty) return null;
    return rows.first['issuance_date'] as String?;
  }

  // ── Flood cache ───────────────────────────────────────────────────────────

  Future<void> cacheFloodStatuses(List<FloodStatus> statuses) async {
    final db = await database;
    final batch = db.batch();
    for (final s in statuses) {
      final map = s.toMap();
      map['fetched_at'] = DateTime.now().toIso8601String();
      batch.insert(
        'flood_cache',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<FloodStatus>> getCachedFloodStatuses() async {
    final db = await database;
    final rows = await db.query('flood_cache');
    return rows.map(FloodStatus.fromMap).toList();
  }

  Future<void> clearFloodCache() async {
    final db = await database;
    await db.delete('flood_cache');
  }
}
