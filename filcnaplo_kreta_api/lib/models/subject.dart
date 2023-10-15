import 'category.dart';

class GradeSubject {
  String id;
  Category category;
  String name;
  String? renamedTo;

  bool get isRenamed => renamedTo != null;

  GradeSubject({
    required this.id,
    required this.category,
    required this.name,
    this.renamedTo,
  });

  factory GradeSubject.fromJson(Map json) {
    final id = json["Uid"] ?? "";
    return GradeSubject(
      id: id,
      category: Category.fromJson(json["Kategoria"] ?? {}),
      name: (json["Nev"] ?? "").trim(),
    );
  }

  @override
  bool operator ==(other) {
    if (other is! GradeSubject) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
