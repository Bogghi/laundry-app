import 'package:flutter/material.dart';

class AppTheme {
  static final Color primaryBackgroundColor = Color.fromRGBO(248, 249, 250, 1.0);
  static final Color primaryBackgroundColorShade1 = Color.fromRGBO(209, 228, 255, 1.0);
  static final Color primaryBackgroundColorShade2 = Color.fromRGBO(234, 241, 255, 1.0);
  static final Color appbarSelectedColor = Color.fromRGBO(239, 246, 255, 1.0);
  static final Color headlineColor = Color.fromRGBO(25, 28, 29, 1.0);
  static final Color subHeadlineColor = Color.fromRGBO(113, 119, 130, 1.0);

  static final Color primaryColorTone1 = Color.fromRGBO(0, 73, 125, 1.0);

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: Color.fromRGBO(30, 58, 138, 1.0),
        secondary: Color.fromRGBO(83, 95, 112, 1.0),
        tertiary: Color.fromRGBO(33, 148, 243, 1.0)
      ),
      scaffoldBackgroundColor: AppTheme.primaryBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: AppTheme.primaryBackgroundColor,
      ),
    );
  }
}