import 'package:wash_ed_app/models/weather_forecast.dart';

// Mock data shaped exactly like the TenDay Weather Forecast API response.
// Values are realistic for Philippine weather during monsoon/typhoon season.
class MockWeatherDataSource {
  TenDayApiResponse fetchForecast(String municity, String province) {
    final entry = _mockDb()[municity];
    if (entry != null) return entry;
    return _defaultResponse(municity, province);
  }

  Map<String, TenDayApiResponse> _mockDb() => {
    'Marikina City': TenDayApiResponse(
      data: const WeatherForecast(
        date: '5/8/26',
        province: 'Metro Manila',
        municity: 'Marikina City',
        rainfallDesc: 'HEAVY RAINS',
        rainfallTotal: 45.2,
        cloudCover: 'CLOUDY',
        tmean: 28.49,
        tmin: 25.65,
        tmax: 31.33,
        humidity: 88,
        windSpeed: 25.0,
        windDirection: 'SW',
      ),
      metadata: TenDayMetadata(
        requestNo: 1001,
        api: 'Forecast by Date',
        forecast: '10-day Forecast',
        issuanceDate: '5/8/2026',
        region: 'National Capital Region (NCR)',
        province: 'Metro Manila',
        municity: 'Marikina City',
      ),
    ),
    'Quezon City': TenDayApiResponse(
      data: const WeatherForecast(
        date: '5/8/26',
        province: 'Metro Manila',
        municity: 'Quezon City',
        rainfallDesc: 'MODERATE RAINS',
        rainfallTotal: 22.4,
        cloudCover: 'PARTLY CLOUDY',
        tmean: 29.10,
        tmin: 26.00,
        tmax: 32.20,
        humidity: 85,
        windSpeed: 18.0,
        windDirection: 'SSW',
      ),
      metadata: TenDayMetadata(
        requestNo: 1002,
        api: 'Forecast by Date',
        forecast: '10-day Forecast',
        issuanceDate: '5/8/2026',
        region: 'National Capital Region (NCR)',
        province: 'Metro Manila',
        municity: 'Quezon City',
      ),
    ),
    'San Fernando': TenDayApiResponse(
      data: const WeatherForecast(
        date: '5/8/26',
        province: 'Pampanga',
        municity: 'San Fernando',
        rainfallDesc: 'LIGHT RAINS',
        rainfallTotal: 8.0,
        cloudCover: 'PARTLY CLOUDY',
        tmean: 31.00,
        tmin: 27.50,
        tmax: 34.50,
        humidity: 79,
        windSpeed: 12.5,
        windDirection: 'NNE',
      ),
      metadata: TenDayMetadata(
        requestNo: 1003,
        api: 'Forecast by Date',
        forecast: '10-day Forecast',
        issuanceDate: '5/8/2026',
        region: 'Central Luzon (Region III)',
        province: 'Pampanga',
        municity: 'San Fernando',
      ),
    ),
    'Tacloban City': TenDayApiResponse(
      data: const WeatherForecast(
        date: '5/8/26',
        province: 'Leyte',
        municity: 'Tacloban City',
        rainfallDesc: 'VERY HEAVY RAINS',
        rainfallTotal: 120.5,
        cloudCover: 'OVERCAST',
        tmean: 27.30,
        tmin: 24.10,
        tmax: 30.50,
        humidity: 92,
        windSpeed: 65.0,
        windDirection: 'ENE',
      ),
      metadata: TenDayMetadata(
        requestNo: 1004,
        api: 'Forecast by Date',
        forecast: '10-day Forecast',
        issuanceDate: '5/8/2026',
        region: 'Eastern Visayas (Region VIII)',
        province: 'Leyte',
        municity: 'Tacloban City',
      ),
    ),
  };

  TenDayApiResponse _defaultResponse(String municity, String province) {
    return TenDayApiResponse(
      data: WeatherForecast(
        date: '5/8/26',
        province: province,
        municity: municity,
        rainfallDesc: 'LIGHT RAINS',
        rainfallTotal: 5.0,
        cloudCover: 'PARTLY CLOUDY',
        tmean: 30.0,
        tmin: 26.5,
        tmax: 33.5,
        humidity: 80,
        windSpeed: 15.0,
        windDirection: 'N',
      ),
      metadata: TenDayMetadata(
        requestNo: 0,
        api: 'Forecast by Date',
        forecast: '10-day Forecast',
        issuanceDate: '5/8/2026',
        region: 'Philippines',
        province: province,
        municity: municity,
      ),
    );
  }
}
