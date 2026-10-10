import 'package:flutter/material.dart';

import 'package:app/core/constants/api_constants.dart';

/// Icono del clima. Usa la imagen oficial de OpenWeatherMap (el código viene
/// en weather[0].icon) y, si no se puede descargar, un icono equivalente.
class WeatherIcon extends StatelessWidget {
  final String code;
  final double size;

  const WeatherIcon({super.key, required this.code, this.size = 90});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      '${ApiConstants.iconBaseUrl}/$code@2x.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => SizedBox(
        width: size,
        height: size,
        child: Icon(_fallbackIcon(code), size: size * 0.8, color: _color(code)),
      ),
    );
  }

  static String _group(String code) =>
      code.length >= 2 ? code.substring(0, 2) : code;

  static IconData _fallbackIcon(String code) {
    switch (_group(code)) {
      case '01':
        return Icons.wb_sunny;
      case '02':
      case '03':
      case '04':
        return Icons.cloud;
      case '09':
      case '10':
        return Icons.water_drop;
      case '11':
        return Icons.thunderstorm;
      case '13':
        return Icons.ac_unit;
      case '50':
        return Icons.blur_on;
      default:
        return Icons.cloud;
    }
  }

  static Color _color(String code) {
    switch (_group(code)) {
      case '01':
        return const Color(0xFFFFA726);
      case '09':
      case '10':
      case '11':
        return const Color(0xFF42A5F5);
      case '13':
        return const Color(0xFF4FC3F7);
      default:
        return const Color(0xFF78909C);
    }
  }
}