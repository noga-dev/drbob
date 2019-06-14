import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const double inputTextSize = 14.0;
const FontWeight weight = FontWeight.normal;

const lightInputText = TextStyle(
  color: Colors.white,
  fontSize: inputTextSize,
  fontWeight: weight,
);
const darkInputText = TextStyle(
  color: Colors.black,
  fontSize: inputTextSize,
  fontWeight: weight,
);

const appBarTheme = AppBarTheme(
  textTheme: TextTheme(
    title: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
);
