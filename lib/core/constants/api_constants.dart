/// Constantes de la API OpenWeatherMap (Current Weather API).
class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  /// URL base de los iconos del clima. Ej: .../img/wn/01d@2x.png
  static const String iconBaseUrl = 'https://openweathermap.org/img/wn';

  /// La API Key se puede pasar al ejecutar:
  ///   flutter run --dart-define=OPENWEATHER_API_KEY=tu_clave
  /// o escribirla aquí como valor por defecto (no la subas a GitHub).
  static const String apiKey = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
    defaultValue: '4da1247dfbd586dcc33efd8f197314ac',
  );

  /// Tiempo máximo de espera de la solicitud HTTP.
  static const Duration timeout = Duration(seconds: 10);
/// Enlace para abrir unas coordenadas en Google Maps.
  static String googleMapsUrl(double lat, double lon) =>
      'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
}