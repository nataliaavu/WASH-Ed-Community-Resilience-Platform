import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wash_ed_app/models/user_profile.dart';
import 'package:wash_ed_app/models/squad_member.dart';

class FirebaseUserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  DocumentReference get _userDoc => _db.collection('users').doc(_uid);

  Future<void> saveUserProfile(UserProfile profile) async {
    if (_uid == null) return;
    await _userDoc.set({
      'name': profile.name,
      'role': profile.role,
      'municity': profile.municity,
      'province': profile.province,
      'createdAt': profile.createdAt,
    }, SetOptions(merge: true));
  }

  Future<UserProfile?> getUserProfile() async {
    if (_uid == null) return null;
    final doc = await _userDoc.get();
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      name: data['name'] as String,
      role: data['role'] as String,
      municity: data['municity'] as String,
      province: data['province'] as String,
      createdAt: data['createdAt'] as String,
    );
  }

  Future<void> saveSquadMembers(List<SquadMember> members) async {
    if (_uid == null) return;
    final batch = _db.batch();
    final existing = await _userDoc.collection('squad_members').get();
    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }
    for (final member in members) {
      final ref = _userDoc.collection('squad_members').doc();
      batch.set(ref, {
        'heroName': member.heroName,
        'phoneNumber': member.phoneNumber,
      });
    }
    await batch.commit();
  }

  Future<List<SquadMember>> getSquadMembers() async {
    if (_uid == null) return [];
    final snapshot = await _userDoc.collection('squad_members').get();
    return snapshot.docs.map((d) {
      final data = d.data();
      return SquadMember(
        heroName: data['heroName'] as String,
        phoneNumber: data['phoneNumber'] as String,
      );
    }).toList();
  }

  Future<void> updateModuleProgress(
      String moduleId, bool isCompleted, int lastPage) async {
    if (_uid == null) return;
    await _userDoc.collection('module_progress').doc(moduleId).set({
      'isCompleted': isCompleted,
      'lastPage': lastPage,
      'lastOpenedAt': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, Map<String, dynamic>>> getModuleProgress() async {
    if (_uid == null) return {};
    final snapshot = await _userDoc.collection('module_progress').get();
    return {for (final doc in snapshot.docs) doc.id: doc.data()};
  }
}