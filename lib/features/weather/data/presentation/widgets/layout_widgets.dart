import 'package:flutter/material.dart';

/// Fondo azul cielo con degradado, usado en todas las pantallas.
class SkyBackground extends StatelessWidget {
  final Widget child;

  const SkyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFBFE1FB), Color(0xFFE8F4FD), Color(0xFFF7FBFF)],
        ),
      ),
      child: child,
    );
  }
}

/// Limita el ancho del contenido para que en Chrome se vea como en un celular.
class ResponsiveBody extends StatelessWidget {
  final Widget child;

  const ResponsiveBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: child,
      ),
    );
  }
}

/// Tarjeta blanca con esquinas redondeadas y sombra suave.
class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}