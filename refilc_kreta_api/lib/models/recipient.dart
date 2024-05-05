class Recipient {
  Map? json;
  int id;
  String? studentId; // oktatasi azonosito
  int kretaId;
  String name;
  RecipientCategory? category;

  Recipient({
    required this.id,
    this.studentId,
    required this.name,
    required this.kretaId,
    this.category,
    this.json,
  });

  factory Recipient.fromJson(Map json) {
    return Recipient(
      id: json["azonosito"],
      name: json["nev"] ?? "",
      kretaId: json["kretaAzonosito"],
      category: json["tipus"] != null ? RecipientCategory.fromJson(json["tipus"]) : null,
      json: json,
    );
  }
}

class RecipientCategory {
  Map? json;
  int id;
  String code;
  String shortName;
  String name;
  String description;

  RecipientCategory({
    required this.id,
    required this.code,
    required this.shortName,
    required this.name,
    required this.description,
    this.json,
  });

  factory RecipientCategory.fromJson(Map json) {
    return RecipientCategory(
      id: json["azonosito"],
      code: json["kod"] ?? "",
      shortName: json["rovidNev"] ?? "",
      name: json["nev"] ?? "",
      description: json["leiras"] ?? "",
      json: json,
    );
  }
}
