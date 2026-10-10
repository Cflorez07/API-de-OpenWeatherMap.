import 'package:flutter/material.dart';

import 'package:app/features/weather/data/presentation/navigation/weather_navigation.dart';
import 'package:app/features/weather/data/presentation/state/weather_controller.dart';
import 'package:app/features/weather/data/presentation/widgets/layout_widgets.dart';

/// Pestaña Favoritos: ciudades guardadas con el corazón del resultado.
/// Al tocar una se consulta de nuevo la API.
class FavoritesPage extends StatelessWidget {
  final WeatherController controller;

  const FavoritesPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SkyBackground(
      child: SafeArea(
        child: ResponsiveBody(
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final favorites = controller.favorites;

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Favoritos',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D3B66),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: favorites.isEmpty
                          ? const _EmptyFavorites()
                          : ListView.separated(
                              itemCount: favorites.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final query = favorites[index];
                                return SoftCard(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: ListTile(
                                    leading: const Icon(Icons.location_on,
                                        color: Colors.red),
                                    title: Text(
                                      query.replaceAll(',', ', '),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: const Text('Toca para ver el clima'),
                                    trailing: IconButton(
                                      tooltip: 'Quitar de favoritos',
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () =>
                                          controller.toggleFavorite(query),
                                    ),
                                    onTap: () => searchAndShowWeather(
                                        context, controller, query),
                                  ),
                                );
                              },
                            ),
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

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border, size: 72, color: Colors.black38),
          SizedBox(height: 12),
          Text(
            'Aún no tienes ciudades favoritas.',
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          Text(
            'Toca el corazón en el resultado del clima para guardarlas.',
            style: TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}