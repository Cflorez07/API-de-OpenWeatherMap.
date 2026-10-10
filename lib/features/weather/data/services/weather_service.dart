import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:app/core/constants/api_constants.dart';
import 'package:app/core/errors/api_exception.dart';

/// Se encarga ÚNICAMENTE de hablar con la API REST:
/// arma la URL, hace el GET y traduce los códigos HTTP a excepciones.
/// No conoce los modelos ni la interfaz.
class WeatherService {
  final http.Client _client;

  static String get _forecastUrl =>
      '${ApiConstants.baseUrl.replaceFirst('/weather', '')}/forecast';

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  /// GET /data/2.5/weather?q={ciudad}&appid={key}&units=metric&lang=es
  Future<Map<String, dynamic>> fetchWeatherByCity(String city) {
    return _get(ApiConstants.baseUrl, {'q': city});
  }

  /// GET /data/2.5/forecast?lat={lat}&lon={lon}&appid={key}&units=metric&lang=es
  Future<Map<String, dynamic>> fetchForecastByCoordinates(
      double lat, double lon) {
    return _get(_forecastUrl, {'lat': '$lat', 'lon': '$lon'});
  }

  Future<Map<String, dynamic>> _get(
    String url,
    Map<String, String> params,
  ) async {
    final uri = Uri.parse(url).replace(
      queryParameters: {
        ...params,
        'appid': ApiConstants.apiKey,
        'units': 'metric',
        'lang': 'es',
      },
    );

    final http.Response response;
    try {
      response = await _client.get(uri).timeout(ApiConstants.timeout);
    } on TimeoutException {
      throw const ApiException(
          'La solicitud tardó demasiado. Intenta de nuevo.');
    } on http.ClientException {
      // Sin internet, DNS, CORS, etc. (funciona en móvil y en web).
      throw const ApiException(
          'No se pudo conectar. Revisa tu conexión a internet.');
    }

    switch (response.statusCode) {
      case 200:
        try {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } on FormatException {
          throw const ApiException('La respuesta del servidor no es válida.');
        }
      case 401:
        throw const ApiException('API Key inválida.', statusCode: 401);
      case 404:
        throw const ApiException('Ciudad no encontrada.', statusCode: 404);
      case 429:
        throw const ApiException(
            'Límite de solicitudes alcanzado. Espera un momento.',
            statusCode: 429);
      default:
        throw ApiException(
          'Error del servidor (${response.statusCode}).',
          statusCode: response.statusCode,
        );
    }
  }
}