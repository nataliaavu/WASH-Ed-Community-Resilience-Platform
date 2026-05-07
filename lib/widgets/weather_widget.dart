import 'package:flutter/material.dart';
import 'package:wash_ed_app/controllers/api_controller.dart';
import 'package:wash_ed_app/models/weather_forecast.dart';

class WeatherWidget extends StatefulWidget {
  final String municity;
  final String province;

  const WeatherWidget({
    super.key,
    required this.municity,
    required this.province,
  });

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  final ApiController _controller = ApiController();
  TenDayApiResponse? _response;
  bool _loading = true;
  bool _fromCache = false;
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
      final online = await _controller.isOnline();
      final response =
          await _controller.getForecast(widget.municity, widget.province);
      setState(() {
        _response = response;
        _fromCache = !online;
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
    if (_error != null) return _buildError();
    return _buildCard(_response!);
  }

  Widget _buildCard(TenDayApiResponse r) {
    final d = r.data;
    final meta = r.metadata;
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFF3D5AFE)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${d.municity}, ${d.province}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                if (_fromCache)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Offline — cached',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
              ],
            ),
            const Divider(height: 20),
            _row(Icons.thermostat, 'Mean Temp', '${d.tmean}°C'),
            _row(Icons.thermostat_outlined, 'Min / Max',
                '${d.tmin}°C / ${d.tmax}°C'),
            _row(Icons.water_drop, 'Humidity', '${d.humidity}%'),
            _row(Icons.air, 'Wind', '${d.windSpeed} kph ${d.windDirection}'),
            _row(Icons.umbrella, 'Rainfall',
                '${d.rainfallTotal} mm — ${d.rainfallDesc}'),
            _row(Icons.cloud, 'Cloud Cover', d.cloudCover),
            const SizedBox(height: 8),
            Text(
              '${meta.forecast} · Issued ${meta.issuanceDate}',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            if (meta.region.isNotEmpty)
              Text(
                meta.region,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            TextButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF3D5AFE)),
          const SizedBox(width: 8),
          Text('$label: ',
              style:
                  const TextStyle(fontSize: 13, color: Colors.black54)),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: Colors.grey),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('Weather unavailable.',
                style: TextStyle(color: Colors.grey)),
          ),
          TextButton(onPressed: _load, child: const Text('Retry')),
        ],
      ),
    );
  }
}
