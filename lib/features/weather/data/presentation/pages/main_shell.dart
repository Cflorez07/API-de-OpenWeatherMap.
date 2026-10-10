import 'package:flutter/material.dart';

import 'package:app/features/weather/data/repositories/weather_repository.dart';
import 'package:app/features/weather/data/services/weather_service.dart';
import 'package:app/features/weather/data/presentation/pages/favorites_page.dart';
import 'package:app/features/weather/data/presentation/pages/home_page.dart';
import 'package:app/features/weather/data/presentation/pages/map_page.dart';
import 'package:app/features/weather/data/presentation/state/weather_controller.dart';

/// Contenedor con la barra inferior: Inicio, Mapa y Favoritos.
/// Crea el controlador (repositorio + servicio) y lo comparte con las pestañas.
class MainShell extends StatefulWidget {
  /// Permite inyectar un repositorio (útil para pruebas).
  final WeatherRepository? repository;

  const MainShell({super.key, this.repository});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late final WeatherController _controller = WeatherController(
    widget.repository ?? WeatherRepository(WeatherService()),
  );

  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller.loadFavorites();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomePage(controller: _controller),
          MapPage(controller: _controller),
          FavoritesPage(controller: _controller),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Mapa',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}