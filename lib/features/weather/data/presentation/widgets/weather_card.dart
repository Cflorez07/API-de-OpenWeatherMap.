import 'package:flutter/material.dart';

import 'package:app/core/utils/date_utils.dart';
import 'package:app/core/utils/text_utils.dart';
import 'package:app/features/weather/data/models/weather.dart';
import 'package:app/features/weather/data/presentation/widgets/layout_widgets.dart';
import 'package:app/features/weather/data/presentation/widgets/weather_icon.dart';

const Color _darkBlue = Color(0xFF0D3B66);

/// Ciudad, fecha, icono, temperatura y descripción (parte superior de la Pantalla 2).
class WeatherSummary extends StatelessWidget {
  final Weather weather;

  const WeatherSummary({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final date = weather.localDate ?? DateTime.now();

    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 30),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.displayName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _darkBlue,
                    ),
                  ),
                  Text(
                    formatLongDate(date),
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WeatherIcon(code: weather.icon, size: 96),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weather.temperature.round()}°C',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: _darkBlue,
                  ),
                ),
                Text(
                  capitalize(weather.description),
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// Tarjeta con sensación térmica, humedad, viento y presión.
class WeatherInfoCard extends StatelessWidget {
  final Weather weather;

  const WeatherInfoCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.thermostat,
            title: 'Sensación térmica',
            value: '${weather.feelsLike.round()}°C',
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.water_drop,
            title: 'Humedad',
            value: '${weather.humidity}%',
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.air,
            title: 'Viento',
            value: '${weather.windKmh.round()} km/h',
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.speed,
            title: 'Presión',
            value: '${weather.pressure} hPa',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1E88E5)),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// Fichas de amanecer y atardecer (sys.sunrise y sys.sunset).
class SunTimesRow extends StatelessWidget {
  final Weather weather;

  const SunTimesRow({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final sunrise = weather.sunriseTime;
    final sunset = weather.sunsetTime;

    return Row(
      children: [
        Expanded(
          child: _SunTile(
            icon: Icons.wb_twilight,
            color: const Color(0xFFFFA726),
            label: 'Amanecer',
            time: sunrise == null ? '--' : formatTime12h(sunrise),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SunTile(
            icon: Icons.nights_stay,
            color: const Color(0xFF5C6BC0),
            label: 'Atardecer',
            time: sunset == null ? '--' : formatTime12h(sunset),
          ),
        ),
      ],
    );
  }
}

class _SunTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String time;

  const _SunTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.black54)),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}