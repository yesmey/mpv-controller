import 'package:flutter/material.dart';

class Constants {
  static const String appName = "MPV Controller";

  static const Color primary = Color(0xff37474f);
  static const Color accent = Color(0xffff6d00);
  static const Color background = Color(0xfff3f4f9);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: background,
    primaryColor: primary,
    accentColor: accent,
    cursorColor: accent,
    primaryTextTheme: Typography.whiteMountainView,
    accentTextTheme: Typography.blackMountainView,
    textTheme: Typography.whiteMountainView,
  );
}
