import 'dart:io';

import 'package:arb_management/core/core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final arbEditorProvider = ChangeNotifierProvider<ArbEditorProvider>((ref) {
  return ArbEditorProvider();
});

class ArbEditorProvider extends ChangeNotifier {
  ArbEditorProvider();
  final List<Map<String, dynamic>> headers = [
    {
      "title": 'Key',
      'key': 'key',
    },
  ];
  final List<Map<String, dynamic>> rows = [];
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  addColumn({required String title}) {
    headers.add({
      "title": title,
      "key": title,
    });
    notifyListeners();
  }

  addRow() {
    rows.add({'key': 'key_name'});
    notifyListeners();
  }

  saveRow({required dynamic row}) {
    if (row is! Map) {
      return;
    }
    for (var key in row.keys) {
      if (key != 'row') {
        rows[row['row']][key] = row[key];
      }
    }
  }

  saveFiles() async {
    final Map<String, Map<String, String>> pages = {};

    for (var file in headers) {
      if (file['key'] != 'key') {
        Map<String, String> myRows = {};

        for (var row in rows) {
          myRows.putIfAbsent(row['key'], () => row[file['key']] ?? '');
        }
        pages.putIfAbsent(file['key'], () => myRows);
      }
    }

    if (HiveHelper.getDirectoryPath() == null) {
      String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Your File to desired location',
          fileName: '${pages.keys.first}.arb');
      if (outputFile == null) {
        return;
      }
      HiveHelper.setDirectoryPath(
          outputFile.replaceAll('${pages.keys.first}.arb', ''));
    }
    print(HiveHelper.getDirectoryPath());
    for (var pageKey in pages.keys) {
      File returnedFile = File('${HiveHelper.getDirectoryPath()}$pageKey.arb');
      if (await returnedFile.exists()) {
        await returnedFile.delete();
      }
      await returnedFile.create();
      await returnedFile.writeAsString('${pages[pageKey]}');
    }
  }
}
