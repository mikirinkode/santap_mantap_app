
import 'package:flutter/material.dart';

import '../utils/ui_utils.dart';
import 'app_color.dart';

class AppTheme {
  AppTheme._();

  static lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primary500,
          primary: AppColor.primary500,
          brightness: Brightness.light),
      primaryColor: AppColor.primary500,
      scaffoldBackgroundColor: AppColor.backgroundColor,
      useMaterial3: true,
      appBarTheme:
          const AppBarTheme(backgroundColor: Colors.white, centerTitle: true),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(
          color: AppColor.neutral200
        ),
        labelStyle: const TextStyle(
          color: AppColor.neutral500
        ),
        border: OutlineInputBorder(
          borderRadius: UIUtils.borderRadiusAll(),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: UIUtils.borderRadiusAll(),
          borderSide: const BorderSide(
            color: AppColor.neutral200,
            width: 1.5,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
