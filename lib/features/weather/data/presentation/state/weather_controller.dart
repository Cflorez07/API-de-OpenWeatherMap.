import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/features/weather/data/models/forecast_day.dart';
import 'package:app/features/weather/data/models/weather.dart';
import 'package:app/features/weather/data/repositories/weather_repository.dart';

/// Estado compartido por las tres pestañas (Inicio, Mapa y Favoritos).
/// Las pantallas hablan con este controlador y él con el repositorio.
class WeatherController extends ChangeNotifier {
  WeatherController(this._repository);

  static const String _favoritesKey = 'favorite_cities';

  final WeatherRepository _repository;

  Weather? _lastWeather;
  bool _loading = false;
  List<String> _favorites = [];

  /// Última ciudad consultada (la usa la pestaña Mapa).
  Weather? get lastWeather => _lastWeather;

  bool get loading => _loading;

  /// Consultas guardadas, con el formato "Cartagena,CO".
  List<String> get favorites => List.unmodifiable(_favorites);

  Future<Weather> search(String city) async {
    _loading = true;
    notifyListeners();
    try {
      final weather = await _repository.getWeather(city);
      _lastWeather = weather;
      return weather;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<List<ForecastDay>> forecastFor(double lat, double lon) {
    return _repository.getForecast(lat, lon);
  }

  bool isFavorite(String query) =>
      _favorites.any((f) => f.toLowerCase() == query.toLowerCase());

  Future<void> toggleFavorite(String query) async {
    if (isFavorite(query)) {
      _favorites =
          _favorites.where((f) => f.toLowerCase() != query.toLowerCase()).toList();
    } else {
      _favorites = [..._favorites, query];
    }
    notifyListeners();
    await _saveFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _favorites = prefs.getStringList(_favoritesKey) ?? [];
      notifyListeners();
    } catch (_) {
      // Si no se puede leer el almacenamiento, la app sigue funcionando.
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, _favorites);
    } catch (_) {
      // Los favoritos quedan en memoria durante la sesión.
    }
  }
}