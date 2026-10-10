import 'package:flutter/material.dart';

import 'package:app/core/errors/api_exception.dart';
import 'package:app/features/weather/data/models/weather.dart';
import 'package:app/features/weather/data/presentation/pages/error_page.dart';
import 'package:app/features/weather/data/presentation/pages/weather_page.dart';
import 'package:app/features/weather/data/presentation/state/weather_controller.dart';

/// Consulta la ciudad y navega al resultado (éxito) o a la pantalla de
/// error (fallo). Lo usan Inicio y Favoritos para no repetir la lógica.
Future<void> searchAndShowWeather(
  BuildContext context,
  WeatherController controller,
  String city,
) async {
  if (controller.loading) return;

  final Weather weather;
  try {
    weather = await controller.search(city);
  } catch (e) {
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (errorContext) => ErrorPage(
          message: messageFrom(e),
          onRetry: () {
            Navigator.pop(errorContext); // vuelve a la pantalla anterior
            searchAndShowWeather(context, controller, city); // repite
          },
        ),
      ),
    );
    return;
  }

  if (!context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => WeatherPage(controller: controller, weather: weather),
    ),
  );
}