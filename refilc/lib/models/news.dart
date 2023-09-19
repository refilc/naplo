class News {
  String id;
  String title;
  String content;
  String link;
  String openLabel;
  String platform;
  bool emergency;
  DateTime expireDate;
  Map? json;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.link,
    required this.openLabel,
    required this.platform,
    required this.emergency,
    required this.expireDate,
    this.json,
  });

  factory News.fromJson(Map json) {
    return News(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      link: json["link"] ?? "",
      openLabel: json["open_label"] ?? "",
      platform: json["platform"] ?? "",
      emergency: json["emergency"] ?? false,
      expireDate: DateTime.parse(json["expire_date"] ?? ''),
      json: json,
    );
  }
}
