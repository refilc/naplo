import 'package:refilc/utils/format.dart';

class Teacher {
  String id;
  String name;
  String? renamedTo;

  bool get isRenamed => renamedTo != null;

  Teacher({required this.id, required this.name, this.renamedTo});

  factory Teacher.fromJson(Map json) {
    return Teacher(
      id: json["Uid"] ?? "",
      name: (json["Nev"] ?? "").trim(),
    );
  }

  factory Teacher.fromString(String string) {
    return Teacher(
      id: string.trim().replaceAll(' ', '').toLowerCase().specialChars(),
      name: string.trim(),
    );
  }

  @override
  bool operator ==(other) {
    if (other is! Teacher) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
