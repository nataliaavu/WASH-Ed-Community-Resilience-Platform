import 'package:wash_ed_app/models/flood_status.dart';

// Mock data shaped like the Google Flood Forecasting API responses.
// Uses real Philippine river gauge locations and realistic water levels.
class MockFloodDataSource {
  // Returns only gauges within radiusKm of the given coordinates.
  // Uses simple flat-earth approximation (accurate enough for ~200 km).
  List<FloodStatus> getFloodStatuses(double lat, double lng, double radiusKm) {
    final r2 = radiusKm * radiusKm;
    return _gauges.where((g) {
      final dx = (g.longitude - lng) * 90;
      final dy = (g.latitude - lat) * 111;
      return dx * dx + dy * dy <= r2;
    }).toList();
  }

  List<FlashFloodEvent> getFlashFloods(double lat, double lng, double radiusKm) {
    final r2 = radiusKm * radiusKm;
    return _flashFloods.where((e) {
      // FlashFloodEvent doesn't have coordinates — filter by matching
      // provinces of gauges that are within radius.
      final nearbyProvinces = _gauges
          .where((g) {
            final dx = (g.longitude - lng) * 90;
            final dy = (g.latitude - lat) * 111;
            return dx * dx + dy * dy <= r2;
          })
          .map((g) => g.province)
          .toSet();
      return nearbyProvinces.contains(e.province);
    }).toList();
  }

