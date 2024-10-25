import 'package:flutter/material.dart';

class AddTagDialog extends StatefulWidget {
  const AddTagDialog({
    super.key,
    this.tag,
  });
  final String? tag;

  @override
  State<AddTagDialog> createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  late final TextEditingController tagController;

  late final GlobalKey<FormFieldState> tagKey;

  @override
  void initState() {
    super.initState();

    tagController = TextEditingController(text: widget.tag);

    tagKey = GlobalKey();
  }

  @override
  void dispose() {
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Add tag',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 24),
        TextFormField(
          key: tagKey,
          controller: tagController,
          decoration: InputDecoration(
            hintText: 'Add tag (< 16 characters)',
          ),
          validator: (value) {
            if (value!.trim().isEmpty) {
              return 'No tags added';
            } else if (value.trim().length > 16) {
              return 'Tags should not be more than 16 characters';
            }
            return null;
          },
          onChanged: (newValue) {
            tagKey.currentState?.validate();
          },
          autofocus: true,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          child: const Text('Add'),
          onPressed: () {
            if (tagKey.currentState?.validate() ?? false) {
              Navigator.pop(context, tagController.text.trim());
            }
          },
        ),
      ],
    );
  }
}