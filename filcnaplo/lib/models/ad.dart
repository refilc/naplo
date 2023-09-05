class Ad {
  String title;
  String description;
  String author;
  Uri? logoUrl;
  bool overridePremium;
  DateTime date;
  Uri launchUrl;

  Ad({
    required this.title,
    required this.description,
    required this.author,
    this.logoUrl,
    this.overridePremium = false,
    required this.date,
    required this.launchUrl,
  });

  factory Ad.fromJson(Map json) {
    print(json);
    return Ad(
      title: json['title'] ?? 'Ad',
      description: json['description'] ?? '',
      author: json['author'] ?? 'reFilc',
      logoUrl: json['logo_url'] != null ? Uri.parse(json['logo_url']) : null,
      overridePremium: json['override_premium'] ?? false,
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      launchUrl: Uri.parse(json['launch_url'] ?? 'https://refilc.hu'),
    );
  }
}
