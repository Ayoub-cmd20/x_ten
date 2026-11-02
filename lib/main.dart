import 'package:flutter/material.dart';
import 'package:x_ten/app.dart';
import 'package:x_ten/core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const XTenApp());
}
