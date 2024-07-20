import 'package:flutter/material.dart';

import 'legacy/wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AppWrapper());
}
