enum DonationType { once, monthly }

class Supporter {
  final String avatar;
  final String name;
  final String comment;
  final int price;
  final DonationType type;

  const Supporter({required this.avatar, required this.name, this.comment = "", this.price = 0, this.type = DonationType.once});

  factory Supporter.fromJson(Map json) {
    return Supporter(
      avatar: json["avatar"] ?? "",
      name: json["name"] ?? "Unknown",
      comment: json["comment"] ?? "",
      price: json["price"].toInt() ?? 0,
      type: DonationType.values.asNameMap()[json["type"] ?? "once"] ?? DonationType.once,
    );
  }
}

class Supporters {
  final double progress;
  final double max;
  final String description;
  final List<Supporter> github;
  final List<Supporter> patreon;

  Supporters({
    required this.progress,
    required this.max,
    required this.description,
    required this.github,
    required this.patreon,
  });

  factory Supporters.fromJson(Map json) {
    return Supporters(
      progress: json["percentage"].toDouble() ?? 100.0,
      max: json["target"].toDouble() ?? 1.0,
      description: json["description"] ?? "",
      github: json["sponsors"]["github"].map((e) => Supporter.fromJson(e)).cast<Supporter>().toList(),
      patreon: json["sponsors"]["patreon"].map((e) => Supporter.fromJson(e)).cast<Supporter>().toList(),
    );
  }
}
