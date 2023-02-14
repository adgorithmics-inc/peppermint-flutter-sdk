import 'dart:math';

import 'package:flutter/material.dart';

/// Frame scanner view widget for NFTScanner
class InvisibleSquare extends StatelessWidget {
  final double size;
  final double borderRadius;
  final Color color;
  final double strokeWidth;

  const InvisibleSquare({
    this.size = 200,
    this.borderRadius = 10,
    this.color = Colors.green,
    this.strokeWidth = 16,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _InvisibleSquarePainter(
        borderRadius: borderRadius,
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _InvisibleSquarePainter extends CustomPainter {
  final double borderRadius;
  final Color color;
  final double strokeWidth;

  _InvisibleSquarePainter({
    this.borderRadius = 10,
    this.color = Colors.green,
    this.strokeWidth = 16,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    double radius = 12;

    final path = Path()
      ..addArc(
        Rect.fromLTWH(0, 0, borderRadius * radius, borderRadius * radius),
        -pi / 2,
        -pi / 2,
      )
      ..addArc(
        Rect.fromLTWH(size.width - borderRadius * radius, 0,
            borderRadius * radius, borderRadius * radius),
        -pi / 2,
        pi / 2,
      )
      ..addArc(
        Rect.fromLTWH(
            size.width - borderRadius * radius,
            size.height - borderRadius * radius,
            borderRadius * radius,
            borderRadius * radius),
        pi / 2,
        -pi / 2,
      )
      ..addArc(
        Rect.fromLTWH(0, size.height - borderRadius * radius,
            borderRadius * radius, borderRadius * radius),
        pi / 2,
        pi / 2,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
