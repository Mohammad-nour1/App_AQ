import 'package:flutter/material.dart';
import 'bootstrap/bootstrap.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
  runApp(const App());
}
