class UserProfile {
  final int? id;
  final String name;
  final String role;
  final String municity;
  final String province;
  final String createdAt;

  const UserProfile({
    this.id,
    required this.name,
    required this.role,
    required this.municity,
    required this.province,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'role': role,
        'municity': municity,
        'province': province,
        'created_at': createdAt,
      };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        id: map['id'] as int?,
        name: map['name'] as String,
        role: map['role'] as String,
        municity: map['municity'] as String,
        province: map['province'] as String,
        createdAt: map['created_at'] as String,
      );
}
