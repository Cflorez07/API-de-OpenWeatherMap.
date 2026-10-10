import 'package:app/core/utils/date_utils.dart';

/// Modelo Dart que representa SOLO los campos del JSON de OpenWeatherMap
/// que usa la aplicación (ver Parte B – mapeo JSON → Dart).
///
///  JSON                      Dart
///  name                      city
///  sys.country               country
///  main.temp                 temperature
///  main.feels_like           feelsLike
///  main.humidity             humidity
///  main.pressure             pressure
///  wind.speed                windSpeed (m/s)
///  weather[0].description    description
///  weather[0].icon           icon
///  coord.lat / coord.lon     latitude / longitude
///  sys.sunrise / sys.sunset  sunrise / sunset (UNIX, segundos)
///  timezone                  timezone (desfase en segundos)
///  dt                        timestamp (UNIX, segundos)
class Weather {
  final String city;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final String description;
  final String icon;
  final double latitude;
  final double longitude;
  final int timezone;
  final int timestamp;
  final int? sunrise;
  final int? sunset;

  const Weather({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.latitude,
    required this.longitude,
    this.timezone = 0,
    this.timestamp = 0,
    this.sunrise,
    this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;
    final coord = json['coord'] as Map<String, dynamic>;
    final sys = (json['sys'] as Map<String, dynamic>?) ?? const {};
    final weatherList = json['weather'] as List<dynamic>;
    final weather = weatherList.first as Map<String, dynamic>;

    return Weather(
      city: json['name'] as String,
      // Algunas ubicaciones (p. ej. el mar) no traen país.
      country: (sys['country'] as String?) ?? '',
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: (main['humidity'] as num).toInt(),
      pressure: (main['pressure'] as num).toInt(),
      windSpeed: (wind['speed'] as num).toDouble(),
      description: weather['description'] as String,
      icon: weather['icon'] as String,
      latitude: (coord['lat'] as num).toDouble(),
      longitude: (coord['lon'] as num).toDouble(),
      timezone: (json['timezone'] as num?)?.toInt() ?? 0,
      timestamp: (json['dt'] as num?)?.toInt() ?? 0,
      sunrise: (sys['sunrise'] as num?)?.toInt(),
      sunset: (sys['sunset'] as num?)?.toInt(),
    );
  }

  /// "Cartagena, CO" (o solo "Cartagena" si no hay país).
  String get displayName => country.isEmpty ? city : '$city, $country';

  /// Texto para volver a consultar la misma ciudad: "Cartagena,CO".
  String get searchQuery => country.isEmpty ? city : '$city,$country';

  /// La API entrega el viento en m/s; la interfaz lo muestra en km/h.
  double get windKmh => windSpeed * 3.6;

  /// Fecha y hora local de la ciudad en el momento de la medición.
  DateTime? get localDate =>
      timestamp == 0 ? null : cityTime(timestamp, timezone);

  DateTime? get sunriseTime {
    final value = sunrise;
    return value == null ? null : cityTime(value, timezone);
  }

  DateTime? get sunsetTime {
    final value = sunset;
    return value == null ? null : cityTime(value, timezone);
  }
}