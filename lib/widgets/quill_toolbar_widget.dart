import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuillToolbarWidget extends StatelessWidget {
  const QuillToolbarWidget({super.key, required this.themeColors, required this.quillController});

  final ColorScheme themeColors;
  final QuillController quillController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(
          color: themeColors.secondary,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: QuillSimpleToolbar(
        controller: quillController,
        configurations: QuillSimpleToolbarConfigurations(
          multiRowsDisplay: false,
          color: themeColors.primary,
        ),
      ),
    );
  }
}
