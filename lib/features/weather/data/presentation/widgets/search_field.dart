import 'package:flutter/material.dart';

/// Logo de la app: sol detrás de una nube.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 120,
      height: 96,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 8,
            child: Icon(Icons.wb_sunny, size: 58, color: Color(0xFFFFB300)),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Icon(Icons.cloud, size: 88, color: Color(0xFF4FC3F7)),
          ),
        ],
      ),
    );
  }
}

/// Campo de texto + botón "Consultar" (Pantalla 1 – Inicio).
class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final bool enabled;

  const SearchField({
    super.key,
    required this.controller,
    required this.onSearch,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          enabled: enabled,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Ingresa una ciudad...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: (_) => onSearch(),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: enabled ? onSearch : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Consultar'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              backgroundColor: const Color(0xFF1E88E5),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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