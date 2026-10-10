import 'package:flutter/material.dart';

import 'package:app/features/weather/data/models/weather.dart';
import 'package:app/features/weather/data/presentation/widgets/layout_widgets.dart';
import 'package:app/features/weather/data/presentation/widgets/location_view.dart';

/// Pantalla 3 – Ubicación. Mapa con las coordenadas que devolvió la API.
class LocationPage extends StatelessWidget {
  final Weather weather;

  const LocationPage({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SkyBackground(
        child: SafeArea(
          child: ResponsiveBody(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 64, 20, 20),
              child: LocationView(weather: weather),
            ),
          ),
        ),
      ),
    );
  }
}