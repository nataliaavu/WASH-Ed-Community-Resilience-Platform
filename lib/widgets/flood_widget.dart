import 'package:flutter/material.dart';
import 'package:wash_ed_app/controllers/api_controller.dart';
import 'package:wash_ed_app/models/flood_status.dart';

class FloodWidget extends StatefulWidget {
  const FloodWidget({super.key});

  @override
  State<FloodWidget> createState() => _FloodWidgetState();
}

class _FloodWidgetState extends State<FloodWidget> {
  final ApiController _controller = ApiController();
  List<FloodStatus> _statuses = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final statuses = await _controller.getFloodStatuses();
      setState(() {
        _statuses = statuses;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.grey),
            const SizedBox(width: 8),
            const Expanded(
                child: Text('Flood data unavailable.',
                    style: TextStyle(color: Colors.grey))),
            TextButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              const Icon(Icons.flood, color: Color(0xFF3D5AFE)),
              const SizedBox(width: 8),
              const Text('River Gauge Status',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              TextButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
        ..._statuses.map((s) => _GaugeTile(status: s)),
      ],
    );
  }
}

class _GaugeTile extends StatelessWidget {
  final FloodStatus status;
  const _GaugeTile({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(status.severity);
    final label = _severityLabel(status.severity);
    final fillFraction =
        (status.waterLevel / (status.alertLevel * 1.5)).clamp(0.0, 1.0);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(status.gaugeName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(
                        '${status.river} · ${status.province}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Water: ${status.waterLevel.toStringAsFixed(1)} m',
                    style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 8),
                Text('Alert: ${status.alertLevel.toStringAsFixed(1)} m',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fillFraction,
                minHeight: 8,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _severityColor(String s) => switch (s) {
        'NO_FLOODING' => Colors.green,
        'FLOOD_SEVERITY_WATCH' => Colors.amber,
        'FLOOD_SEVERITY_WARNING' => Colors.orange,
        'FLOOD_SEVERITY_EMERGENCY' => Colors.red,
        _ => Colors.grey,
      };

  String _severityLabel(String s) => switch (s) {
        'NO_FLOODING' => 'Normal',
        'FLOOD_SEVERITY_WATCH' => 'Watch',
        'FLOOD_SEVERITY_WARNING' => 'Warning',
        'FLOOD_SEVERITY_EMERGENCY' => 'Emergency',
        _ => s,
      };
}
