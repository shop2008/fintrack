import 'package:flutter/material.dart';
import 'package:fintrack/theme/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryTeal,
      scaffoldBackgroundColor: AppColors.backgroundWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryTeal,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.backgroundWhite,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        bodyText1: TextStyle(
          fontSize: 16,
          color: AppColors.textGrey,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: AppColors.secondaryCoral,
          onPrimary: AppColors.backgroundWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.accentBlue, width: 2),
        ),
      ),
    );
  }
}
