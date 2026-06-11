import 'package:flutter/material.dart';
import 'package:wash_ed_app/config/app_theme.dart';
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

  // ── Role save logic — untouched ───────────────────────────────────────────
  // Saves role to SQLite + Firebase and increments profileRoleVersion,
  // which triggers _onRoleChanged in learn_page.dart to reload modules.

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
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.profileBg),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Back button ───────────────────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios,
                      size: 16, color: AppColors.brandBlue),
                  label: Text(
                    'Back',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.brandBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // ── Title ─────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xs,
                ),
                child: Text(
                  'Account Type',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1Blue.copyWith(fontSize: 30),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Choose how you want to use the app',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(color: AppColors.textMid),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Role cards — vertical layout ──────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    _roleCard('Student', 'student', Icons.school),
                    const SizedBox(height: AppSpacing.md),
                    _roleCard('Educator', 'educator', Icons.groups),
                    const SizedBox(height: AppSpacing.md),
                    _roleCard('Parent', 'parent', Icons.supervisor_account),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard(String label, String role, IconData icon) {
    final selected = _selectedRole == role;
    return GestureDetector(
      onTap: () => _saveRole(role), // ← role save logic untouched
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            vertical: 22, horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandPink : AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? AppColors.brandPink : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.brandPink.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: selected
                  ? AppColors.white.withValues(alpha: 0.3)
                  : AppColors.brandPink.withValues(alpha: 0.1),
              child: Icon(
                icon,
                size: 24,
                color: selected ? AppColors.white : AppColors.brandPink,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppTextStyles.h3.copyWith(
                fontSize: 16,
                color: selected ? AppColors.white : AppColors.brandBlue,
              ),
            ),
            const Spacer(),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? AppColors.white : Colors.grey.shade400,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}