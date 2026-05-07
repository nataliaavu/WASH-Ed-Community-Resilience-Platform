import 'package:wash_ed_app/models/flood_status.dart';

// Mock data shaped like the Google Flood Forecasting API responses.
// Uses real Philippine river gauge locations and realistic water levels.
class MockFloodDataSource {
  List<FloodStatus> getFloodStatuses() => _gauges;

  List<FlashFloodEvent> getFlashFloods() => _flashFloods;

  static final List<FloodStatus> _gauges = [
    const FloodStatus(
      gaugeId: 'PH-GAUGE-001',
      gaugeName: 'Marikina Bridge Station',
      latitude: 14.6507,
      longitude: 121.1029,
      severity: 'FLOOD_SEVERITY_WARNING',
      floodStatusCode: 'MODERATE',
      waterLevel: 15.8,
      alertLevel: 15.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Marikina River',
      province: 'Metro Manila',
    ),
    const FloodStatus(
      gaugeId: 'PH-GAUGE-002',
      gaugeName: 'Nangka Bridge Station',
      latitude: 14.6760,
      longitude: 121.0900,
      severity: 'FLOOD_SEVERITY_WATCH',
      floodStatusCode: 'ABOVE_NORMAL',
      waterLevel: 12.1,
      alertLevel: 12.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Marikina River',
      province: 'Metro Manila',
    ),
    const FloodStatus(
      gaugeId: 'PH-GAUGE-003',
      gaugeName: 'Pampanga at Arayat',
      latitude: 15.1550,
      longitude: 120.7700,
      severity: 'NO_FLOODING',
      floodStatusCode: 'ABOVE_NORMAL',
      waterLevel: 3.2,
      alertLevel: 8.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Pampanga River',
      province: 'Pampanga',
    ),
    const FloodStatus(
      gaugeId: 'PH-GAUGE-004',
      gaugeName: 'Leyte River Gauge',
      latitude: 11.2439,
      longitude: 124.9987,
      severity: 'FLOOD_SEVERITY_EMERGENCY',
      floodStatusCode: 'MAJOR',
      waterLevel: 9.8,
      alertLevel: 6.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Leyte River',
      province: 'Leyte',
    ),
  ];

  static final List<FlashFloodEvent> _flashFloods = [
    const FlashFloodEvent(
      eventId: 'FF-2026-001',
      area: 'Marikina Valley',
      province: 'Metro Manila',
      severity: 'FLOOD_SEVERITY_WARNING',
      description:
          'Flash flood watch in effect for low-lying areas along Marikina '
          'River. Continuous heavy rainfall since 06:00 has caused rapid '
          'rise in water levels. Residents near the river are advised to '
          'move to higher ground immediately.',
      issueTime: '2026-05-08T09:30:00+08:00',
    ),
    const FlashFloodEvent(
      eventId: 'FF-2026-002',
      area: 'Tacloban City coastal barangays',
      province: 'Leyte',
      severity: 'FLOOD_SEVERITY_EMERGENCY',
      description:
          'Tropical cyclone-induced storm surge of 2-4 meters expected '
          'along coastal barangays. MANDATORY EVACUATION in effect. '
          'All residents must proceed to designated evacuation centers now.',
      issueTime: '2026-05-08T08:00:00+08:00',
    ),
  ];
}
