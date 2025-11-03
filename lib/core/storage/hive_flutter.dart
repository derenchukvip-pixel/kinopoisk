import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox('cache');
  }

  Box get box => Hive.box('cache');

  void save(String key, dynamic value) => box.put(key, value);
  dynamic read(String key) => box.get(key);
}