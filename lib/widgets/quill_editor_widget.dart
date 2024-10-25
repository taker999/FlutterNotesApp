import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuillEditorWidget extends StatelessWidget {
  const QuillEditorWidget({super.key, required this.quillController});

  final QuillController quillController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: QuillEditor.basic(
        controller: quillController,
        configurations: const QuillEditorConfigurations(
          placeholder: 'Note here...',
          expands: true,
        ),
      ),
    );
  }
}
