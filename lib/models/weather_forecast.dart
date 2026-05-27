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
      date:          json['date'] as String,
      province:      json['province'] as String,
      municity:      json['municity'] as String,
      rainfallDesc:  json['rainfall_desc'] as String,
      rainfallTotal: (json['rainfall_total'] as num).toDouble(),
      cloudCover:    json['cloud_cover'] as String,
      tmean:         (json['tmean'] as num).toDouble(),
      tmin:          (json['tmin'] as num).toDouble(),
      tmax:          (json['tmax'] as num).toDouble(),
      humidity:      (json['humidity'] as num).toInt(),
      windSpeed:     (json['wind_speed'] as num).toDouble(),
      windDirection: json['wind_direction'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'date':           date,
    'province':       province,
    'municity':       municity,
    'rainfall_desc':  rainfallDesc,
    'rainfall_total': rainfallTotal,
    'cloud_cover':    cloudCover,
    'tmean':          tmean,
    'tmin':           tmin,
    'tmax':           tmax,
    'humidity':       humidity,
    'wind_speed':     windSpeed,
    'wind_direction': windDirection,
  };

  factory WeatherForecast.fromMap(Map<String, dynamic> map) =>
      WeatherForecast.fromJson(map);
}

class WeatherMetadata {
  final int requestNo;
  final String api;
  final String forecast;
  final String issuanceDate;
  final String region;
  final String province;
  final String municity;

  const WeatherMetadata({
    required this.requestNo,
    required this.api,
    required this.forecast,
    required this.issuanceDate,
    required this.region,
    required this.province,
    required this.municity,
  });

  factory WeatherMetadata.fromJson(Map<String, dynamic> json) {
    return WeatherMetadata(
      requestNo:    (json['request_no'] as num).toInt(),
      api:          json['api'] as String,
      forecast:     json['forecast'] as String,
      issuanceDate: json['issuance_date'] as String,
      region:       json['region'] as String,
      province:     json['province'] as String,
      municity:     json['municity'] as String,
    );
  }
}

class HourlyForecast {
  final String time;
  final double temperature;
  final String weather;
  final double precipitationTotal;
  final String precipitationType;
  final int cloudCover;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.weather,
    required this.precipitationTotal,
    required this.precipitationType,
    required this.cloudCover,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time:               json['time'] as String,
      temperature:        (json['temperature'] as num).toDouble(),
      weather:            json['weather'] as String,
      precipitationTotal: (json['precipitation_total'] as num).toDouble(),
      precipitationType:  json['precipitation_type'] as String,
      cloudCover:         (json['cloud_cover'] as num).toInt(),
    );
  }
}

class WeatherApiResponse {
  final WeatherForecast data;
  final WeatherMetadata metadata;
  final List<HourlyForecast> hourly;

  const WeatherApiResponse({
    required this.data,
    required this.metadata,
    this.hourly = const [],
  });

  factory WeatherApiResponse.fromJson(Map<String, dynamic> json) {
    return WeatherApiResponse(
      data:     WeatherForecast.fromJson(json['data'] as Map<String, dynamic>),
      metadata: WeatherMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      hourly:   (json['hourly'] as List<dynamic>? ?? [])
          .map((h) => HourlyForecast.fromJson(h as Map<String, dynamic>))
          .toList(),
    );
  }
}
