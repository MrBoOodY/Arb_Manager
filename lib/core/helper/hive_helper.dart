import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static init() async {
    await Hive.initFlutter();
    await Hive.openBox(_HiveKeys.directoryPath);
  }

  static getDirectoryPath() =>
      Hive.box(_HiveKeys.directoryPath).get(_HiveKeys.directoryPath);
  static setDirectoryPath(String directoryPath) =>
      Hive.box(_HiveKeys.directoryPath)
          .put(_HiveKeys.directoryPath, directoryPath);
}

class _HiveKeys {
  static String directoryPath = 'directoryPath';
}
