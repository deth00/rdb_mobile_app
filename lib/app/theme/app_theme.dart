import 'package:flutter/material.dart';
import 'package:moblie_banking/core/utils/app_colors.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(backgroundColor: Colors.indigo),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(backgroundColor: Colors.black87),
  );

  static final main = ThemeData(
    primaryColor: AppColors.color1,
    scaffoldBackgroundColor: Colors.white,
  );
}
