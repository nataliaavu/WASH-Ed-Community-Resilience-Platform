import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wash_ed_app/config/app_config.dart';
import 'package:wash_ed_app/models/flood_status.dart';
import 'package:wash_ed_app/models/module_model.dart';
import 'package:wash_ed_app/models/squad_member.dart';
import 'package:wash_ed_app/models/user_location.dart';
import 'package:wash_ed_app/models/user_profile.dart';
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
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE learning_modules (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        title       TEXT NOT NULL,
        description TEXT NOT NULL,
        category    TEXT NOT NULL,
        target_role TEXT NOT NULL DEFAULT 'student',
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

    await db.execute('''
      CREATE TABLE users (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        name       TEXT NOT NULL,
        role       TEXT NOT NULL,
        municity   TEXT NOT NULL,
        province   TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE squad_members (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        hero_name    TEXT NOT NULL,
        phone_number TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE module_progress (
        module_id      INTEGER PRIMARY KEY,
        is_completed   INTEGER NOT NULL DEFAULT 0,
        last_page      INTEGER NOT NULL DEFAULT 0,
        last_opened_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_locations (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        label    TEXT NOT NULL,
        municity TEXT NOT NULL,
        province TEXT NOT NULL
      )
    ''');

    await _seedModules(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id         INTEGER PRIMARY KEY AUTOINCREMENT,
          name       TEXT NOT NULL,
          role       TEXT NOT NULL,
          municity   TEXT NOT NULL,
          province   TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS squad_members (
          id           INTEGER PRIMARY KEY AUTOINCREMENT,
          hero_name    TEXT NOT NULL,
          phone_number TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS module_progress (
          module_id      INTEGER PRIMARY KEY,
          is_completed   INTEGER NOT NULL DEFAULT 0,
          last_page      INTEGER NOT NULL DEFAULT 0,
          last_opened_at TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute(
        "ALTER TABLE learning_modules ADD COLUMN target_role TEXT NOT NULL DEFAULT 'student'",
      );
      // Replace old seed data with the new 12 role-split modules.
      await db.delete('learning_modules');
      await _seedModules(db);
    }
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_locations (
          id       INTEGER PRIMARY KEY AUTOINCREMENT,
          label    TEXT NOT NULL,
          municity TEXT NOT NULL,
          province TEXT NOT NULL
        )
      ''');
    }
  }

  // ── Seed ──────────────────────────────────────────────────────────────────

  Future<void> _seedModules(Database db) async {
    const modules = [
      // ── Student modules (Educator PDFs) ───────────────────────────────────
      LearningModule(
        title: 'Water Resources and Accessibility',
        description: 'Understand where water comes from and how communities access safe water sources.',
        category: 'water',
        targetRole: 'student',
        assetPath: 'assets/pdfs/student/MOD-1 - Water Resources and Accessibility - Educator (v2.0).pdf',
      ),
      LearningModule(
        title: 'Water Safety & Health',
        description: 'Learn how water quality affects health and how to keep water safe for drinking.',
        category: 'water',
        targetRole: 'student',
        assetPath: 'assets/pdfs/student/MOD-2 - Water Safety & Health - Educator (v2.0).pdf',
      ),
      LearningModule(
        title: 'Water Sustainability',
        description: 'Explore how to conserve water and protect sources for future generations.',
        category: 'water',
        targetRole: 'student',
        assetPath: 'assets/pdfs/student/MOD-3 - Water Sustainability - Educator (v2.0).pdf',
      ),
      LearningModule(
        title: 'Sanitation',
        description: 'Proper waste disposal and sanitation practices that prevent disease outbreaks.',
        category: 'sanitation',
        targetRole: 'student',
        assetPath: 'assets/pdfs/student/MOD-4 - Sanitation - Educator (v2.0).pdf',
      ),
      LearningModule(
        title: 'Hand Hygiene',
        description: 'Correct handwashing technique and hygiene practices that stop disease spread.',
        category: 'hygiene',
        targetRole: 'student',
        assetPath: 'assets/pdfs/student/MOD-5 - Hand Hygiene - Educator (v2.0).pdf',
      ),
      LearningModule(
        title: 'Disinfection & Other Hygienic Practices',
        description: 'Methods for disinfecting water and maintaining hygiene in the community.',
        category: 'hygiene',
        targetRole: 'student',
        assetPath: 'assets/pdfs/student/MOD-6 - Disinfection & Other Hygienic Practices - Educator (v2.0).pdf',
      ),
      // ── Teacher modules (Facilitator PDFs) ────────────────────────────────
      LearningModule(
        title: 'Water Resources and Accessibility',
        description: 'Facilitate discussions on water resource management and community water access.',
        category: 'water',
        targetRole: 'teacher',
        assetPath: 'assets/pdfs/teacher/MOD-1 - Water Resources and Accessibility - Facilitator (v2.0).pdf',
      ),
      LearningModule(
        title: 'Water Safety & Health',
        description: 'Guide learners through water quality, health risks, and safe water practices.',
        category: 'water',
        targetRole: 'teacher',
        assetPath: 'assets/pdfs/teacher/MOD-2 - Water Safety & Health - Facilitator (v2.0).pdf',
      ),
      LearningModule(
        title: 'Water Sustainability',
        description: 'Lead sessions on water conservation and sustainable community water use.',
        category: 'water',
        targetRole: 'teacher',
        assetPath: 'assets/pdfs/teacher/MOD-3 - Water Sustainability - Facilitator (v2.0).pdf',
      ),
      LearningModule(
        title: 'Sanitation',
        description: 'Facilitate learning on proper sanitation systems and disease prevention.',
        category: 'sanitation',
        targetRole: 'teacher',
        assetPath: 'assets/pdfs/teacher/MOD-4 - Sanitation - Facilitator (v2.0).pdf',
      ),
      LearningModule(
        title: 'Hand Hygiene',
        description: 'Lead handwashing demonstrations and hygiene education activities.',
        category: 'hygiene',
        targetRole: 'teacher',
        assetPath: 'assets/pdfs/teacher/MOD-5 - Hand Hygiene - Facilitator (v2.0).pdf',
      ),
      LearningModule(
        title: 'Disinfection & Other Hygienic Practices',
        description: 'Guide community sessions on disinfection techniques and hygienic practices.',
        category: 'hygiene',
        targetRole: 'teacher',
        assetPath: 'assets/pdfs/teacher/MOD-6 - Disinfection & Other Hygienic Practices - Facilitator (v2.0).pdf',
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

  Future<List<LearningModule>> getModulesByRole(String userRole) async {
    final db = await database;
    if (userRole == 'student') {
      final rows = await db.query(
        'learning_modules',
        where: 'target_role = ?',
        whereArgs: ['student'],
      );
      return rows.map(LearningModule.fromMap).toList();
    } else {
      // educator and parent see both student and teacher modules
      final rows = await db.query(
        'learning_modules',
        where: 'target_role IN (?, ?)',
        whereArgs: ['student', 'teacher'],
      );
      return rows.map(LearningModule.fromMap).toList();
    }
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

  // ── User profile ──────────────────────────────────────────────────────────
  // One profile per install — replaced whenever setup is re-run.

  Future<void> saveUserProfile(UserProfile profile) async {
    final db = await database;
    await db.delete('users');
    await db.insert('users', profile.toMap());
  }

  Future<UserProfile?> getUserProfile() async {
    final db = await database;
    final rows = await db.query('users', limit: 1);
    if (rows.isEmpty) return null;
    return UserProfile.fromMap(rows.first);
  }

  // ── Squad members ─────────────────────────────────────────────────────────

  Future<void> saveSquadMembers(List<SquadMember> members) async {
    final db = await database;
    await db.delete('squad_members');
    final batch = db.batch();
    for (final m in members) {
      batch.insert('squad_members', m.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<SquadMember>> getSquadMembers() async {
    final db = await database;
    final rows = await db.query('squad_members');
    return rows.map(SquadMember.fromMap).toList();
  }

  // ── Module progress ───────────────────────────────────────────────────────

  Future<void> updateModuleProgress({
    required int moduleId,
    required bool isCompleted,
    required int lastPage,
  }) async {
    final db = await database;
    await db.insert(
      'module_progress',
      {
        'module_id': moduleId,
        'is_completed': isCompleted ? 1 : 0,
        'last_page': lastPage,
        'last_opened_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<int, Map<String, dynamic>>> getAllModuleProgress() async {
    final db = await database;
    final rows = await db.query('module_progress');
    return {for (final row in rows) row['module_id'] as int: Map.of(row)};
  }

  // ── User locations ────────────────────────────────────────────────────────

  Future<List<UserLocation>> getUserLocations() async {
    final db = await database;
    final rows = await db.query('user_locations');
    return rows.map(UserLocation.fromMap).toList();
  }

  Future<int> insertUserLocation(UserLocation loc) async {
    final db = await database;
    return db.insert('user_locations', loc.toMap());
  }

  Future<void> updateUserLocation(UserLocation loc) async {
    final db = await database;
    await db.update(
      'user_locations',
      loc.toMap(),
      where: 'id = ?',
      whereArgs: [loc.id],
    );
  }

  Future<void> deleteUserLocation(int id) async {
    final db = await database;
    await db.delete('user_locations', where: 'id = ?', whereArgs: [id]);
  }
}
