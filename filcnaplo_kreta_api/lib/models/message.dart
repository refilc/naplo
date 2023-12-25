import 'recipient.dart';
import 'attachment.dart';

class Message {
  Map? json;
  int id;
  int? replyId;
  int messageId;
  int? conversationId;
  bool seen;
  bool deleted;
  DateTime date;
  String author;
  String content;
  String subject;
  MessageType? type;
  List<Recipient> recipients;
  List<Attachment> attachments;
  bool isSeen;

  Message({
    required this.id,
    required this.messageId,
    required this.seen,
    required this.deleted,
    required this.date,
    required this.author,
    required this.content,
    required this.subject,
    this.type,
    required this.recipients,
    required this.attachments,
    this.replyId,
    this.conversationId,
    this.json,
    this.isSeen = false,
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Message.fromJson(Map json, {MessageType? forceType}) {
    Map message = json["uzenet"];

    MessageType? type = forceType;
    if (type == null) {
      switch (json["tipus"]["kod"]) {
        case "BEERKEZETT":
          type = MessageType.inbox;
          break;
        case "ELKULDOTT":
          type = MessageType.sent;
          break;
        case "PISZKOZAT":
          type = MessageType.draft;
          break;
      }

      if (json["isToroltElem"] == true) type = MessageType.trash;
    }

    return Message(
      id: json["azonosito"],
      messageId: message["azonosito"],
      seen: json["isElolvasva"] ?? false,
      deleted: json["isToroltElem"] ?? false,
      date: message["kuldesDatum"] != null
          ? DateTime.parse(message["kuldesDatum"]).toLocal()
          : DateTime(0),
      author: (message["feladoNev"] ?? "").trim(),
      content: message["szoveg"].replaceAll("\r", "") ?? "",
      subject: message["targy"] ?? "",
      type: type,
      recipients: (message["cimzettLista"] as List)
          .cast<Map>()
          .map((Map recipient) => Recipient.fromJson(recipient))
          .toList(),
      attachments: (message["csatolmanyok"] as List)
          .cast<Map>()
          .map((Map attachment) => Attachment.fromJson(attachment))
          .toList(),
      replyId: message["elozoUzenetAzonosito"],
      conversationId: message["beszelgetesAzonosito"],
      json: json,
      isSeen: false,
    );
  }

  bool compareTo(dynamic other) {
    if (runtimeType != other.runtimeType) return false;

    return id == other.id && seen == other.seen && deleted == other.deleted;
  }
}

enum MessageType { inbox, sent, trash, draft }

class Conversation {
  int id;
  late List<Message> _messages;
  List<Message> get messages => _messages;

  Conversation({required this.id, List<Message> messages = const []}) {
    _messages = List.from(messages);
  }

  void sort() => _messages.sort((a, b) => -a.date.compareTo(b.date));
  void add(Message message) => _messages.add(message);

  Message get newest => _messages.first;
}

// sendable message object and it's things
class SendMessage {
  Map? json;
  int id;
  int lastMessageId;
  String? subject;
  String text;
  DateTime sentDate;
  String senderRank;
  String senderName;
  List<Attachment>? attachments;
  List<SendRecipient> recipients;

  SendMessage({
    required this.id,
    required this.lastMessageId,
    this.subject,
    required this.text,
    required this.sentDate,
    required this.senderRank,
    required this.senderName,
    this.attachments,
    required this.recipients,
  });
}

class SendRecipient {
  Map? json;
  int? id;
  int? kretaId;
  String? name;
  SendRecipientType type;

  SendRecipient({
    required this.id,
    required this.kretaId,
    required this.name,
    required this.type,
    this.json,
  });

  factory SendRecipient.fromJson(Map json, SendRecipientType type) {
    return SendRecipient(
      id: json['kretaAzonosito'] ?? 0,
      kretaId: json['kretaAzonosito'],
      name: json['nev'],
      type: type,
      json: json,
    );
  }

  Object get kretaJson => {
        'azonosito': kretaId ?? 0,
        'kretaAzonosito': kretaId ?? 0,
        'nev': name ?? 'Teszt Lajos',
        'tipus': {
          'azonosito': type.id,
          'kod': type.code,
          'leiras': type.description,
          'nev': type.name,
          'rovidNev': type.shortName,
        }
      };
}

class SendRecipientType {
  Map? json;
  int id;
  String code;
  String description;
  String name;
  String shortName;

  SendRecipientType({
    required this.id,
    required this.code,
    required this.description,
    required this.name,
    required this.shortName,
    this.json,
  });

  factory SendRecipientType.fromJson(Map json) {
    return SendRecipientType(
      id: json['azonosito'],
      code: json['kod'],
      description: json['leiras'],
      name: json['nev'],
      shortName: json['rovidNev'],
      json: json,
    );
  }
}

enum AddresseeType { teachers, directorate }
