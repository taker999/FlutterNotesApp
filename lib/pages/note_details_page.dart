import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../databases/note_provider.dart';
import '../models/note.dart';
import '../utils/date_format.dart';
import '../widgets/add_tag_dialog.dart';
import '../widgets/quill_editor_widget.dart';
import '../widgets/quill_toolbar_widget.dart';
import '../widgets/tag_widget.dart';

class NoteDetailsPage extends ConsumerStatefulWidget {
  const NoteDetailsPage({super.key, this.note});

  final Note? note;

  @override
  ConsumerState<NoteDetailsPage> createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends ConsumerState<NoteDetailsPage> {
  TextEditingController? _titleController;

  final QuillController _quillController = QuillController.basic();
  List<String> tags = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    if (widget.note != null) {
      _quillController.document =
          Document.fromJson(jsonDecode(widget.note!.contentJson));
    }
    tags = widget.note?.tags ?? [];
  }

  @override
  void dispose() {
    super.dispose();
    _titleController?.dispose();
    _quillController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final note = ref.watch(noteProvider);
    final themeColors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (widget.note != null) {
                  ref.read(noteProvider.notifier).updateNote(
                      widget.note!.id as int,
                      _titleController!.text,
                      tags,
                      _quillController.document);
                } else {
                  ref.read(noteProvider.notifier).addNote(
                      _titleController!.text, tags, _quillController.document);
                }
              },
              icon: Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // title
            TextField(
              controller: _titleController,
              maxLines: null,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(color: themeColors.secondary)),
            ),

            // last modified
            if (widget.note != null) ...[
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
                      formatMicrosecondsToDate(widget.note!.dateModified),
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
                      formatMicrosecondsToDate(widget.note!.dateCreated),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],

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
                        child: InkWell(
                            onTap: () async {
                              final tag = await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  backgroundColor: themeColors.secondary,
                                  content: AddTagDialog(),
                                ),
                              );
                              if (tag != null && tag.isNotEmpty) {
                                tags.add(tag);
                                ref.read(noteProvider.notifier).addTag(tag);
                              }
                            },
                            child: Icon(Icons.add_rounded)),
                      ),
                    ],
                  ),
                ),
                if (note.tags != null && tags.isNotEmpty)
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tags.length,
                        itemBuilder: (context, index) => TagWidget(
                          tag: tags[index],
                          themeColors: themeColors,
                        ),
                      ),
                    ),
                  ),
                if (tags.isEmpty)
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

            QuillEditorWidget(
              quillController: _quillController,
            ),
            QuillToolbarWidget(
              themeColors: themeColors,
              quillController: _quillController,
            ),
          ],
        ),
      ),
    );
  }
}
