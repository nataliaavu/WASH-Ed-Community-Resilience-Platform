import 'package:flutter/material.dart';
import 'package:wash_ed_app/config/app_theme.dart';
import 'package:wash_ed_app/data/philippine_locations.dart';

class SetupLocationPage extends StatefulWidget {
  final String? selectedMunicity;
  final void Function(String municity, String province) onLocationSelected;

  const SetupLocationPage({
    super.key,
    this.selectedMunicity,
    required this.onLocationSelected,
  });

  @override
  State<SetupLocationPage> createState() => _SetupLocationPageState();
}

class _SetupLocationPageState extends State<SetupLocationPage> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedMunicity;
  }

  // ── Location search logic — untouched ─────────────────────────────────────

  Future<void> _openSearch() async {
    final searchCtrl = TextEditingController();
    final city = await showDialog<String>(
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
            titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                  ? const Center(child: Text('No results'))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        final p = philippineLocations[c]!;
                        final selected = c == _selected;
                        return ListTile(
                          dense: true,
                          title: Text(
                            c,
                            style: TextStyle(
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(p,
                              style: AppTextStyles.caption),
                          trailing: selected
                              ? const Icon(Icons.check,
                                  color: AppColors.brandBlue, size: 18)
                              : null,
                          onTap: () => Navigator.pop(ctx, c),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );

    if (city != null) {
      final province = philippineLocations[city]!;
      setState(() => _selected = city);
      widget.onLocationSelected(city, province);
    }
  }

  @override
  Widget build(BuildContext context) {
    // No background — parent setup_page.dart provides the gradient
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 72),
          Text(
            'Select Your Location',
            textAlign: TextAlign.center,
            style: AppTextStyles.h1Blue.copyWith(fontSize: 32, height: 1.2),
          ),
          const SizedBox(height: 14),
          Text(
            'We use your location to send real-time\nlocal flood alerts and updates',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textMid),
          ),
          const SizedBox(height: 36),
          GestureDetector(
            onTap: _openSearch,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selected ?? 'Choose city or district name',
                      style: AppTextStyles.body.copyWith(
                        color: _selected != null
                            ? AppColors.textDark
                            : AppColors.textMid,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.textMid, size: 24),
                ],
              ),
            ),
          ),
          if (_selected != null) ...[
            const SizedBox(height: 14),
            Text(
              philippineLocations[_selected] ?? '',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.brandBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}