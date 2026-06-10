import 'package:flutter/material.dart';
import 'package:wash_ed_app/config/app_theme.dart';
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

  // ── Data logic — untouched ────────────────────────────────────────────────
  // _load, _saveName, _showContactDialog, _deleteContact are identical to
  // the original. Only visual styling has changed.

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
    final phoneCtrl =
        TextEditingController(text: existing?.phoneNumber ?? '');

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
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: phoneCtrl,
              decoration:
                  const InputDecoration(labelText: 'Phone number'),
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
              backgroundColor: AppColors.brandPink,
              foregroundColor: AppColors.white,
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
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.profileBg),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Back button ─────────────────────────────────────────────
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

              // ── Title ───────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xs,
                ),
                child: Text(
                  'Personal Details',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1Blue.copyWith(fontSize: 30),
                ),
              ),
              const SizedBox(height: AppSpacing.lg - 4),

              // ── Scrollable content ───────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg - 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Name field ───────────────────────────────────────
                      Text(
                        'Name',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.brandBlue,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _nameCtrl,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.white,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          ElevatedButton(
                            onPressed: _saving ? null : _saveName,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brandPink,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg - 4,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                              ),
                            ),
                            child: _saving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.white),
                                  )
                                : const Text('Save'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // ── Emergency contacts ───────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Emergency Contacts',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.brandBlue,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _showContactDialog(),
                            icon: const Icon(Icons.add,
                                size: 16, color: AppColors.brandBlue),
                            label: Text(
                              'Add New',
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.brandBlue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      if (_squad.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              'No emergency contacts yet.',
                              style: AppTextStyles.body.copyWith(
                                  color: AppColors.textMid),
                            ),
                          ),
                        ),

                      // ── Squad member cards ───────────────────────────────
                      ..._squad.asMap().entries.map((entry) {
                        final i = entry.key;
                        final m = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(
                              bottom: AppSpacing.sm),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                                BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.brandPink,
                                radius: 22,
                                child: Text(
                                  m.heroName.isNotEmpty
                                      ? m.heroName[0].toUpperCase()
                                      : '?',
                                  style: AppTextStyles.h3.copyWith(
                                      color: AppColors.white),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      m.heroName,
                                      style: AppTextStyles.body.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      m.phoneNumber,
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined,
                                    color: AppColors.brandBlue, size: 20),
                                onPressed: () => _showContactDialog(
                                    existing: m, index: i),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: AppColors.errorRed, size: 20),
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