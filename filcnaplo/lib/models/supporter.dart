class Supporter {
  String name;
  String amount;
  String platform;

  Supporter(this.name, this.amount, this.platform);

  factory Supporter.fromJson(Map json) {
    return Supporter(
      (json["name"] ?? "").trim(),
      json["amount"] ?? "",
      json["platform"] ?? "",
    );
  }
}

class Supporters {
  List<Supporter> top;
  List<Supporter> all;
  int progress;
  int max;

  Supporters({
    required this.top,
    required this.all,
    required this.progress,
    required this.max,
  });

  factory Supporters.fromJson(Map json) {
    return Supporters(
      max: (json["progress"] ?? {})["max"] ?? 1,
      progress: (json["progress"] ?? {})["value"] ?? 0,
      all: ((json["all"] ?? []) as List).cast<Map>().map((e) => Supporter.fromJson(e)).toList(),
      top: ((json["top"] ?? []) as List).cast<Map>().map((e) => Supporter.fromJson(e)).toList(),
    );
  }
}
