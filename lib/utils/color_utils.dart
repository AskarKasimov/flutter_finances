import 'package:flutter/material.dart';

Color generateLightColorFromId(int id) {
  return generateColorFromId(id).withValues(alpha: 0.2);
}

Color generateColorFromId(int id) {
  final colors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.red,
  ];
  return colors[id % colors.length];
}

Color lighten(Color color, [double amount = 0.2]) {
  final hsl = HSLColor.fromColor(color);
  final lightened = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return lightened.toColor();
}
