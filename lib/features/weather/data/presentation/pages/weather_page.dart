import 'package:flutter/material.dart';

import 'package:app/core/errors/api_exception.dart';
import 'package:app/core/utils/date_utils.dart';
import 'package:app/features/weather/data/models/forecast_day.dart';
import 'package:app/features/weather/data/models/weather.dart';
import 'package:app/features/weather/data/presentation/pages/forecast_page.dart';
import 'package:app/features/weather/data/presentation/pages/location_page.dart';
import 'package:app/features/weather/data/presentation/state/weather_controller.dart';
import 'package:app/features/weather/data/presentation/widgets/layout_widgets.dart';
import 'package:app/features/weather/data/presentation/widgets/weather_card.dart';
import 'package:app/features/weather/data/presentation/widgets/weather_icon.dart';

/// Pantalla 2 – Resultado del clima: datos actuales, amanecer/atardecer,
/// pronóstico resumido, ubicación y botón para actualizar.
class WeatherPage extends StatefulWidget {
  final WeatherController controller;
  final Weather weather;

  const WeatherPage({
    super.key,
    required this.controller,
    required this.weather,
  });

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Weather _weather;
  late Future<List<ForecastDay>> _forecast;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _weather = widget.weather;
    _forecast = _loadForecast();
  }

  @override
  void didUpdateWidget(covariant WeatherPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    final weatherChanged = oldWidget.weather != widget.weather;
    final controllerChanged = oldWidget.controller != widget.controller;

    if (weatherChanged || controllerChanged) {
      _weather = widget.weather;
      _forecast = _loadForecast();
      if (mounted) setState(() {});
    }
  }

  Future<List<ForecastDay>> _loadForecast() =>
      widget.controller.forecastFor(_weather.latitude, _weather.longitude);

  Future<void> _refresh() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);
    try {
      final updated = await widget.controller.search(_weather.searchQuery);
      if (!mounted) return;
      setState(() {
        _weather = updated;
        _forecast = _loadForecast();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(messageFrom(e))),
      );
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  void _openLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LocationPage(weather: _weather)),
    );
  }

  void _openForecast(List<ForecastDay> days) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ForecastPage(city: _weather.displayName, days: days),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          ListenableBuilder(
            listenable: widget.controller,
            builder: (context, _) {
              final isFav = widget.controller.isFavorite(_weather.searchQuery);
              return IconButton(
                tooltip: isFav ? 'Quitar de favoritos' : 'Agregar a favoritos',
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () =>
                    widget.controller.toggleFavorite(_weather.searchQuery),
              );
            },
          ),
        ],
      ),
      body: SkyBackground(
        child: SafeArea(
          child: ResponsiveBody(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
              children: [
                WeatherSummary(weather: _weather),
                const SizedBox(height: 20),
                WeatherInfoCard(weather: _weather),
                const SizedBox(height: 12),
                SunTimesRow(weather: _weather),
                const SizedBox(height: 20),
                _buildForecastSection(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _openLocation,
                        icon: const Icon(Icons.location_on),
                        label: const Text('Ver ubicación'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _refreshing ? null : _refresh,
                        icon: _refreshing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.refresh),
                        label: const Text('Actualizar'),
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

  Widget _buildForecastSection() {
    return FutureBuilder<List<ForecastDay>>(
      future: _forecast,
      builder: (context, snapshot) {
        Widget content;
        VoidCallback? onSeeAll;

        if (snapshot.connectionState != ConnectionState.done) {
          content = const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || (snapshot.data ?? []).isEmpty) {
          content = const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('No se pudo cargar el pronóstico.'),
          );
        } else {
          final days = snapshot.data!;
          onSeeAll = () => _openForecast(days);
          content = Row(
            children: [
              for (var i = 0; i < days.length && i < 4; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(child: _MiniForecast(day: days[i], isToday: i == 0)),
              ],
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pronóstico',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D3B66),
                    ),
                  ),
                ),
                if (onSeeAll != null)
                  TextButton(
                    onPressed: onSeeAll,
                    child: const Text('Ver 5 días'),
                  ),
              ],
            ),
            content,
          ],
        );
      },
    );
  }
}

class _MiniForecast extends StatelessWidget {
  final ForecastDay day;
  final bool isToday;

  const _MiniForecast({required this.day, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Column(
        children: [
          Text(
            isToday ? 'Hoy' : shortWeekday(day.date),
            style: const TextStyle(color: Colors.black54),
          ),
          WeatherIcon(code: day.icon, size: 40),
          Text(
            '${day.tempMax.round()}°',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}