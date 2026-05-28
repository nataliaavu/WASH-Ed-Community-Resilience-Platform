import 'package:flutter/material.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFCE4EC), Color(0xFFF3E5F5)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello $name!',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A45A0),
                  ),
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.yellow, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.yellow.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1A45A0), size: 28),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A45A0),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF1A45A0)),
          ],
        ),
      ),
    );
  }
}
