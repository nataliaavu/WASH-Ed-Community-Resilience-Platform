import 'package:flutter/material.dart';
import 'package:wash_ed_app/data/app_notifiers.dart';
import 'package:wash_ed_app/data/database_helper.dart';
import 'package:wash_ed_app/models/squad_member.dart';
import 'package:wash_ed_app/models/user_profile.dart';
import 'package:wash_ed_app/repositories/firebase_user_repository.dart';

class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  final _db = DatabaseHelper();
  final _fbRepo = FirebaseUserRepository();
  UserProfile? _profile;
  List<SquadMember> _squad = [];
  late TextEditingController _nameCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final profile = await _db.getUserProfile();
    final squad = await _db.getSquadMembers();
    if (mounted) {
      setState(() {
        _profile = profile;
        _squad = squad;
        _nameCtrl.text = profile?.name ?? '';
      });
    }
  }

  Future<void> _saveName() async {
    if (_profile == null || _nameCtrl.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final updated = UserProfile(
      id: _profile!.id,
      name: _nameCtrl.text.trim(),
      role: _profile!.role,
      municity: _profile!.municity,
      province: _profile!.province,
      createdAt: _profile!.createdAt,
    );
    await _db.saveUserProfile(updated);
    await _fbRepo.saveUserProfile(updated);
    profileNameVersion.value++;
    if (mounted) {
      setState(() {
        _profile = updated;
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name saved!')),
      );
    }
  }

  void _showContactDialog({SquadMember? existing, int? index}) {
    final heroCtrl = TextEditingController(text: existing?.heroName ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phoneNumber ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Add Contact' : 'Edit Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: heroCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Phone number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E8C),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (heroCtrl.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              final updated = List<SquadMember>.from(_squad);
              final member = SquadMember(
                heroName: heroCtrl.text.trim(),
                phoneNumber: phoneCtrl.text.trim(),
              );
              if (index != null) {
                updated[index] = member;
              } else {
                updated.add(member);
              }
              await _db.saveSquadMembers(updated);
              await _fbRepo.saveSquadMembers(updated);
              if (mounted) setState(() => _squad = updated);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteContact(int index) async {
    final updated = List<SquadMember>.from(_squad)..removeAt(index);
    await _db.saveSquadMembers(updated);
    await _fbRepo.saveSquadMembers(updated);
    if (mounted) setState(() => _squad = updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFCE4EC), Color(0xFFF3E5F5)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios,
                      size: 16, color: Color(0xFF1A45A0)),
                  label: const Text('Back',
                      style: TextStyle(
                          color: Color(0xFF1A45A0),
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Text(
                  'Personal Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A45A0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF1A45A0)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _saving ? null : _saveName,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E8C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Emergency Contacts',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF1A45A0)),
                ),
                TextButton.icon(
                  onPressed: () => _showContactDialog(),
                  icon: const Icon(Icons.add, size: 16,
                      color: Color(0xFF1A45A0)),
                  label: const Text('Add New',
                      style: TextStyle(
                          color: Color(0xFF1A45A0), fontSize: 13)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_squad.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text('No emergency contacts yet.',
                      style: TextStyle(color: Colors.grey)),
                ),
              ),
            ..._squad.asMap().entries.map((entry) {
              final i = entry.key;
              final m = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFE91E8C),
                      radius: 22,
                      child: Text(
                        m.heroName.isNotEmpty
                            ? m.heroName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.heroName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(m.phoneNumber,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: Color(0xFF1A45A0), size: 20),
                      onPressed: () =>
                          _showContactDialog(existing: m, index: i),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.red, size: 20),
                      onPressed: () => _deleteContact(i),
                    ),
                  ],
                ),
              );
            }),
                  ],
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
