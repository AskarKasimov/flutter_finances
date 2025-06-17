import 'package:flutter/material.dart';

abstract interface class TabScreen implements Widget {
  String get routePath;

  String get tabLabel;

  IconData get tabIcon;

  AppBar get appBar;

  Widget? get floatingActionButton => null;
}
