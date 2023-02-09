import 'dart:convert';
import 'dart:io';

import 'package:arb_management/core/utils.dart';
import 'package:arb_management/features/arb_editor/presentation/widgets/custom_editable.dart';
import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final arbEditorProvider = ChangeNotifierProvider<ArbEditorProvider>((ref) {
  return ArbEditorProvider();
});

class ArbEditorProvider extends ChangeNotifier {
  ArbEditorProvider();
  final editableKey = GlobalKey<EditableState>();

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
    editableKey.currentState!.createRow();
  }

  saveRow({required dynamic row}) {
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

    String? outputFile =
        await _saveFileAndGetDirectory(fileName: '${pages.keys.first}.arb');
    if (outputFile == null) {
      return;
    }
    for (var pageKey in pages.keys) {
      final removed = outputFile.split(Platform.pathSeparator).removeLast();
      final path = outputFile.replaceAll(removed, '');
      File returnedFile = File('$path$pageKey.arb');
      if (await returnedFile.exists()) {
        await returnedFile.delete();
      }
      await returnedFile.create();
      await returnedFile.writeAsString('${pages[pageKey]}');
    }
  }

  Future<String?> _saveFileAndGetDirectory({required String fileName}) async {
    return await FilePicker.platform.saveFile(
        dialogTitle: 'Save Your File to desired location',
        allowedExtensions: [fileName.split('.').last],
        type: FileType.custom,
        fileName: fileName);
  }

  importFile() async {
    FilePickerResult? filePickerResult = await _pickFile();
    if (filePickerResult != null) {
      rows.clear();
      headers.clear();
      headers.add(_headerInit);
      for (var platformFile in filePickerResult.files) {
        final file = File(platformFile.path!);
        final content = await file.readAsString();
        final Map decodedContent = jsonDecode(content);
        final columnName = platformFile.path!
            .split(Platform.pathSeparator)
            .last
            .split('.')
            .first;

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

  exportAsExcelSheet() async {
    Excel excel = Excel.createExcel();
    Sheet sheetObject = excel['translations'];
    List<String> headerRow = [];
    List<List<String>> excelRows = [];
    for (Map header in headers) {
      headerRow.add(header['key']);
    }
    for (Map row in rows) {
      final List<String> excelRow = [];
      for (var rowValue in row.values) {
        excelRow.add(rowValue);
      }
      excelRows.add(excelRow);
    }

    sheetObject.appendRow(headerRow);
    for (var row in excelRows) {
      sheetObject.appendRow(row);
    }
    const excelSheetName = "arb_translations.xlsx";

    final List<int>? fileBytes = excel.save(fileName: excelSheetName);
    if (fileBytes == null) {
      return;
    }
    String? fileDirectory =
        await _saveFileAndGetDirectory(fileName: excelSheetName);
    if (fileDirectory == null) {
      return;
    }
    final outputFile = File(fileDirectory);
    outputFile
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);
  }

  importExcelSheet() async {
    final FilePickerResult? filePickerResult = await _pickFile(
      extension: ['xlsx', 'xls'],
      isMulti: false,
    );
    if (filePickerResult?.files.first.path != null) {
      var bytes = File(filePickerResult!.files.first.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      Sheet? table = excel.tables.values
          .firstWhereOrNull((element) => element.rows.isNotEmpty);
      if (table == null) {
        Utils.showErrorToast('Can\'nt Find App Translation Schema');
        return;
      }
      headers.clear();
      rows.clear();
      for (var headerTitle in table.rows.first) {
        final value = (headerTitle!.value as SharedString).toString();

        headers.add({
          'key': value,
          'title': value,
        });
      }
      final finalExcelRows = table.rows..removeAt(0);

      for (List<Data?> excelRow in finalExcelRows) {
        final Map<String, dynamic> currentRow = {};
        for (var i = 0; i < excelRow.length; i++) {
          final value = (excelRow[i]!.value as SharedString).toString();
          currentRow.putIfAbsent(headers[i]['key'], () => value);
        }
        rows.add(currentRow);
      }
    }
    notifyListeners();
  }

  Future<FilePickerResult?> _pickFile(
      {bool isMulti = true, List<String>? extension}) async {
    final FilePickerResult? filePickerResult =
        await FilePicker.platform.pickFiles(
      allowMultiple: isMulti,
      allowedExtensions: extension ?? ['arb'],
      type: FileType.custom,
    );
    return filePickerResult;
  }
}
