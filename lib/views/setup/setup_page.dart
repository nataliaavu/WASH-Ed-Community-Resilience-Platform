import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_ed_app/config/app_theme.dart';
import 'package:wash_ed_app/data/app_notifiers.dart';
import 'package:wash_ed_app/data/database_helper.dart';
import 'package:wash_ed_app/models/squad_member.dart';
import 'package:wash_ed_app/models/user_location.dart';
import 'package:wash_ed_app/models/user_profile.dart';
import 'package:wash_ed_app/repositories/firebase_user_repository.dart';
import 'package:wash_ed_app/views/setup/setup_location_page.dart';
import 'package:wash_ed_app/views/setup/setup_name_page.dart';
import 'package:wash_ed_app/views/setup/setup_role_page.dart';
import 'package:wash_ed_app/views/setup/setup_squad_page.dart';
import 'package:wash_ed_app/config/name_validator.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => SetupPageState();
}

class SetupPageState extends State<SetupPage> {
  late PageController _pageViewController;
  int _currentPageIndex = 0;
  bool _saving = false;

  String _selectedRole = 'student';
  final TextEditingController _nameCtrl = TextEditingController();
  String _selectedMunicity = '';
  String _selectedProvince = '';
  List<SquadMember> _squadMembers = [];

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // Gradient fills the entire scaffold edge to edge
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppGradients.profileBg),
        child: SafeArea(
          child: Column(
            children: [
              // ── Page content ──────────────────────────────────────────
              Expanded(
                child: PageView(
                  controller: _pageViewController,
                  onPageChanged: (i) => setState(() => _currentPageIndex = i),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SetupRolePage(
                      selectedRole: _selectedRole,
                      onRoleSelected: (r) =>
                          setState(() => _selectedRole = r),
                    ),
                    SetupNamePage(controller: _nameCtrl),
                    SetupLocationPage(
                      selectedMunicity: _selectedMunicity.isEmpty
                          ? null
                          : _selectedMunicity,
                      onLocationSelected: (municity, province) =>
                          setState(() {
                        _selectedMunicity = municity;
                        _selectedProvince = province;
                      }),
                    ),
                    SetupSquadPage(
                      members: _squadMembers,
                      onMembersChanged: (m) =>
                          setState(() => _squadMembers = m),
                    ),
                  ],
                ),
              ),

              // ── Navigation buttons — fixed, never moves ───────────────
              _NavigationButtons(
                currentPageIndex: _currentPageIndex,
                saving: _saving,
                onUpdateCurrentPageIndex: _updateCurrentPageIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateCurrentPageIndex(int index) async {
    if (index == 4) {
      await _saveAndFinish();
      return;
    }
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _saveAndFinish() async {
    final name = _nameCtrl.text.trim();

    // Validate name using shared NameValidator
    final nameError = NameValidator.validate(name);
    if (nameError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(nameError)),
      );
      return;
    }

    if (_selectedMunicity.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your location.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final db = DatabaseHelper();
      final fb = FirebaseUserRepository();
      final profile = UserProfile(
        name: name,
        role: _selectedRole,
        municity: _selectedMunicity,
        province: _selectedProvince,
        createdAt: DateTime.now().toIso8601String(),
      );
      await db.saveUserProfile(profile);
      await fb.saveUserProfile(profile);
      profileNameVersion.value++;
      final existingLocs = await db.getUserLocations();
      final alreadySeeded =
          existingLocs.any((l) => l.municity == _selectedMunicity);
      if (!alreadySeeded) {
        await db.insertUserLocation(UserLocation(
          label: 'Home',
          municity: _selectedMunicity,
          province: _selectedProvince,
        ));
      }
      final validMembers =
          _squadMembers.where((m) => m.heroName.isNotEmpty).toList();
      if (validMembers.isNotEmpty) {
        await db.saveSquadMembers(validMembers);
        await fb.saveSquadMembers(validMembers);
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('userSetupFinished', true);
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Something went wrong. Please try again.')),
        );
      }
    }
  }
}

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons({
    required this.currentPageIndex,
    required this.saving,
    required this.onUpdateCurrentPageIndex,
  });

  final int currentPageIndex;
  final bool saving;
  final Future<void> Function(int) onUpdateCurrentPageIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Row(
        children: [
          if (currentPageIndex > 0)
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: AppColors.textDark,
                padding: const EdgeInsets.symmetric(
                    horizontal: 36, vertical: 14),
                textStyle: AppTextStyles.button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () =>
                  onUpdateCurrentPageIndex(currentPageIndex - 1),
              child: const Text('Back'),
            ),
          const Spacer(),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.brandPink,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                  horizontal: 36, vertical: 14),
              textStyle: AppTextStyles.button,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: saving
                ? null
                : () => onUpdateCurrentPageIndex(currentPageIndex + 1),
            child: saving && currentPageIndex == 3
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.white),
                  )
                : Text(currentPageIndex == 3 ? 'Finish' : 'Next'),
          ),
        ],
      ),
    );
  }
}