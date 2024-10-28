import 'package:flutter/material.dart';
import 'package:flutter_notes_app/databases/notes_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../databases/note_provider.dart';

class TagsListViewWidget extends ConsumerWidget {
  const TagsListViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(notesProvider.notifier).tags;

    return tags.isNotEmpty ? SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tags.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Chip(label: Text(tags[index])),
            );
          },
        ),
      ) : SizedBox.shrink();
  }
}
