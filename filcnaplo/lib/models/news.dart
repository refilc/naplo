class News {
  String title;
  String content;
  String link;
  String openLabel;
  String platform;
  bool emergency;
  Map? json;

  News({
    required this.title,
    required this.content,
    required this.link,
    required this.openLabel,
    required this.platform,
    required this.emergency,
    this.json,
  });

  factory News.fromJson(Map json) {
    return News(
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      link: json["link"] ?? "",
      openLabel: json["open_label"] ?? "",
      platform: json["platform"] ?? "",
      emergency: json["emergency"] ?? false,
      json: json,
    );
  }
}