  static final List<FloodStatus> _gauges = [
    // ── Metro Manila ─────────────────────────────────────────────────────────
    const FloodStatus(
      gaugeId: 'PH-GAUGE-001',
      gaugeName: 'Marikina Bridge Station',
      latitude: 14.6507,
      longitude: 121.1029,
      severity: 'FLOOD_SEVERITY_WARNING',
      floodStatusCode: 'MODERATE',
      waterLevel: 14.2,   // 94.7 % of alert — HIGH risk, not CRITICAL
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
      waterLevel: 8.2,    // 68.3 % of alert — MODERATE risk
      alertLevel: 12.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Marikina River',
      province: 'Metro Manila',
    ),
    const FloodStatus(
      gaugeId: 'PH-GAUGE-003',
      gaugeName: 'Napindan Channel Station',
      latitude: 14.5048,
      longitude: 121.1068,
      severity: 'FLOOD_SEVERITY_WARNING',
      floodStatusCode: 'MODERATE',
      waterLevel: 3.1,    // 88.6 % of alert — HIGH risk, not CRITICAL
      alertLevel: 3.5,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Pasig-Marikina River',
      province: 'Metro Manila',
    ),
    // ── Bulacan ──────────────────────────────────────────────────────────────
    const FloodStatus(
      gaugeId: 'PH-GAUGE-004',
      gaugeName: 'Bulacan River at Malolos',
      latitude: 14.8527,
      longitude: 120.8107,
      severity: 'NO_FLOODING',
      floodStatusCode: 'NORMAL',
      waterLevel: 1.2,
      alertLevel: 4.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Bulacan River',
      province: 'Bulacan',
    ),
    const FloodStatus(
      gaugeId: 'PH-GAUGE-005',
      gaugeName: 'Angat River at Norzagaray',
      latitude: 14.9239,
      longitude: 121.0166,
      severity: 'FLOOD_SEVERITY_WATCH',
      floodStatusCode: 'ABOVE_NORMAL',
      waterLevel: 5.0,    // 71.4 % of alert — MODERATE risk
      alertLevel: 7.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Angat River',
      province: 'Bulacan',
    ),
    // ── Pampanga / Central Luzon ─────────────────────────────────────────────
    const FloodStatus(
      gaugeId: 'PH-GAUGE-006',
      gaugeName: 'Pampanga at Arayat',
      latitude: 15.1550,
      longitude: 120.7700,
      severity: 'NO_FLOODING',
      floodStatusCode: 'NORMAL',
      waterLevel: 3.2,
      alertLevel: 8.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Pampanga River',
      province: 'Pampanga',
    ),
    const FloodStatus(
      gaugeId: 'PH-GAUGE-007',
      gaugeName: 'Agno River at Bayambang',
      latitude: 15.8138,
      longitude: 120.4572,
      severity: 'NO_FLOODING',
      floodStatusCode: 'NORMAL',
      waterLevel: 2.1,
      alertLevel: 6.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Agno River',
      province: 'Pangasinan',
    ),
    // ── Ilocos Region ────────────────────────────────────────────────────────
    const FloodStatus(
      gaugeId: 'PH-GAUGE-008',
      gaugeName: 'Laoag River Station',
      latitude: 18.1967,
      longitude: 120.5935,
      severity: 'NO_FLOODING',
      floodStatusCode: 'NORMAL',
      waterLevel: 1.5,
      alertLevel: 5.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Laoag River',
      province: 'Ilocos Norte',
    ),
    // ── Cagayan Valley ───────────────────────────────────────────────────────
    const FloodStatus(
      gaugeId: 'PH-GAUGE-009',
      gaugeName: 'Cagayan River at Tuguegarao',
      latitude: 17.6131,
      longitude: 121.7269,
      severity: 'FLOOD_SEVERITY_WATCH',
      floodStatusCode: 'ABOVE_NORMAL',
      waterLevel: 6.3,    // 70.0 % of alert — MODERATE risk
      alertLevel: 9.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Cagayan River',
      province: 'Cagayan',
    ),
    // ── Bicol Region ─────────────────────────────────────────────────────────
    const FloodStatus(
      gaugeId: 'PH-GAUGE-010',
      gaugeName: 'Bicol River at Naga',
      latitude: 13.6192,
      longitude: 123.1814,
      severity: 'FLOOD_SEVERITY_WATCH',
      floodStatusCode: 'ABOVE_NORMAL',
      waterLevel: 4.3,    // 71.7 % of alert — MODERATE risk
      alertLevel: 6.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Bicol River',
      province: 'Camarines Sur',
    ),
    // ── Western Visayas ──────────────────────────────────────────────────────
    const FloodStatus(
      gaugeId: 'PH-GAUGE-011',
      gaugeName: 'Iloilo River Station',
      latitude: 10.6969,
      longitude: 122.5644,
      severity: 'NO_FLOODING',
      floodStatusCode: 'NORMAL',
      waterLevel: 1.8,
      alertLevel: 5.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Iloilo River',
      province: 'Iloilo',
    ),
    // ── Central Visayas ──────────────────────────────────────────────────────
    const FloodStatus(
      gaugeId: 'PH-GAUGE-012',
      gaugeName: 'Butuanon River at Mandaue',
      latitude: 10.3394,
      longitude: 123.9078,
      severity: 'NO_FLOODING',
      floodStatusCode: 'NORMAL',
      waterLevel: 0.9,
      alertLevel: 3.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Butuanon River',
      province: 'Cebu',
    ),
    // ── Eastern Visayas ──────────────────────────────────────────────────────
    const FloodStatus(
      gaugeId: 'PH-GAUGE-013',
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
    // ── Northern Mindanao ────────────────────────────────────────────────────
    const FloodStatus(
      gaugeId: 'PH-GAUGE-014',
      gaugeName: 'Cagayan de Oro River Station',
      latitude: 8.4542,
      longitude: 124.6319,
      severity: 'FLOOD_SEVERITY_WATCH',
      floodStatusCode: 'ABOVE_NORMAL',
      waterLevel: 5.6,    // 70.0 % of alert — MODERATE risk
      alertLevel: 8.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Cagayan de Oro River',
      province: 'Misamis Oriental',
    ),
    // ── Davao Region ─────────────────────────────────────────────────────────
    const FloodStatus(
      gaugeId: 'PH-GAUGE-015',
      gaugeName: 'Davao River at Sirawan',
      latitude: 7.0731,
      longitude: 125.6128,
      severity: 'NO_FLOODING',
      floodStatusCode: 'NORMAL',
      waterLevel: 2.5,
      alertLevel: 7.0,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Davao River',
      province: 'Davao del Sur',
    ),
    // ── SOCCSKSARGEN ─────────────────────────────────────────────────────────
    const FloodStatus(
      gaugeId: 'PH-GAUGE-016',
      gaugeName: 'Mindanao River at Cotabato',
      latitude: 7.2044,
      longitude: 124.2464,
      severity: 'FLOOD_SEVERITY_WARNING',
      floodStatusCode: 'MODERATE',
      waterLevel: 5.0,    // 90.9 % of alert — HIGH risk, not CRITICAL
      alertLevel: 5.5,
      issueTime: '2026-05-08T10:00:00+08:00',
      river: 'Mindanao River',
      province: 'Maguindanao',
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
    const FlashFloodEvent(
      eventId: 'FF-2026-003',
      area: 'Norzagaray and San Rafael low-lying barangays',
      province: 'Bulacan',
      severity: 'FLOOD_SEVERITY_WATCH',
      description:
          'Water level at Angat Dam spillway is rising due to sustained '
          'rainfall in the Angat watershed. Residents along the Angat River '
          'corridor are advised to monitor updates and prepare go-bags.',
      issueTime: '2026-05-08T10:00:00+08:00',
    ),
    const FlashFloodEvent(
      eventId: 'FF-2026-004',
      area: 'Tuguegarao City riverside barangays',
      province: 'Cagayan',
      severity: 'FLOOD_SEVERITY_WATCH',
      description:
          'The Cagayan River is above normal due to rainfall in upstream '
          'areas. Residents in low-lying barangays along the riverbank '
          'should stay alert and prepare for possible evacuation.',
      issueTime: '2026-05-08T07:00:00+08:00',
    ),
    const FlashFloodEvent(
      eventId: 'FF-2026-005',
      area: 'Cotabato City low-lying areas',
      province: 'Maguindanao',
      severity: 'FLOOD_SEVERITY_WARNING',
      description:
          'The Mindanao River has exceeded alert level. Flooding is ongoing '
          'in several low-lying barangays in Cotabato City. Residents are '
          'urged to move to evacuation centers immediately.',
      issueTime: '2026-05-08T06:00:00+08:00',
    ),
    const FlashFloodEvent(
      eventId: 'FF-2026-006',
      area: 'Naga City riverside communities',
      province: 'Camarines Sur',
      severity: 'FLOOD_SEVERITY_WATCH',
      description:
          'Bicol River water level is nearing alert level following '
          'continuous moderate to heavy rainfall in the Bicol Peninsula. '
          'Residents are advised to monitor updates closely.',
      issueTime: '2026-05-08T08:30:00+08:00',
    ),
  ];
}
