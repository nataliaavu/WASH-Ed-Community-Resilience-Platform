import 'package:flutter/material.dart';
import 'package:wash_ed_app/config/app_config.dart';
import 'package:wash_ed_app/controllers/api_controller.dart';
import 'package:wash_ed_app/models/flood_status.dart';
import 'package:wash_ed_app/models/weather_forecast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiController _api = ApiController();
  TenDayApiResponse? _weather;
  List<FloodStatus> _floodStatuses = [];
  bool _loading = true;

  static const _severityOrder = [
    'NO_FLOODING',
    'FLOOD_SEVERITY_WATCH',
    'FLOOD_SEVERITY_WARNING',
    'FLOOD_SEVERITY_EMERGENCY',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final weatherFuture = _api.getForecast(
        AppConfig.defaultMunicity,
        AppConfig.defaultProvince,
      );
      final floodFuture = _api.getFloodStatuses();
      final weather = await weatherFuture;
      final floods = await floodFuture;
      if (mounted) {
        setState(() {
          _weather = weather;
          _floodStatuses = floods;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Computed getters ────────────────────────────────────────────────────────

  String get _worstSeverity {
    if (_floodStatuses.isEmpty) return 'NO_FLOODING';
    return _floodStatuses
        .map((s) => s.severity)
        .reduce((a, b) =>
            _severityOrder.indexOf(a) >= _severityOrder.indexOf(b) ? a : b);
  }

  FloodStatus? get _worstGauge {
    if (_floodStatuses.isEmpty) return null;
    return _floodStatuses.reduce((a, b) =>
        (a.waterLevel / a.alertLevel) >= (b.waterLevel / b.alertLevel)
            ? a
            : b);
  }

  double get _riskRatio {
    final g = _worstGauge;
    if (g == null || g.alertLevel == 0) return 0;
    return g.waterLevel / g.alertLevel;
  }

  Color get _severityBgColor {
    switch (_worstSeverity) {
      case 'FLOOD_SEVERITY_WATCH':
        return const Color(0xFFFFF9C4);
      case 'FLOOD_SEVERITY_WARNING':
        return const Color(0xFFFFE0B2);
      case 'FLOOD_SEVERITY_EMERGENCY':
        return const Color(0xFFFFCDD2);
      default:
        return const Color(0xFFC3EB9A);
    }
  }

  Color get _dotColor {
    switch (_worstSeverity) {
      case 'FLOOD_SEVERITY_WATCH':
        return const Color(0xFFFFC107);
      case 'FLOOD_SEVERITY_WARNING':
        return const Color(0xFFFF9800);
      case 'FLOOD_SEVERITY_EMERGENCY':
        return const Color(0xFFF44336);
      default:
        return Colors.grey;
    }
  }

  String get _severityLabel {
    switch (_worstSeverity) {
      case 'FLOOD_SEVERITY_WATCH':
        return 'Flood Watch';
      case 'FLOOD_SEVERITY_WARNING':
        return 'Flood Warning';
      case 'FLOOD_SEVERITY_EMERGENCY':
        return 'Emergency Alert';
      default:
        return 'All Clear';
    }
  }

  String get _kikoTitle {
    switch (_worstSeverity) {
      case 'FLOOD_SEVERITY_WATCH':
        return 'Water levels are being monitored.';
      case 'FLOOD_SEVERITY_WARNING':
        return 'Water levels are rising near you!';
      case 'FLOOD_SEVERITY_EMERGENCY':
        return 'Dangerous flood levels detected!';
      default:
        return 'Everything is looking safe right now!';
    }
  }

  String get _kikoMessage {
    switch (_worstSeverity) {
      case 'FLOOD_SEVERITY_WATCH':
        return 'Kiko says keep an eye out! Check your go-bag just in case.';
      case 'FLOOD_SEVERITY_WARNING':
        return 'Kiko says stay alert and prepare your safety bag. Call your squad!';
      case 'FLOOD_SEVERITY_EMERGENCY':
        return 'Kiko says follow evacuation instructions and call your squad contacts immediately!';
      default:
        return 'Kiko checked and water levels are just right. Time to learn and play!';
    }
  }

  String get _riskLabel {
    final r = _riskRatio;
    if (r <= 0.5) return 'LOW';
    if (r <= 0.8) return 'MODERATE';
    if (r < 1.0) return 'HIGH';
    return 'CRITICAL';
  }

  String get _kikoSprite {
    switch (_worstSeverity) {
      case 'FLOOD_SEVERITY_WATCH':
        return 'assets/kiko/WashEd_kiko_sprite_side-jump.png';
      case 'FLOOD_SEVERITY_WARNING':
        return 'assets/kiko/WashEd_kiko_sprite_stress.png';
      case 'FLOOD_SEVERITY_EMERGENCY':
        return 'assets/kiko/WashEd_kiko_sprite_sad.png';
      default:
        return 'assets/kiko/WashEd_kiko_sprite_thumbs-up.png';
    }
  }

  Color get _riskColor {
    final r = _riskRatio;
    if (r <= 0.5) return Colors.green;
    if (r <= 0.8) return Colors.amber;
    if (r < 1.0) return Colors.orange;
    return Colors.red;
  }

  IconData _weatherIcon(String cloudCover, String rainfallDesc) {
    final r = rainfallDesc.toUpperCase();
    if (r.contains('VERY HEAVY') || r.contains('HEAVY')) {
      return Icons.water_drop;
    }
    if (r.contains('RAIN')) return Icons.grain;
    final c = cloudCover.toUpperCase();
    if (c.contains('OVERCAST') || c == 'CLOUDY') return Icons.cloud;
    if (c.contains('PARTLY')) return Icons.cloud_queue;
    return Icons.wb_sunny;
  }

  Color _weatherIconColor(String cloudCover, String rainfallDesc) {
    final r = rainfallDesc.toUpperCase();
    if (r.contains('HEAVY')) return Colors.blue.shade700;
    if (r.contains('RAIN')) return Colors.blue.shade400;
    final c = cloudCover.toUpperCase();
    if (c.contains('OVERCAST') || c == 'CLOUDY') return Colors.grey;
    if (c.contains('PARTLY')) return Colors.blueGrey;
    return Colors.orange;
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final weather = _weather?.data;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Hello Miguel!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Image(
              image: const AssetImage(
                  'assets/wash-ed/WASHEd_logo_2022_og_no-shadow.png'),
              height: 50,
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: Colors.yellow, height: 2),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _locationChip(screenWidth, weather),
                        _temperatureChip(screenWidth, weather),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _kikoBox(screenWidth),
                    const SizedBox(height: 20),
                    _weatherBox(screenWidth, weather),
                    const SizedBox(height: 20),
                    _riskBox(screenWidth),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buttonBox('Learning\nModules', screenWidth * 0.27,
                            100, Icons.cast_for_education),
                        const SizedBox(width: 10),
                        _buttonBox('Flood\nPrepare', screenWidth * 0.27, 100,
                            Icons.checklist_sharp),
                        const SizedBox(width: 10),
                        _buttonBox('Play\nGames', screenWidth * 0.27, 100,
                            Icons.gamepad_outlined),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _sponsorsBox(),
                  ],
                ),
              ),
            ),
    );
  }

  // ── Widgets ─────────────────────────────────────────────────────────────────

  Widget _locationChip(double screenWidth, WeatherForecast? weather) {
    return Container(
      width: screenWidth * 0.4,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.yellow, width: 2),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Location",
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: Colors.blue, size: 30),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  weather?.municity ?? AppConfig.defaultMunicity,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _temperatureChip(double screenWidth, WeatherForecast? weather) {
    return Container(
      width: screenWidth * 0.35,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.yellow, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            weather != null
                ? _weatherIcon(weather.cloudCover, weather.rainfallDesc)
                : Icons.wb_sunny,
            color: weather != null
                ? _weatherIconColor(weather.cloudCover, weather.rainfallDesc)
                : Colors.orange,
            size: 40,
          ),
          const SizedBox(width: 15),
          Text(
            weather != null ? '${weather.tmean.round()}°' : '--°',
            style: const TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kikoBox(double screenWidth) {
    return Container(
      width: screenWidth,
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _severityBgColor,
        border: Border.all(color: Colors.grey, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _dotColor.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(_severityLabel,
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _kikoTitle,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(_kikoMessage,
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Image(
            image: AssetImage(_kikoSprite),
            height: 130,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _weatherBox(double width, WeatherForecast? weather) {
    final icon = weather != null
        ? _weatherIcon(weather.cloudCover, weather.rainfallDesc)
        : Icons.wb_sunny;
    final iconColor = weather != null
        ? _weatherIconColor(weather.cloudCover, weather.rainfallDesc)
        : Colors.orange;
    final temp =
        weather != null ? '${weather.tmean.round()}°' : '--°';

    return Container(
      width: width,
      height: 180,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: Colors.yellow, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weather by Hour",
            style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                5, (_) => _bubble(temp, icon, iconColor)),
          ),
        ],
      ),
    );
  }

  Widget _bubble(String temp, IconData icon, Color iconColor) {
    return Container(
      width: 50,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 6),
          Text(temp, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _riskBox(double width) {
    final gauge = _worstGauge;
    final barWidth = (width - 30).clamp(0.0, double.infinity);

    return Container(
      width: width,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: Colors.yellow, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Flood Risk",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                _riskLabel,
                style: TextStyle(
                  fontSize: 20,
                  color: _riskColor,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          if (gauge != null) ...[
            const SizedBox(height: 4),
            Text(
              '${gauge.gaugeName} — ${gauge.waterLevel}m / ${gauge.alertLevel}m',
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 30,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 239, 239),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.grey),
                ),
              ),
              Container(
                height: 30,
                width: barWidth * _riskRatio.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  color: _riskColor,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Safe",
                  style: TextStyle(color: Colors.black, fontSize: 15)),
              Text("Warning",
                  style: TextStyle(fontSize: 15, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttonBox(
      String text, double width, double height, IconData icon) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: Colors.yellow, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withValues(alpha: 0.7),
            blurRadius: 6,
            offset: const Offset(-1, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.black),
          const SizedBox(height: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _sponsorsBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: Colors.amber.shade300, width: 2),
      ),
      child: Column(
        children: [
          Text(
            "Kiko's Hub Powered By",
            style: TextStyle(
              color: Colors.pink.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _sponsorLogo('Foundation'),
              _sponsorLogo('Khuda Family\nFoundation'),
              _sponsorLogo('Reckitt'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Supported By",
            style: TextStyle(
              color: Colors.pink.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          _sponsorLogo('DepEd'),
        ],
      ),
    );
  }

  Widget _sponsorLogo(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10, color: Colors.black87),
      ),
    );
  }
}
