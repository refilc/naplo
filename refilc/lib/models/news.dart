class News {
  String id;
  String title;
  String content;
  String link;
  String openLabel;
  String platform;
  bool emergency;
  DateTime expireDate;
  List<String>? appVersions;
  String? specificAppId;
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
    this.appVersions,
    this.specificAppId,
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
      appVersions: json["app_versions"] != null
          ? List<String>.from(json["app_versions"])
          : null,
      specificAppId: json["specific_app_id"],
      json: json,
    );
  }
}
