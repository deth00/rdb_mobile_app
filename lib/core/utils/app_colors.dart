// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AppColors {
  static final Color color1 = Color.fromARGB(255, 0, 147, 69);
  static final Color color2 = Color.fromARGB(255, 0, 67, 76);
  static final Color bgColor2 = Color.fromARGB(255, 247, 241, 217);

  static final LinearGradient main = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [color1, color2],
  );
}
