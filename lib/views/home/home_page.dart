import 'package:flutter/material.dart';
import 'package:wash_ed_app/config/app_config.dart';
import 'package:wash_ed_app/config/app_theme.dart';
import 'package:wash_ed_app/controllers/api_controller.dart';
import 'package:wash_ed_app/data/app_notifiers.dart';
import 'package:wash_ed_app/data/database_helper.dart';
import 'package:wash_ed_app/data/philippine_location_coords.dart';
import 'package:wash_ed_app/data/philippine_locations.dart';
import 'package:wash_ed_app/models/weather_forecast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiController _api = ApiController();
  final DatabaseHelper _db = DatabaseHelper();
  WeatherApiResponse? _weather;
  bool _loading = true;
  String _userName = '';
  String? _selectedMunicity;

  @override
  void initState() {
    super.initState();
    homeLocationVersion.addListener(_loadData);
    profileNameVersion.addListener(_reloadName);
    _loadData();
  }

  @override
  void dispose() {
    homeLocationVersion.removeListener(_loadData);
    profileNameVersion.removeListener(_reloadName);
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final profile = await _db.getUserProfile();
      final municity = (profile?.municity.isNotEmpty == true)
          ? profile!.municity
          : AppConfig.defaultMunicity;
      final province = (profile?.province.isNotEmpty == true)
          ? profile!.province
          : AppConfig.defaultProvince;

      final activeMunicity = _selectedMunicity ?? municity;
      final activeProvince = philippineLocations[activeMunicity] ?? province;
      final coords = philippineLocationCoords[activeMunicity];
      final weather = await _api.getForecast(
        activeMunicity,
        activeProvince,
        lat: coords?.$1,
        lon: coords?.$2,
      );

      if (mounted) {
        setState(() {
          _userName = profile?.name ?? '';
          _weather = weather;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        // Still load the name even if weather/flood API fails
        final profile = await _db.getUserProfile();
        setState(() {
          _userName = profile?.name ?? '';
          _loading = false;
        });
      }

    }
  }

  Future<void> _reloadName() async {
    final profile = await _db.getUserProfile();
    if (mounted) setState(() => _userName = profile?.name ?? '');
  }

  // ── Computed getters ─────────────────────────────────────────────────────────
  // NOTE: these getters return dynamic colours driven by API flood/weather data.
  // They are intentionally NOT replaced with AppColors tokens.

  String get _proxyRisk => _weather?.data.floodRisk ?? 'Low';

  double get _riskRatio {
    switch (_proxyRisk) {
      case 'High':   return 0.9;
      case 'Medium': return 0.55;
      default:       return 0.2;
    }
  }

  Color get _severityBgColor {
    switch (_proxyRisk) {
      case 'High':   return AppColors.floodEmergency;
      case 'Medium': return AppColors.floodWatch;
      default:       return AppColors.floodClear;
    }
  }

  Color get _dotColor {
    switch (_proxyRisk) {
      case 'High':   return AppColors.errorRed;
      case 'Medium': return const Color(0xFFFFC107);
      default:       return Colors.grey;
    }
  }

  String get _severityLabel {
    switch (_proxyRisk) {
      case 'High':   return 'High Flood Risk';
      case 'Medium': return 'Medium Flood Risk';
      default:       return 'Low Flood Risk';
    }
  }

  String get _kikoTitle {
    switch (_proxyRisk) {
      case 'High':   return 'Dangerous weather conditions detected!';
      case 'Medium': return 'Heavy rain is expected near you!';
      default:       return 'Everything is looking safe right now!';
    }
  }

  String get _kikoMessage {
    switch (_proxyRisk) {
      case 'High':   return 'Kiko says be alert! Follow safety steps and call your squad contacts!';
      case 'Medium': return 'Kiko says keep an eye out! Check your go-bag just in case.';
      default:       return 'Kiko checked and conditions are calm. Time to learn and play!';
    }
  }

  String get _riskLabel {
    switch (_proxyRisk) {
      case 'High':   return 'HIGH';
      case 'Medium': return 'MEDIUM';
      default:       return 'LOW';
    }
  }

  String get _kikoSprite {
    switch (_proxyRisk) {
      case 'High':   return 'assets/kiko/WashEd_kiko_sprite_stress.png';
      case 'Medium': return 'assets/kiko/WashEd_kiko_sprite_side-jump.png';
      default:       return 'assets/kiko/WashEd_kiko_sprite_thumbs-up.png';
    }
  }

  Color get _riskColor {
    switch (_proxyRisk) {
      case 'High':   return Colors.red;
      case 'Medium': return Colors.amber;
      default:       return Colors.green;
    }
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

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final weather = _weather?.data;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar( // Blue rectangle at top of page
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        // AppBar background and foreground come from AppBarTheme in app_theme.dart
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _userName.isNotEmpty ? 'Hello $_userName!' : 'Hello!',
              style: AppTextStyles.h2White,
            ),
            Image(
              image: const AssetImage(
                'assets/wash-ed/WASHEd_logo_2022_og_no-shadow.png',
              ),
              height: 50,
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(color: AppColors.brandYellow, height: 2),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.pageBg),
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.brandPink))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg - 4),
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
                      const SizedBox(height: AppSpacing.lg - 4),
                      _kikoBox(screenWidth),
                      const SizedBox(height: AppSpacing.lg - 4),
                      _weatherBox(screenWidth, _weather),
                      const SizedBox(height: AppSpacing.lg - 4),
                      _riskBox(screenWidth),
                      const SizedBox(height: AppSpacing.lg - 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buttonBox(
                            'Learning\nModules',
                            screenWidth * 0.27,
                            100,
                            Icons.cast_for_education,
                            tabIndex: 1,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _buttonBox(
                            'Flood\nPrepare',
                            screenWidth * 0.27,
                            100,
                            Icons.checklist_sharp,
                            tabIndex: 2,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _buttonBox(
                            'Play\nGames',
                            screenWidth * 0.27,
                            100,
                            Icons.gamepad_outlined,
                            tabIndex: 3,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg - 4),
                      _sponsorsBox(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // ── Widgets ──────────────────────────────────────────────────────────────────

  Widget _locationChip(double screenWidth, WeatherForecast? weather) {
    final displayLocation = weather?.municity ?? AppConfig.defaultMunicity;
    return GestureDetector(
      onTap: _showLocationPicker,
      child: Container(
        width: screenWidth * 0.4,
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.sm + 2),
          border: Border.all(color: AppColors.brandYellow, width: 2),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Location', style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: AppColors.brandBlue, size: 30),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    displayLocation,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.arrow_drop_down,
                    color: Colors.blue, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationPicker() {
    final controller = TextEditingController();
    final allLocations = philippineLocations.keys.toList()..sort();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        List<String> filtered = allLocations;
        return StatefulBuilder(
          builder: (ctx, setModal) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.4,
            maxChildSize: 0.92,
            expand: false,
            builder: (_, scrollController) => Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Select Location',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Search city...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (val) => setModal(() {
                      filtered = allLocations
                          .where((l) => l
                              .toLowerCase()
                              .contains(val.toLowerCase()))
                          .toList();
                    }),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final city = filtered[i];
                      final province = philippineLocations[city] ?? '';
                      final isSelected =
                          city == (_selectedMunicity ?? _weather?.data.municity);
                      return ListTile(
                        leading: Icon(Icons.location_on_outlined,
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey),
                        title: Text(city,
                            style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                        subtitle: Text(province,
                            style: const TextStyle(fontSize: 12)),
                        selected: isSelected,
                        selectedTileColor:
                            Colors.blue.withValues(alpha: 0.08),
                        onTap: () {
                          Navigator.pop(ctx);
                          setState(() => _selectedMunicity = city);
                          _loadData();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _temperatureChip(double screenWidth, WeatherForecast? weather) {
    return Container(
      width: screenWidth * 0.35,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm + 2),
        border: Border.all(color: AppColors.brandYellow, width: 2),
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
            style: AppTextStyles.h2.copyWith(fontSize: 30),
          ),
        ],
      ),
    );
  }

  Widget _kikoBox(double screenWidth) {
    return Container(
      width: screenWidth,
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.sm, AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: _severityBgColor,
        border: Border.all(color: Colors.grey, width: 2),
        boxShadow: const [
          BoxShadow(
              color: Colors.grey, blurRadius: 6, offset: Offset(0, 3)),
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
                    const SizedBox(width: AppSpacing.sm),
                    Text(_severityLabel,
                        style: AppTextStyles.h3.copyWith(
                            fontWeight: FontWeight.normal, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(_kikoTitle,
                    style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.sm),
                Text(_kikoMessage, style: AppTextStyles.bodySmall),
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

  Widget _weatherBox(double width, WeatherApiResponse? weatherResp) {
    final weather = weatherResp?.data;
    final hourlyList = weatherResp?.hourly ?? [];

    final fallbackIcon = weather != null
        ? _weatherIcon(weather.cloudCover, weather.rainfallDesc)
        : Icons.wb_sunny;
    final fallbackColor = weather != null
        ? _weatherIconColor(weather.cloudCover, weather.rainfallDesc)
        : Colors.orange;
    final fallbackTemp =
        weather != null ? '${weather.tmean.round()}°' : '--°';

    List<Widget> bubbles;
    if (hourlyList.isNotEmpty) {
      bubbles = hourlyList.take(5).map((h) {
        final rainfallDesc =
            h.precipitationTotal == 0 || h.precipitationType == 'none'
                ? h.weather.toUpperCase()
                : h.precipitationTotal >= 15
                    ? 'HEAVY RAINS'
                    : 'LIGHT RAINS';
        final cloudDesc = h.weather.toUpperCase().replaceAll('_', ' ');
        return _bubble(
          '${h.temperature.round()}°',
          _weatherIcon(cloudDesc, rainfallDesc),
          _weatherIconColor(cloudDesc, rainfallDesc),
          time: h.time,
        );
      }).toList();
    } else {
      bubbles = List.generate(
        5,
        (_) => _bubble(fallbackTemp, fallbackIcon, fallbackColor),
      );
    }

    return Container(
      width: width,
      height: 190,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: AppColors.white,
        border: Border.all(color: AppColors.brandYellow, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weather by Hour',
              style: AppTextStyles.h3Blue.copyWith(fontSize: 20)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: bubbles,
          ),
        ],
      ),
    );
  }

  Widget _bubble(String temp, IconData icon, Color iconColor, {String? time}) {
    return Container(
      width: 50,
      height: 110,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (time != null)
            Text(time,
                style: AppTextStyles.caption.copyWith(fontSize: 9)),
          if (time != null) const SizedBox(height: AppSpacing.xs),
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: AppSpacing.xs),
          Text(temp, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _riskBox(double width) {
    final barWidth = (width - 30).clamp(0.0, double.infinity);

    return Container(
      width: width,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: AppColors.white,
        border: Border.all(color: AppColors.brandYellow, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Flood Risk',
                  style: AppTextStyles.h3Blue.copyWith(fontSize: 20)),
              Text(
                _riskLabel,
                style: AppTextStyles.h3.copyWith(
                  fontSize: 20,
                  color: _riskColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          if (_weather?.data != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Rainfall: ${_weather!.data.rainfallTotal.toStringAsFixed(1)}mm · '
              'Wind: ${_weather!.data.windSpeed.toStringAsFixed(0)} km/h · '
              'Rain chance: ${_weather!.data.precipitationProbability}%',
              style: AppTextStyles.caption,
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
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
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Safe', style: AppTextStyles.body),
              Text('Warning', style: AppTextStyles.body),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 13, color: Colors.orange),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'This is a weather-based estimate only. For official flood warnings, '
                    'check PAGASA (bagong.pagasa.dost.gov.ph) and NDRRMC (ndrrmc.gov.ph).',
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonBox(
    String text,
    double width,
    double height,
    IconData icon, {
    required int tabIndex,
  }) {
    return GestureDetector(
      onTap: () {
        tabSwitchRequest.value = -1;
        tabSwitchRequest.value = tabIndex;
      },
      child: Container(
        width: width,
        height: height,
        decoration: AppDecorations.yellowBorderCard(radius: AppRadius.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.textDark),
            const SizedBox(height: AppSpacing.xs),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sponsorsBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md, horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        color: AppColors.white,
        border: Border.all(color: Colors.amber.shade300, width: 2),
      ),
      child: Column(
        children: [
          Text(
            "Kiko's Hub Powered By",
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.brandPink,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _sponsorLogo('burger-point'),
              _sponsorLogo('connel-griffin'),
              _sponsorLogo('grundfos'),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Supported By',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.brandPink,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _sponsorLogo('dep-ed'),
        ],
      ),
    );
  }

  Widget _sponsorLogo(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Image.asset('assets/logos/$name.jpeg', width: 60),
    );
  }
}