import 'package:flutter/material.dart';

import 'package:app/features/weather/data/presentation/state/weather_controller.dart';
import 'package:app/features/weather/data/presentation/widgets/layout_widgets.dart';
import 'package:app/features/weather/data/presentation/widgets/location_view.dart';

/// Pestaña Mapa: muestra la ubicación de la última ciudad consultada.
class MapPage extends StatelessWidget {
  final WeatherController controller;

  const MapPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SkyBackground(
      child: SafeArea(
        child: ResponsiveBody(
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final weather = controller.lastWeather;

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mapa',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D3B66),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: weather == null
                          ? const Center(
                              child: Text(
                                'Consulta una ciudad para ver su ubicación en el mapa.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 17),
                              ),
                            )
                          : LocationView(weather: weather),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}