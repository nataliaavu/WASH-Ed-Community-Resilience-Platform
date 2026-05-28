import 'package:flutter/material.dart';
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
              const SizedBox(height: 12),
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
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedCity != null
                          ? Colors.black87
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              if (selectedCity != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      philippineLocations[selectedCity]!,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black54),
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
                backgroundColor: const Color(0xFFE91E8C),
                foregroundColor: Colors.white,
              ),
              onPressed: selectedCity == null ||
                      labelCtrl.text.trim().isEmpty
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
            titlePadding:
                const EdgeInsets.fromLTRB(16, 16, 16, 0),
            title: TextField(
              controller: searchCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search city or district...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: (_) => setState(() {}),
            ),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: double.maxFinite,
              height: 320,
              child: filtered.isEmpty
                  ? const Center(child: Text('No results'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final city = filtered[i];
                        final province = philippineLocations[city]!;
                        final selected = city == current;
                        return ListTile(
                          dense: true,
                          title: Text(city,
                              style: TextStyle(
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                          subtitle: Text(province,
                              style: const TextStyle(fontSize: 11)),
                          trailing: selected
                              ? const Icon(Icons.check,
                                  color: Color(0xFFE91E8C), size: 18)
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
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Remove',
                  style: TextStyle(color: Colors.red))),
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
                  'Manage Locations',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A45A0),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: TextButton.icon(
                    onPressed: () => _showLocationDialog(),
                    icon: const Icon(Icons.add,
                        color: Color(0xFF1A45A0), size: 18),
                    label: const Text('Add New',
                        style: TextStyle(
                            color: Color(0xFF1A45A0), fontSize: 13)),
                  ),
                ),
              ),
              Expanded(
                child: _locations.isEmpty
                    ? const Center(
                        child: Text(
                          'No locations added yet.\nTap "Add New" to add one.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _locations.length,
                        itemBuilder: (ctx, i) => _LocationCard(
                          location: _locations[i],
                          isHome: _locations[i].municity == _homeMunicity,
                          onSetAsHome: () => _setAsHome(_locations[i]),
                          onEdit: () =>
                              _showLocationDialog(existing: _locations[i]),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1A45A0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              location.label,
              style: const TextStyle(
                  color: Color(0xFF1A45A0),
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.municity,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  location.province,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: isHome
                ? 'Current home location'
                : 'Set as home location',
            icon: Icon(
              isHome ? Icons.home : Icons.home_outlined,
              size: 20,
              color: isHome ? const Color(0xFFE91E8C) : Colors.grey,
            ),
            onPressed: isHome ? null : onSetAsHome,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                size: 20, color: Color(0xFF1A45A0)),
            onPressed: onEdit,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                size: 20, color: Colors.red),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
