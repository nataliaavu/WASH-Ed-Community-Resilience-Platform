import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wash_ed_app/models/module_model.dart';

class FirebaseModulesRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<LearningModule>> getAllModules() async {
    final snapshot = await _db
        .collection('learning_modules')
        .orderBy('order')
        .get();
    return snapshot.docs.map((d) => _fromFirestore(d)).toList();
  }

  Future<List<LearningModule>> getModulesByCategory(String category) async {
    final snapshot = await _db
        .collection('learning_modules')
        .where('category', isEqualTo: category)
        .orderBy('order')
        .get();
    return snapshot.docs.map((d) => _fromFirestore(d)).toList();
  }

  LearningModule _fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LearningModule(
      title: data['title'] as String,
      description: data['description'] as String,
      category: data['category'] as String,
      targetRole: (data['target_role'] as String?) ?? 'student',
      assetPath: data['pdfStoragePath'] as String,
      isDownloaded: false,
    );
  }
}