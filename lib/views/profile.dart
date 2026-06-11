import 'package:flutter/material.dart';
import 'package:wash_ed_app/config/app_theme.dart';
import 'package:wash_ed_app/data/database_helper.dart';
import 'package:wash_ed_app/models/user_profile.dart';
import 'package:wash_ed_app/views/profile/account_type_page.dart';
import 'package:wash_ed_app/views/profile/manage_locations_page.dart';
import 'package:wash_ed_app/views/profile/personal_details_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _db = DatabaseHelper();
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _db.getUserProfile();
    if (mounted) setState(() => _profile = profile);
  }

  @override
  Widget build(BuildContext context) {
    final name = _profile?.name ?? 'there';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.profileBg),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello $name!',
                  style: AppTextStyles.h1Blue,
                ),
                const Spacer(flex: 2),
                _menuButton(
                  'Personal Details',
                  Icons.person_outline,
                  () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PersonalDetailsPage()),
                    );
                    _loadProfile();
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                _menuButton(
                  'Account Type',
                  Icons.badge_outlined,
                  () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AccountTypePage()),
                    );
                    _loadProfile();
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                _menuButton(
                  'Locations',
                  Icons.location_on_outlined,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ManageLocationsPage()),
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 26,
        ),
        decoration: AppDecorations.yellowBorderCard(radius: AppRadius.md),
        child: Row(
          children: [
            Icon(icon, color: AppColors.brandBlue, size: 28),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.h3.copyWith(
                  fontSize: 18,
                  color: AppColors.brandBlue,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.brandBlue),
          ],
        ),
      ),
    );
  }
}