import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../utils/ui_utils.dart';
import 'app_color.dart';

class AppTheme {
  AppTheme._();

  static lightTheme(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.primary500,
        primary: AppColor.primary500,
        brightness: Brightness.light,
      ),
      primaryColor: AppColor.primary500,
      scaffoldBackgroundColor: AppColor.backgroundColor,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      cardColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: AppColor.neutral200),
        labelStyle: const TextStyle(color: AppColor.neutral500),
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
      textTheme: GoogleFonts.nunitoTextTheme().apply(
        bodyColor: AppColor.neutral700,
      ),
      iconTheme: const IconThemeData(
        color: AppColor.neutral700,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColor.primary500,
        foregroundColor: Colors.white,
      ),
    );
  }

  static darkTheme(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.primary400,
        primary: AppColor.primary400,
        brightness: Brightness.dark,
      ),
      primaryColor: AppColor.primary400,
      scaffoldBackgroundColor: AppColor.darkBackgroundColor,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.neutral800,
        centerTitle: true,
      ),
      cardColor: AppColor.neutral800,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: AppColor.neutral200),
        labelStyle: const TextStyle(color: AppColor.neutral200),
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
        fillColor: AppColor.neutral800,
      ),
      textTheme: GoogleFonts.nunitoTextTheme().apply(
        bodyColor: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColor.primary400,
        foregroundColor: AppColor.neutral700,
        extendedTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      extensions: [
        const SkeletonizerConfigData().copyWith(
          containersColor: AppColor.neutral800,
        ),
      ],
    );
  }
}
