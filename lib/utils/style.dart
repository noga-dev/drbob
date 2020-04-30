import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const TextStyle statisticsStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

Color mainBgColor(BuildContext context) => Colors.teal[
              Theme.of(context).brightness == Brightness.dark ? 800 : 400];

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

const AppBarTheme appBarTheme = AppBarTheme(
  textTheme: TextTheme(
    headline6: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
);
