import 'package:flutter/material.dart';
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
                          title: Text(c,
                              style: TextStyle(
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                          subtitle: Text(p,
                              style: const TextStyle(fontSize: 11)),
                          trailing: selected
                              ? const Icon(Icons.check,
                                  color: Color(0xFF1A45A0), size: 18)
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFCE4EC), Color(0xFFF3E5F5)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 72),
              const Text(
                'Select Your Location',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A45A0),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'We use your location to send real-time\nlocal flood alerts and updates',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 36),
              GestureDetector(
                onTap: _openSearch,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selected ?? 'Choose city or district name',
                          style: TextStyle(
                            fontSize: 15,
                            color: _selected != null
                                ? Colors.black87
                                : Colors.grey,
                          ),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down,
                          color: Colors.grey, size: 24),
                    ],
                  ),
                ),
              ),
              if (_selected != null) ...[
                const SizedBox(height: 14),
                Text(
                  philippineLocations[_selected] ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xFF1A45A0),
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
