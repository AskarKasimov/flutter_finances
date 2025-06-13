import 'package:flutter/material.dart';

abstract interface class TabScreen implements Widget {
  String get tabLabel;

  IconData get tabIcon;

  AppBar get appBar;
}
