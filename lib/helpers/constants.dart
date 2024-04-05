import 'package:flutter/material.dart';

class AppColors {
  static const Color icon = Colors.white;
  static const Color background = Color(0xFF111217);
  static const Color border = Color(0xFF0c0c0f);
  static const Color item = Color(0xFF15151a);
  static const Color node = Color(0xFF202127);
  static const Color drag = Color(0xFF101010);
  static const Color secondary = Color(0xffB7B327);
  static const Color primary = Color(0xFFe89f23);
}

const animationDuration = Duration(milliseconds: 500);

final dragContainer = Container(height: 2, color: AppColors.primary);
