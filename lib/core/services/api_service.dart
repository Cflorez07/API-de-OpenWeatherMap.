import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:app/core/constants/api_constants.dart';

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  Future<Map<String, dynamic>> getWeather(String city) async {
    final uri = Uri.parse(ApiConstants.baseUrl).replace(
      queryParameters: {
        'q': city,
        'appid': ApiConstants.apiKey,
        'units': 'metric',
        'lang': 'es',
      },
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      if (response.statusCode == 401) {
        throw ApiException('API Key inválida.');
      }

      if (response.statusCode == 404) {
        throw ApiException('Ciudad no encontrada.');
      }

      if (response.statusCode == 429) {
        throw ApiException('Límite de solicitudes alcanzado.');
      }

      throw ApiException(
        'Error del servidor: ${response.statusCode}',
      );
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      throw ApiException(
        'No se pudo conectar con el servidor.',
      );
    }
  }
}