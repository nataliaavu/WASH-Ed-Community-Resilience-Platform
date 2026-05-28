import 'package:flutter/material.dart';
import 'package:wash_ed_app/data/app_notifiers.dart';
import 'package:wash_ed_app/data/database_helper.dart';
import 'package:wash_ed_app/models/user_profile.dart';
import 'package:wash_ed_app/repositories/firebase_user_repository.dart';

class AccountTypePage extends StatefulWidget {
  const AccountTypePage({super.key});

  @override
  State<AccountTypePage> createState() => _AccountTypePageState();
}

class _AccountTypePageState extends State<AccountTypePage> {
  final _db = DatabaseHelper();
  final _fbRepo = FirebaseUserRepository();
  UserProfile? _profile;
  String _selectedRole = 'student';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await _db.getUserProfile();
    if (mounted) {
      setState(() {
        _profile = profile;
        _selectedRole = profile?.role ?? 'student';
      });
    }
  }

  Future<void> _saveRole(String role) async {
    if (_profile == null) return;
    setState(() => _selectedRole = role);
    final updated = UserProfile(
      id: _profile!.id,
      name: _profile!.name,
      role: role,
      municity: _profile!.municity,
      province: _profile!.province,
      createdAt: _profile!.createdAt,
    );
    await _db.saveUserProfile(updated);
    await _fbRepo.saveUserProfile(updated);
    profileRoleVersion.value++;
    if (mounted) {
      setState(() => _profile = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account type set to ${_roleLabel(role)}')),
      );
    }
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'educator':
        return 'Educator';
      case 'parent':
        return 'Parent';
      default:
        return 'Student';
    }
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
                  'Account Type',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A45A0),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose how you want to use the app',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                        child: _roleCard('Student', 'student', Icons.school)),
                    const SizedBox(width: 16),
                    Expanded(
                        child:
                            _roleCard('Educator', 'educator', Icons.groups)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _roleCard(
                    'Parent', 'parent', Icons.supervisor_account,
                    fullWidth: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard(String label, String role, IconData icon,
      {bool fullWidth = false}) {
    final selected = _selectedRole == role;
    return GestureDetector(
      onTap: () => _saveRole(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE91E8C) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFFE91E8C) : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color:
                        const Color(0xFFE91E8C).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: fullWidth
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: selected
                  ? Colors.white.withValues(alpha: 0.3)
                  : const Color(0xFFE91E8C).withValues(alpha: 0.1),
              child: Icon(icon,
                  size: 24,
                  color: selected ? Colors.white : const Color(0xFFE91E8C)),
            ),
            if (fullWidth) const SizedBox(width: 16),
            if (!fullWidth) const SizedBox(height: 8),
            if (fullWidth)
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: selected ? Colors.white : const Color(0xFF1A45A0),
                ),
              )
            else
              Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color:
                          selected ? Colors.white : const Color(0xFF1A45A0),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
