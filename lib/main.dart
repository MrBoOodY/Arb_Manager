import 'package:arb_management/core/core.dart';
import 'package:arb_management/features/arb_editor/presentation/pages/arb_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Arb Editor',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ArbEditorPage(),
      ),
    );
  }
}
