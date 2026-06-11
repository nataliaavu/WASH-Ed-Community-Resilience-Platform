class UserLocation {
  final int? id;
  final String label;
  final String municity;
  final String province;

  const UserLocation({
    this.id,
    required this.label,
    required this.municity,
    required this.province,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'label': label,
        'municity': municity,
        'province': province,
      };

  factory UserLocation.fromMap(Map<String, dynamic> map) => UserLocation(
        id: map['id'] as int?,
        label: map['label'] as String,
        municity: map['municity'] as String,
        province: map['province'] as String,
      );
}
