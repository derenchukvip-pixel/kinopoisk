import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:kinopoisk/core/storage/hive_flutter.dart';
import 'src/app_module.dart';
import 'src/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hive = HiveService();
  await hive.init();
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
