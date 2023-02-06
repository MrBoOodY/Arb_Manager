import 'package:flutter/material.dart';

import 'core/app/app.dart';
import 'core/helper/hive_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.init();
  runApp(const MyApp());
}

