import 'package:flutter/material.dart';

import 'app_config.dart';

class AppThemeConfig {
  static ThemeData get customTheme {
    return ThemeData(
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConfig.materialMainBlueColor,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: AppConfig.materialMainBlueColor,
          side: const BorderSide(color: AppConfig.materialMainBlueColor)
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppConfig.materialMainBlueColor),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConfig.materialMainBlueColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: AppConfig.materialMainBlueColor,
        )
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(primary: AppConfig.materialMainBlueColor)
    );
  }
}
