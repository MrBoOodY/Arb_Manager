import 'dart:convert';
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
  static const _headerInit = {
    "title": 'Key',
    'key': 'key',
  };
  final List<Map<String, dynamic>> headers = [
    _headerInit,
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
    rows.add({'key': 'key_name${rows.length + 1}'});
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
          myRows.putIfAbsent(
              '"${row['key']}"', () => '"${row[file['key']] ?? ''}"');
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
    for (var pageKey in pages.keys) {
      File returnedFile = File('${HiveHelper.getDirectoryPath()}$pageKey.arb');
      if (await returnedFile.exists()) {
        await returnedFile.delete();
      }
      await returnedFile.create();
      await returnedFile.writeAsString('${pages[pageKey]}');
    }
  }

  importFile() async {
    final FilePickerResult? filePickerResult =
        await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowedExtensions: ['arb'],
      type: FileType.custom,
    );
    if (filePickerResult != null) {
      rows.clear();
      headers.clear();
      headers.add(_headerInit);
      for (var platformFile in filePickerResult.files) {
        final file = File(platformFile.path!);
        final content = await file.readAsString();
        final Map decodedContent = jsonDecode(content);
        final columnName = platformFile.path!.split('/').last.split('.').first;

        headers.add({
          'key': columnName,
          'title': columnName,
        });

        for (var key in decodedContent.keys) {
          final int index = rows.indexWhere((element) => element['key'] == key);
          if (index == -1) {
            rows.add({'key': key, columnName: decodedContent[key]});
          } else {
            rows[index][columnName] = decodedContent[key];
          }
        }
      }
      notifyListeners();
    }
  }
}
