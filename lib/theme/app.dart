import 'package:flutter/material.dart';
import 'package:culinote_flutter/theme/colors.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
    useMaterial3: true,
      colorSchemeSeed: AppColors.primaryColor,
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStatePropertyAll(0)
      )
    ),
  );
}