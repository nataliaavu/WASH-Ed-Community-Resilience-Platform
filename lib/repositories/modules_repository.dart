import 'package:wash_ed_app/data/database_helper.dart';
import 'package:wash_ed_app/models/module_model.dart';

class ModulesRepository {
  final DatabaseHelper _db;

  ModulesRepository({DatabaseHelper? db}) : _db = db ?? DatabaseHelper();

  Future<List<LearningModule>> getAllModules() => _db.getAllModules();

  Future<List<LearningModule>> getModulesByCategory(String category) =>
      _db.getModulesByCategory(category);
}
