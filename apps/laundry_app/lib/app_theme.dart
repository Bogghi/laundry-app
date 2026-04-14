import 'package:flutter/material.dart';

class AppTheme {
  static final Color primaryBackgroundColor = Color.fromRGBO(248, 249, 250, 100);
  static final Color appbarSelectedColor = Color.fromRGBO(239, 246, 255, 100);
  static final Color headlineColor = Color.fromRGBO(25, 28, 29, 100);
  static final Color subHeadlineColor = Color.fromRGBO(113, 119, 130, 100);

  static final Color primaryColorTone1 = Color.fromRGBO(0, 73, 125, 100);

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: Color.fromRGBO(30, 58, 138, 100),
        secondary: Color.fromRGBO(83, 95, 112, 100),
        tertiary: Color.fromRGBO(33, 148, 243, 100)
      ),
      scaffoldBackgroundColor: AppTheme.primaryBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: AppTheme.primaryBackgroundColor,
      ),
    );
  }
}