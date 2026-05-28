class SquadMember {
  final int? id;
  final String heroName;
  final String phoneNumber;

  const SquadMember({
    this.id,
    required this.heroName,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'hero_name': heroName,
        'phone_number': phoneNumber,
      };

  factory SquadMember.fromMap(Map<String, dynamic> map) => SquadMember(
        id: map['id'] as int?,
        heroName: map['hero_name'] as String,
        phoneNumber: map['phone_number'] as String,
      );
}
