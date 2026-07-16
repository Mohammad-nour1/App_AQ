import 'package:app_aq_2/bootstrap/bootstrap.dart';
import 'package:app_aq_2/app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
  // Use `App` which provides `HomeCubit` above the MaterialApp
  runApp(const App());
}
