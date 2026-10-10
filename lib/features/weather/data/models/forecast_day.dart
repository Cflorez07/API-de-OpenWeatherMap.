import 'package:app/core/utils/date_utils.dart';

/// Un día del pronóstico.
///
/// La API (/data/2.5/forecast) devuelve un registro cada 3 horas durante
/// 5 días. Aquí se agrupan por día (en la hora local de la ciudad) para
/// obtener la temperatura máxima, la mínima y el icono del mediodía.
///
///  JSON                      Dart
///  city.timezone             (desfase para calcular el día local)
///  list[].dt                 date
///  list[].main.temp          tempMax / tempMin (máx y mín del día)
///  list[].weather[0]         description / icon (registro más cercano a las 12:00)
class ForecastDay {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final String description;
  final String icon;

  const ForecastDay({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.description,
    required this.icon,
  });

  static List<ForecastDay> listFromJson(Map<String, dynamic> json) {
    final city = json['city'] as Map<String, dynamic>;
    final timezone = (city['timezone'] as num?)?.toInt() ?? 0;
    final items = json['list'] as List<dynamic>;

    // 1. Agrupar los registros por día local (el Map conserva el orden).
    final groups = <String, List<Map<String, dynamic>>>{};
    for (final raw in items) {
      final item = raw as Map<String, dynamic>;
      final date = cityTime((item['dt'] as num).toInt(), timezone);
      final key = '${date.year}-${date.month}-${date.day}';
      groups.putIfAbsent(key, () => []).add(item);
    }

    // 2. Resumir cada día.
    final days = <ForecastDay>[];
    for (final entries in groups.values) {
      final temps = entries
          .map((e) => ((e['main'] as Map<String, dynamic>)['temp'] as num)
              .toDouble())
          .toList();

      var pick = entries.first;
      var bestDiff = 99;
      for (final e in entries) {
        final hour = cityTime((e['dt'] as num).toInt(), timezone).hour;
        final diff = (hour - 12).abs();
        if (diff < bestDiff) {
          bestDiff = diff;
          pick = e;
        }
      }

      final weather =
          (pick['weather'] as List<dynamic>).first as Map<String, dynamic>;

      days.add(
        ForecastDay(
          date: cityTime((pick['dt'] as num).toInt(), timezone),
          tempMax: temps.reduce((a, b) => a > b ? a : b),
          tempMin: temps.reduce((a, b) => a < b ? a : b),
          description: weather['description'] as String,
          icon: _toDayIcon(weather['icon'] as String),
        ),
      );
    }

    return days.take(5).toList();
  }

  /// En el pronóstico se muestra siempre la versión de día del icono
  /// ("10n" -> "10d").
  static String _toDayIcon(String icon) =>
      icon.endsWith('n') ? '${icon.substring(0, icon.length - 1)}d' : icon;
}