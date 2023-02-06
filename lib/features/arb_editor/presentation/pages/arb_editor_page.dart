import 'package:arb_management/features/arb_editor/domain/entities/menu_entry.dart';
import 'package:arb_management/features/arb_editor/presentation/provider/arb_editor_provider.dart';
import 'package:arb_management/features/arb_editor/presentation/widgets/custom_editable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArbEditorPage extends ConsumerStatefulWidget {
  const ArbEditorPage({super.key});

  @override
  ConsumerState<ArbEditorPage> createState() => _ArbEditorPageState();
}

class _ArbEditorPageState extends ConsumerState<ArbEditorPage> {
  late ArbEditorProvider controller = ref.read(arbEditorProvider);
  ShortcutRegistryEntry? _shortcutsEntry;
  List<MenuEntry> result = [];
  List<MenuEntry> _getMenus() {
    result = <MenuEntry>[
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
            shortcut:
                const SingleActivator(LogicalKeyboardKey.keyS, control: true),
            label: 'Save Files',
            onPressed: () async {
              controller.saveFiles();
            },
          ),
        ],
      ),
    ];
    // (Re-)register the shortcuts with the ShortcutRegistry so that they are
    // available to the entire application, and update them if they've changed.
    _shortcutsEntry?.dispose();
    _shortcutsEntry =
        ShortcutRegistry.of(context).addAll(MenuEntry.shortcuts(result));
    return result;
  }

  @override
  void dispose() {
    _shortcutsEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArbEditorProvider controller = ref.watch(arbEditorProvider);
    return Scaffold(
      body: Editable(
        rows: controller.rows,
        columns: controller.headers,
        onRowSaved: (value) {
          controller.saveRow(row: value);
        },
      ),
      floatingActionButton: MenuBar(
        children: MenuEntry.build(_getMenus()),
        // child: Icon(Icons.add),
      ),
    );
  }
}

Future<String?> showCustomDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) {
      final TextEditingController controller = TextEditingController();
      return AlertDialog(
        actions: [
          MaterialButton(
            child: const Text('Add'),
            onPressed: () {
              Navigator.pop(context, controller.text);
            },
          ),
        ],
        content: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Enter Column Name',
          ),
        ),
      );
    },
  );
}
