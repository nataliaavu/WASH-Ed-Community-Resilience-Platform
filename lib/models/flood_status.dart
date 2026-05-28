// Mirrors the Google Flood Forecasting API response shapes.
// SearchLatestFloodStatusByArea → List<FloodStatus>
// SearchLatestFlashFloods       → List<FlashFloodEvent>

class FloodStatus {
  final String gaugeId;
  final String gaugeName;
  final double latitude;
  final double longitude;
  final String severity; // NO_FLOODING | FLOOD_SEVERITY_WATCH | _WARNING | _EMERGENCY
  final String floodStatusCode; // ABOVE_NORMAL | MINOR | MODERATE | MAJOR
  final double waterLevel;
  final double alertLevel;
  final String issueTime; // ISO 8601
  final String river;
  final String province;

  const FloodStatus({
    required this.gaugeId,
    required this.gaugeName,
    required this.latitude,
    required this.longitude,
    required this.severity,
    required this.floodStatusCode,
    required this.waterLevel,
    required this.alertLevel,
    required this.issueTime,
    required this.river,
    required this.province,
  });

  factory FloodStatus.fromJson(Map<String, dynamic> json) {
    final loc = json['location'] as Map<String, dynamic>? ?? {};
    return FloodStatus(
      gaugeId: json['gaugeId'] as String? ?? json['gauge_id'] as String,
      gaugeName: json['gaugeName'] as String? ?? json['gauge_name'] as String,
      latitude: (loc['latitude'] as num? ?? json['latitude'] as num).toDouble(),
      longitude:
          (loc['longitude'] as num? ?? json['longitude'] as num).toDouble(),
      severity: json['severity'] as String,
      floodStatusCode:
          json['floodStatus'] as String? ?? json['flood_status_code'] as String,
      waterLevel: (json['waterLevel'] as num? ?? json['water_level'] as num)
          .toDouble(),
      alertLevel: (json['alertLevel'] as num? ?? json['alert_level'] as num)
          .toDouble(),
      issueTime:
          json['issueTime'] as String? ?? json['issue_time'] as String,
      river: json['river'] as String,
      province: json['province'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'gauge_id': gaugeId,
    'gauge_name': gaugeName,
    'latitude': latitude,
    'longitude': longitude,
    'severity': severity,
    'flood_status_code': floodStatusCode,
    'water_level': waterLevel,
    'alert_level': alertLevel,
    'issue_time': issueTime,
    'river': river,
    'province': province,
  };

  factory FloodStatus.fromMap(Map<String, dynamic> map) =>
      FloodStatus.fromJson({
        'gaugeId': map['gauge_id'],
        'gaugeName': map['gauge_name'],
        'latitude': map['latitude'],
        'longitude': map['longitude'],
        'severity': map['severity'],
        'floodStatus': map['flood_status_code'],
        'waterLevel': map['water_level'],
        'alertLevel': map['alert_level'],
        'issueTime': map['issue_time'],
        'river': map['river'],
        'province': map['province'],
      });
}

class FlashFloodEvent {
  final String eventId;
  final String area;
  final String province;
  final String severity;
  final String description;
  final String issueTime;

  const FlashFloodEvent({
    required this.eventId,
    required this.area,
    required this.province,
    required this.severity,
    required this.description,
    required this.issueTime,
  });

  factory FlashFloodEvent.fromJson(Map<String, dynamic> json) {
    return FlashFloodEvent(
      eventId: json['eventId'] as String? ?? json['event_id'] as String,
      area: json['area'] as String,
      province: json['province'] as String,
      severity: json['severity'] as String,
      description: json['description'] as String,
      issueTime:
          json['issueTime'] as String? ?? json['issue_time'] as String,
    );
  }
}
