import 'package:flutter/material.dart';

class AppColors {
  static const Color icon = Colors.white;
  static const Color border = Color(0xFF202020);
  static const Color item = Color(0xFF050505);
  static const Color node = Color(0xFF101010);
  static const Color drag = Color(0xFF101010);
  static const Color secondary = Color(0xffB7B327);
  static const Color primary = Colors.amber;
}

const animationDuration = Duration(milliseconds: 500);

final dragContainer = Container(height: 2, color: AppColors.primary);
