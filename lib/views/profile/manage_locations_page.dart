import 'package:flutter/material.dart';
import 'package:wash_ed_app/config/app_theme.dart';
import 'package:wash_ed_app/data/app_notifiers.dart';
import 'package:wash_ed_app/data/database_helper.dart';
import 'package:wash_ed_app/data/philippine_locations.dart';
import 'package:wash_ed_app/models/user_location.dart';
import 'package:wash_ed_app/models/user_profile.dart';
import 'package:wash_ed_app/repositories/firebase_user_repository.dart';

class ManageLocationsPage extends StatefulWidget {
  const ManageLocationsPage({super.key});

  @override
  State<ManageLocationsPage> createState() => _ManageLocationsPageState();
}

class _ManageLocationsPageState extends State<ManageLocationsPage> {
  final _db = DatabaseHelper();
  final _fbRepo = FirebaseUserRepository();
  List<UserLocation> _locations = [];
  String _homeMunicity = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      _db.getUserLocations(),
      _db.getUserProfile(),
    ]);
    final locs = results[0] as List<UserLocation>;
    final profile = results[1] as UserProfile?;
    if (mounted) {
      setState(() {
        _locations = locs;
        _homeMunicity = profile?.municity ?? '';
      });
    }
  }

  // ── Set as home — untouched ───────────────────────────────────────────────
  // Updates the user profile municity and increments homeLocationVersion,
  // which triggers _loadData in home_page.dart to reload weather/flood data.

  Future<void> _setAsHome(UserLocation loc) async {
    final profile = await _db.getUserProfile();
    if (profile == null) return;
    final updated = UserProfile(
      id: profile.id,
      name: profile.name,
      role: profile.role,
      municity: loc.municity,
      province: loc.province,
      createdAt: profile.createdAt,
    );
    await _db.saveUserProfile(updated);
    await _fbRepo.saveUserProfile(updated);
    homeLocationVersion.value++;
    if (mounted) setState(() => _homeMunicity = loc.municity);
  }

  void _showLocationDialog({UserLocation? existing}) {
    final labelCtrl = TextEditingController(text: existing?.label ?? '');
    String? selectedCity = existing?.municity;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Add Location' : 'Edit Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    labelText: 'Label (e.g. Home, School)'),
              ),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: () async {
                  final city = await _showCitySearch(ctx, selectedCity);
                  if (city != null) setDialogState(() => selectedCity = city);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'City',
                    suffixIcon: Icon(Icons.search),
                  ),
                  child: Text(
                    selectedCity ?? 'Search city or district...',
                    style: AppTextStyles.body.copyWith(
                      color: selectedCity != null
                          ? AppColors.textDark
                          : AppColors.textMid,
                    ),
                  ),
                ),
              ),
              if (selectedCity != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      philippineLocations[selectedCity]!,
                      style: AppTextStyles.caption,
                    ),
                  ),
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
              onPressed: selectedCity == null || labelCtrl.text.trim().isEmpty
                  ? null
                  : () async {
                      Navigator.pop(ctx);
                      final loc = UserLocation(
                        id: existing?.id,
                        label: labelCtrl.text.trim(),
                        municity: selectedCity!,
                        province: philippineLocations[selectedCity]!,
                      );
                      if (existing == null) {
                        await _db.insertUserLocation(loc);
                      } else {
                        await _db.updateUserLocation(loc);
                      }
                      _load();
                    },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showCitySearch(BuildContext context, String? current) {
    final searchCtrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final query = searchCtrl.text.toLowerCase();
          final filtered = query.isEmpty
              ? philippineLocations.keys.toList()
              : philippineLocations.keys
                  .where((c) => c.toLowerCase().contains(query))
                  .toList();
          return AlertDialog(
            titlePadding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
            title: TextField(
              controller: searchCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search city or district...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: (_) => setState(() {}),
            ),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: double.maxFinite,
              height: 320,
              child: filtered.isEmpty
                  ? Center(
                      child: Text('No results', style: AppTextStyles.body))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final city = filtered[i];
                        final province = philippineLocations[city]!;
                        final selected = city == current;
                        return ListTile(
                          dense: true,
                          title: Text(
                            city,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(province,
                              style: AppTextStyles.caption),
                          trailing: selected
                              ? const Icon(Icons.check,
                                  color: AppColors.brandPink, size: 18)
                              : null,
                          onTap: () => Navigator.pop(ctx, city),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _delete(UserLocation loc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Location'),
        content: Text('Remove "${loc.label}" from your locations?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Remove',
              style: AppTextStyles.body.copyWith(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _db.deleteUserLocation(loc.id!);
      _load();
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
                  'Manage Locations',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1Blue.copyWith(fontSize: 30),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // ── Add New button ─────────────────────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: TextButton.icon(
                    onPressed: () => _showLocationDialog(),
                    icon: const Icon(Icons.add,
                        color: AppColors.brandBlue, size: 18),
                    label: Text(
                      'Add New',
                      style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.brandBlue),
                    ),
                  ),
                ),
              ),

              // ── Location list ──────────────────────────────────────────────
              Expanded(
                child: _locations.isEmpty
                    ? Center(
                        child: Text(
                          'No locations added yet.\nTap "Add New" to add one.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                              color: AppColors.textMid),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: _locations.length,
                        itemBuilder: (ctx, i) => _LocationCard(
                          location: _locations[i],
                          isHome:
                              _locations[i].municity == _homeMunicity,
                          onSetAsHome: () => _setAsHome(_locations[i]),
                          onEdit: () => _showLocationDialog(
                              existing: _locations[i]),
                          onDelete: () => _delete(_locations[i]),
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

// ── Location card ─────────────────────────────────────────────────────────────

class _LocationCard extends StatelessWidget {
  final UserLocation location;
  final bool isHome;
  final VoidCallback onSetAsHome;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _LocationCard({
    required this.location,
    required this.isHome,
    required this.onSetAsHome,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDark.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Label pill ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.brandBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              location.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.brandBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // ── City and province ──────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.municity,
                  style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  location.province,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          // ── Action icons ───────────────────────────────────────────────
          IconButton(
            tooltip: isHome
                ? 'Current home location'
                : 'Set as home location',
            icon: Icon(
              isHome ? Icons.home : Icons.home_outlined,
              size: 20,
              color: isHome ? AppColors.brandPink : AppColors.textMid,
            ),
            onPressed: isHome ? null : onSetAsHome,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                size: 20, color: AppColors.brandBlue),
            onPressed: onEdit,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                size: 20, color: AppColors.errorRed),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}