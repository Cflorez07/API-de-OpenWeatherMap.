
import 'package:flutter/material.dart';

import 'package:app/features/weather/data/presentation/navigation/weather_navigation.dart';
import 'package:app/features/weather/data/presentation/state/weather_controller.dart';
import 'package:app/features/weather/data/presentation/widgets/layout_widgets.dart';
import 'package:app/features/weather/data/presentation/widgets/search_field.dart';

/// Pantalla 1 – Inicio. Pide la ciudad, consulta la API a través del
/// controlador y navega a la pantalla de resultado o a la de error.
class HomePage extends StatefulWidget {
  final WeatherController controller;

  const HomePage({super.key, required this.controller});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();

  Future<void> _search() async {
    final city = _textController.text.trim();
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe una ciudad.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    await searchAndShowWeather(context, widget.controller, city);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SkyBackground(
      child: SafeArea(
        child: ResponsiveBody(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ListenableBuilder(
                listenable: widget.controller,
                builder: (context, _) {
                  final loading = widget.controller.loading;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLogo(),
                      const SizedBox(height: 16),
                      const Text(
                        'ClimaApp',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D3B66),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Consulta el clima de cualquier ciudad',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 36),
                      SearchField(
                        controller: _textController,
                        onSearch: _search,
                        enabled: !loading,
                      ),
                      if (loading) ...[
                        const SizedBox(height: 24),
                        const CircularProgressIndicator(),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}