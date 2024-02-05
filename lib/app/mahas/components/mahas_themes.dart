import 'package:flutter/material.dart';

import '../mahas_colors.dart';

class MahasThemes {
  static const double borderRadius = 10;
  static const double cardelevation = 8;

  static ThemeData light = ThemeData(
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: MahasColors.backgroundColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(88, 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        backgroundColor: MahasColors.primary,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(88, 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: MahasColors.primary,
    ),
  );

  static InputDecoration? textFiendDecoration({
    hintText,
  }) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      hintText: hintText,
    );
  }

  static TextStyle muted = TextStyle(
    color: MahasColors.dark.withOpacity(.5),
    fontSize: 12,
  );

  static TextStyle link = const TextStyle(
    color: MahasColors.link,
    fontSize: 12,
  );

  static RoundedRectangleBorder cardBorderShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  );
}
