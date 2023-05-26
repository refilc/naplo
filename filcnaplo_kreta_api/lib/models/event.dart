class Event {
  Map? json;
  String id;
  DateTime start;
  DateTime end;
  String title;
  String content;

  Event({
    required this.id,
    required this.start,
    required this.end,
    this.title = "",
    this.content = "",
    this.json,
  });

  factory Event.fromJson(Map json) {
    return Event(
      id: json["Uid"] ?? "",
      start: json["ErvenyessegKezdete"] != null ? DateTime.parse(json["ErvenyessegKezdete"]).toLocal() : DateTime(0),
      end: json["ErvenyessegVege"] != null ? DateTime.parse(json["ErvenyessegVege"]).toLocal() : DateTime(0),
      title: json["Cim"] ?? "",
      content: json["Tartalom"] != null ? json["Tartalom"].replaceAll("\r", "") : "",
      json: json,
    );
  }
}
