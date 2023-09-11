import 'package:flutter/material.dart';

const TextStyle statisticsStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

Color mainBgColor(BuildContext context) => Colors.teal;

const double inputTextSize = 14.0;
const FontWeight weight = FontWeight.normal;

const TextStyle lightInputText = TextStyle(
  color: Colors.white,
  fontSize: inputTextSize,
  fontWeight: weight,
);
const TextStyle darkInputText = TextStyle(
  color: Colors.black,
  fontSize: inputTextSize,
  fontWeight: weight,
);

final AppBarTheme appBarTheme = AppBarTheme(
  toolbarTextStyle: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ).bodyLarge,
  titleTextStyle: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ).titleLarge,
);
