import 'package:flutter/material.dart';

Color generateColorFromId(int id) {
  final colors = [
    Colors.green,
    Colors.yellow,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.red,
  ];
  return colors[id % colors.length];
}
