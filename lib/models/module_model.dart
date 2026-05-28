class LearningModule {
  final int? id;
  final String title;
  final String description;
  final String category; // water | sanitation | hygiene | flood
  final String targetRole; // student | teacher
  final String assetPath; // e.g. assets/pdfs/student/module.pdf
  final bool isDownloaded;

  const LearningModule({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.targetRole,
    required this.assetPath,
    this.isDownloaded = true,
  });

  factory LearningModule.fromMap(Map<String, dynamic> map) {
    return LearningModule(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      targetRole: map['target_role'] as String,
      assetPath: map['asset_path'] as String,
      isDownloaded: (map['is_downloaded'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'description': description,
    'category': category,
    'target_role': targetRole,
    'asset_path': assetPath,
    'is_downloaded': isDownloaded ? 1 : 0,
  };
}