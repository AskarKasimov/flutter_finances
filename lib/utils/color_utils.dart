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
