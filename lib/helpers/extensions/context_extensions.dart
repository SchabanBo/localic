import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  Size get mediaQuerySize => MediaQuery.of(this).size;

  double get height => mediaQuerySize.height;

  double get width => mediaQuerySize.width;

  ThemeData get theme => Theme.of(this);

  Color get primaryColor => theme.colorScheme.primary;

  Color get secondaryColor => theme.colorScheme.secondary;

  bool get isDarkMode => (theme.brightness == Brightness.dark);

  TextTheme get textTheme => Theme.of(this).textTheme;

  EdgeInsets get mediaQueryPadding => MediaQuery.of(this).padding;
}
