import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteDetailsPage extends StatelessWidget {
  NoteDetailsPage({super.key});

  final QuillController _quillController = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // title
            TextField(
              maxLines: null,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(color: themeColors.secondary)),
            ),

            // last modified
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Last Modified',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '24 October 2024, 09:22 PM',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            // created at
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Created At',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '24 October 2024, 09:22 PM',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            // tags
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        'Tags',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {},
                        child: Icon(Icons.add_rounded),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'No tags added',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            Divider(),

            Expanded(
              child: QuillEditor.basic(
                controller: _quillController,
                configurations: const QuillEditorConfigurations(
                  placeholder: 'Note here...',
                  expands: true,
                ),
              ),
            ),
            Container(
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
                controller: _quillController,
                configurations: QuillSimpleToolbarConfigurations(
                  multiRowsDisplay: false,
                  color: themeColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
