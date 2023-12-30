class SelfNote {
  String id;
  String? title;
  String content;
  Map? json;

  SelfNote({
    required this.id,
    this.title,
    required this.content,
    this.json,
  });

  factory SelfNote.fromJson(Map json) {
    return SelfNote(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      json: json,
    );
  }

  get toJson => {
        'id': id,
        'title': title,
        'content': content,
      };
}
