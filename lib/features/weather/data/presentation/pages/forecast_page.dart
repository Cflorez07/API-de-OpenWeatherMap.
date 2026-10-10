import 'package:flutter/material.dart';

import 'package:app/core/utils/date_utils.dart';
import 'package:app/core/utils/text_utils.dart';
import 'package:app/features/weather/data/models/forecast_day.dart';
import 'package:app/features/weather/data/presentation/widgets/layout_widgets.dart';
import 'package:app/features/weather/data/presentation/widgets/weather_icon.dart';

/// Pantalla 4 – Pronóstico de los próximos días (máxima / mínima).
class ForecastPage extends StatelessWidget {
  final String city;
  final List<ForecastDay> days;

  const ForecastPage({super.key, required this.city, required this.days});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronóstico'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SkyBackground(
        child: SafeArea(
          child: ResponsiveBody(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 64, 20, 24),
              children: [
                Text(
                  city,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D3B66),
                  ),
                ),
                const SizedBox(height: 12),
                SoftCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      for (var i = 0; i < days.length; i++) ...[
                        if (i > 0) const Divider(height: 1),
                        _ForecastRow(day: days[i]),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Datos proporcionados por OpenWeather',
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final ForecastDay day;

  const _ForecastRow({required this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shortWeekday(day.date),
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  formatShortDate(day.date),
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          WeatherIcon(code: day.icon, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${day.tempMax.round()}° / ${day.tempMin.round()}°',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  capitalize(day.description),
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}