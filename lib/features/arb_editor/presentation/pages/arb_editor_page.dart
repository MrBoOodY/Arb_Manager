import 'package:arb_management/features/arb_editor/domain/entities/menu_entry.dart';
import 'package:arb_management/features/arb_editor/presentation/provider/arb_editor_provider.dart';
import 'package:arb_management/features/arb_editor/presentation/widgets/custom_editable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../widgets/dialog_text_field.dart';

class ArbEditorPage extends ConsumerStatefulWidget {
  const ArbEditorPage({super.key});

  @override
  ConsumerState<ArbEditorPage> createState() => _ArbEditorPageState();
}

class _ArbEditorPageState extends ConsumerState<ArbEditorPage> {
  late ArbEditorProvider controller = ref.read(arbEditorProvider);
  ShortcutRegistryEntry? _shortcutsEntry;
  late List<MenuEntry> result = <MenuEntry>[
    MenuEntry(
      label: 'Options',
      menuChildren: <MenuEntry>[
        MenuEntry(
          shortcut:
              const SingleActivator(LogicalKeyboardKey.keyA, control: true),
          label: 'Add Language',
          onPressed: () async {
            final result = await showCustomDialog(context);
            if (result != null) {
              controller.addColumn(title: result);
            }
          },
        ),
        MenuEntry(
          shortcut: const SingleActivator(LogicalKeyboardKey.keyA,
              control: true, shift: true, includeRepeats: false),
          label: 'Add Key',
          onPressed: () async {
            controller.addRow();
          },
        ),
        MenuEntry(
          shortcut: const SingleActivator(LogicalKeyboardKey.keyS,
              control: true, shift: true),
          label: 'Save As Excel',
          onPressed: () async {
            controller.exportAsExcelSheet();
          },
        ),
        MenuEntry(
          shortcut:
              const SingleActivator(LogicalKeyboardKey.keyS, control: true),
          label: 'Save Files',
          onPressed: () async {
            controller.saveFiles();
          },
        ),
        MenuEntry(
          shortcut: const SingleActivator(LogicalKeyboardKey.keyO,
              control: true, shift: true),
          label: 'Import Excel Sheet',
          onPressed: () async {
            controller.importExcelSheet();
          },
        ),
        MenuEntry(
          shortcut:
              const SingleActivator(LogicalKeyboardKey.keyO, control: true),
          label: 'Import Files',
          onPressed: () async {
            controller.importFile();
          },
        ),
      ],
    ),
  ];

  @override
  void didChangeDependencies() {
    _shortcutsEntry =
        ShortcutRegistry.of(context).addAll(MenuEntry.shortcuts(result));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _shortcutsEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ArbEditorProvider controller = ref.watch(arbEditorProvider);

    return Scaffold(
      body: Editable(
        key: UniqueKey(),
        borderColor: Colors.grey.shade300,
        borderWidth: 0.25,
        columnRatio: 0.3,
        rows: controller.rows,
        columns: controller.headers,
        onRowSaved: (value) {
          controller.saveRow(row: value);
        },
      ),
      floatingActionButton: MenuBar(
        children: MenuEntry.build(result),
        // child: Icon(Icons.add),
      ),
    );
  }
}
