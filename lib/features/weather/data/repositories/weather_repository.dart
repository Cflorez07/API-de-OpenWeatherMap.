import 'package:app/core/errors/api_exception.dart';
import 'package:app/features/weather/data/models/forecast_day.dart';
import 'package:app/features/weather/data/models/weather.dart';
import 'package:app/features/weather/data/services/weather_service.dart';

/// Une el servicio (JSON crudo) con los modelos (objetos Dart).
/// La interfaz solo habla con el repositorio.
class WeatherRepository {
  final WeatherService _service;

  WeatherRepository(this._service);

  Future<Weather> getWeather(String city) async {
    final json = await _service.fetchWeatherByCity(city);

    try {
      return Weather.fromJson(json);
    } on TypeError {
      // Falta un campo o tiene un tipo inesperado.
      throw const ApiException(
          'La respuesta de la API tiene un formato inesperado.');
    } on StateError {
      throw const ApiException(
          'La respuesta de la API no trae datos del clima.');
    }
  }

  Future<List<ForecastDay>> getForecast(double lat, double lon) async {
    final json = await _service.fetchForecastByCoordinates(lat, lon);

    try {
      return ForecastDay.listFromJson(json);
    } on TypeError {
      throw const ApiException(
          'La respuesta del pronóstico tiene un formato inesperado.');
    } on StateError {
      throw const ApiException(
          'La respuesta de la API no trae datos de pronóstico.');
    }
  }
}