import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'wrapper.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // statusBarBrightness: Brightness.dark,
      // statusBarColor: Colors.transparent,
      // statusBarIconBrightness: Brightness.dark
    ),
  );
  runApp(AppWrapper());
}
