// Mirrors the TenDay Weather Forecast API response structure.
// Field names match the API JSON keys exactly for easy fromJson/toJson.

class WeatherForecast {
  final String date;
  final String province;
  final String municity;
  final String rainfallDesc;
  final double rainfallTotal;
  final String cloudCover;
  final double tmean;
  final double tmin;
  final double tmax;
  final int humidity;
  final double windSpeed;
  final String windDirection;

  const WeatherForecast({
    required this.date,
    required this.province,
    required this.municity,
    required this.rainfallDesc,
    required this.rainfallTotal,
    required this.cloudCover,
    required this.tmean,
    required this.tmin,
    required this.tmax,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: json['date'] as String,
      province: json['province'] as String,
      municity: json['municity'] as String,
      rainfallDesc: json['rainfall_desc'] as String,
      rainfallTotal: (json['rainfall_total'] as num).toDouble(),
      cloudCover: json['cloud_cover'] as String,
      tmean: (json['tmean'] as num).toDouble(),
      tmin: (json['tmin'] as num).toDouble(),
      tmax: (json['tmax'] as num).toDouble(),
      humidity: json['humidity'] as int,
      windSpeed: (json['wind_speed'] as num).toDouble(),
      windDirection: json['wind_direction'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'province': province,
    'municity': municity,
    'rainfall_desc': rainfallDesc,
    'rainfall_total': rainfallTotal,
    'cloud_cover': cloudCover,
    'tmean': tmean,
    'tmin': tmin,
    'tmax': tmax,
    'humidity': humidity,
    'wind_speed': windSpeed,
    'wind_direction': windDirection,
  };

  // SQLite column names match JSON keys, so fromMap delegates to fromJson.
  factory WeatherForecast.fromMap(Map<String, dynamic> map) =>
      WeatherForecast.fromJson(map);
}

class TenDayMetadata {
  final int requestNo;
  final String api;
  final String forecast;
  final String issuanceDate;
  final String region;
  final String province;
  final String municity;

  const TenDayMetadata({
    required this.requestNo,
    required this.api,
    required this.forecast,
    required this.issuanceDate,
    required this.region,
    required this.province,
    required this.municity,
  });

  factory TenDayMetadata.fromJson(Map<String, dynamic> json) {
    return TenDayMetadata(
      requestNo: json['request_no'] as int,
      api: json['api'] as String,
      forecast: json['forecast'] as String,
      issuanceDate: json['issuance_date'] as String,
      region: json['region'] as String,
      province: json['province'] as String,
      municity: json['municity'] as String,
    );
  }
}

class TenDayApiResponse {
  final WeatherForecast data;
  final TenDayMetadata metadata;

  const TenDayApiResponse({required this.data, required this.metadata});

  factory TenDayApiResponse.fromJson(Map<String, dynamic> json) {
    return TenDayApiResponse(
      data: WeatherForecast.fromJson(json['data'] as Map<String, dynamic>),
      metadata: TenDayMetadata.fromJson(
        json['metadata'] as Map<String, dynamic>,
      ),
    );
  }
}
