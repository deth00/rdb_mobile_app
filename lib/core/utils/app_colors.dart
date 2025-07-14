// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AppColors {
  static final Color color1 = Color.fromARGB(255, 1, 189, 136);
  static final Color color2 = Color.fromARGB(255, 41, 92, 81);
  static final Color bgColor2 = Color.fromARGB(255, 247, 241, 217);

  static final LinearGradient main = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [color1, color2],
  );
}
