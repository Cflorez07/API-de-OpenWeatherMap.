import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:app/core/constants/api_constants.dart';
import 'package:app/features/weather/data/models/weather.dart';
import 'package:app/features/weather/data/presentation/widgets/layout_widgets.dart';

/// Mapa (OpenStreetMap, sin API key) centrado en las coordenadas que
/// devolvió la API (coord.lat / coord.lon), con la tarjeta de ubicación
/// y el botón "Ver en Google Maps".
/// Lo usan la pantalla Ubicación y la pestaña Mapa.
class LocationView extends StatelessWidget {
  final Weather weather;

  const LocationView({super.key, required this.weather});

  Future<void> _openGoogleMaps(BuildContext context) async {
    final uri = Uri.parse(
      ApiConstants.googleMapsUrl(weather.latitude, weather.longitude),
    );
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      opened = false;
    }
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir Google Maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final point = LatLng(weather.latitude, weather.longitude);

    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FlutterMap(
              // La clave obliga a recentrar el mapa cuando cambia la ciudad.
              key: ValueKey('${weather.latitude},${weather.longitude}'),
              options: MapOptions(initialCenter: point, initialZoom: 10),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: point,
                      width: 48,
                      height: 48,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 48,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SoftCard(
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFF0D3B66), size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Lat: ${weather.latitude}   Lon: ${weather.longitude}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _openGoogleMaps(context),
            icon: const Icon(Icons.map),
            label: const Text('Ver en Google Maps'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: const Color(0xFF1E88E5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}