enum NoteType { text, image }

class SelfNote {
  String id;
  String? title;
  String content;
  NoteType noteType;

  Map? json;

  SelfNote({
    required this.id,
    this.title,
    required this.content,
    required this.noteType,
    this.json,
  });

  factory SelfNote.fromJson(Map json) {
    return SelfNote(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      noteType: json['note_type'] == 'image' ? NoteType.image : NoteType.text,
      json: json,
    );
  }

  get toJson => {
        'id': id,
        'title': title,
        'content': content,
        'note_type': noteType == NoteType.image ? 'image' : 'text',
      };
}
