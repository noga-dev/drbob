import 'package:flutter/material.dart';

import 'wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // LocaleSettings.useDeviceLocale();

  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //       statusBarBrightness: Brightness.dark,
  //       statusBarColor: Colors.transparent,
  //       statusBarIconBrightness: Brightness.dark
  //       ),
  // );

  runApp(const AppWrapper());
}
