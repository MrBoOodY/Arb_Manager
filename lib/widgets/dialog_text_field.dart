import 'package:flutter/material.dart';

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
