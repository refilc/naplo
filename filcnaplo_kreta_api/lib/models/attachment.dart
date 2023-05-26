import 'package:file_picker/file_picker.dart';
import 'package:filcnaplo_kreta_api/client/api.dart';

class Attachment {
  Map? json;
  int id;
  PlatformFile? file;
  String name;
  String? fileId;
  String kretaFilePath;

  Attachment({
    required this.id,
    this.file,
    required this.name,
    this.fileId,
    required this.kretaFilePath,
    this.json,
  });

  factory Attachment.fromJson(Map json) {
    return Attachment(
      id: json["azonosito"],
      name: (json["fajlNev"] ?? "attachment").trim(),
      kretaFilePath: json["utvonal"] ?? "",
      json: json,
    );
  }

  String get downloadUrl => KretaAPI.downloadAttachment(id.toString());
  bool get isImage => name.endsWith(".jpg") || name.endsWith(".jpeg") || name.endsWith(".png");
}
