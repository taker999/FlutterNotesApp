class Note {
  Note({
    this.id,
    required this.title,
    required this.content,
    required this.contentJson,
    required this.dateCreated,
    required this.dateModified,
    this.tags,
  });

  final int? id;
  final String? title;
  final String? content;
  final String contentJson;
  final int dateCreated;
  final int dateModified;
  List<String>? tags;

  // Copy method
  Note copyWith({
    int? id,
    String? title,
    String? content,
    String? contentJson,
    int? dateCreated,
    int? dateModified,
    List<String>? tags,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      contentJson: contentJson ?? this.contentJson,
      dateCreated: dateCreated ?? this.dateCreated,
      dateModified: dateModified ?? this.dateModified,
      tags: tags ?? this.tags,
    );
  }
}