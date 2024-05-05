// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:math';

import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/models/user.dart';
import 'package:refilc_kreta_api/client/api.dart';
import 'package:refilc_kreta_api/client/client.dart';
import 'package:refilc_kreta_api/models/message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageProvider with ChangeNotifier {
  late List<Message> _messages;
  late List<SendRecipient> _recipients;
  late BuildContext _context;

  List<Message> get messages => _messages;
  List<SendRecipient> get recipients => _recipients;

  MessageProvider({
    List<Message> initialMessages = const [],
    required BuildContext context,
  }) {
    _messages = List.castFrom(initialMessages);
    _recipients = [];
    _context = context;

    if (_messages.isEmpty) restore();
    if (_recipients.isEmpty) restoreRecipients();
  }

  Future<void> restore() async {
    String? userId = Provider.of<UserProvider>(_context, listen: false).id;

    // Load messages from the database
    if (userId != null) {
      var dbMessages =
          await Provider.of<DatabaseProvider>(_context, listen: false)
              .userQuery
              .getMessages(userId: userId);
      _messages = dbMessages;
      notifyListeners();
    }
  }

  // Fetches all types of Messages
  Future<void> fetchAll() =>
      Future.forEach(MessageType.values, (MessageType v) => fetch(type: v));

  // Fetches Messages from the Kreta API then stores them in the database
  Future<void> fetch({MessageType type = MessageType.inbox}) async {
    // Check Message Type
    if (type == MessageType.draft) return;
    String messageType =
        ["beerkezett", "elkuldott", "torolt"].elementAt(type.index);

    // Check User
    User? user = Provider.of<UserProvider>(_context, listen: false).user;
    if (user == null) throw "Cannot fetch Messages for User null";

    // Get messages
    List? messagesJson = await Provider.of<KretaClient>(_context, listen: false)
        .getAPI(KretaAPI.messages(messageType));
    if (messagesJson == null) throw "Cannot fetch Messages for User ${user.id}";

    // Parse messages
    List<Message> messages = [];
    await Future.wait(List.generate(messagesJson.length, (index) {
      return () async {
        Map message = messagesJson.cast<Map>()[index];
        Map? messageJson =
            await Provider.of<KretaClient>(_context, listen: false)
                .getAPI(KretaAPI.message(message["azonosito"].toString()));
        if (messageJson != null) {
          messages.add(Message.fromJson(messageJson, forceType: type));
        }
      }();
    }));

    await store(messages, type);
  }

  // Stores Messages in the database
  Future<void> store(List<Message> messages, MessageType type) async {
    // Only store the specified type
    _messages.removeWhere((m) => m.type == type);
    _messages.addAll(messages);

    User? user = Provider.of<UserProvider>(_context, listen: false).user;
    if (user == null) throw "Cannot store Messages for User null";

    String userId = user.id;
    await Provider.of<DatabaseProvider>(_context, listen: false)
        .userStore
        .storeMessages(_messages, userId: userId);

    notifyListeners();
  }

  // restore recipients
  Future<void> restoreRecipients() async {
    String? userId = Provider.of<UserProvider>(_context, listen: false).id;

    // Load messages from the database
    if (userId != null) {
      var dbRecipients =
          await Provider.of<DatabaseProvider>(_context, listen: false)
              .userQuery
              .getRecipients(userId: userId);
      _recipients = dbRecipients;
      notifyListeners();
    }
  }

  // fetch all recipients
  Future<void> fetchAllRecipients() => Future.forEach(
      AddresseeType.values, (AddresseeType v) => fetchRecipients(type: v));

  // fetch recipients
  Future<void> fetchRecipients(
      {AddresseeType type = AddresseeType.teachers}) async {
    Map<AddresseeType, SendRecipientType> addressable = {};

    // check user
    User? user = Provider.of<UserProvider>(_context, listen: false).user;
    if (user == null) throw "Cannot fetch Messages for User null";

    // get categories
    List? availableCategoriesJson =
        await Provider.of<KretaClient>(_context, listen: false)
            .getAPI(KretaAPI.recipientCategories);

    // print(availableCategoriesJson);

    // get recipients
    List? recipientTeachersJson =
        await Provider.of<KretaClient>(_context, listen: false)
            .getAPI(KretaAPI.recipientTeachers);
    List? recipientDirectorateJson =
        await Provider.of<KretaClient>(_context, listen: false)
            .getAPI(KretaAPI.recipientDirectorate);

    if (availableCategoriesJson == null ||
        recipientTeachersJson == null ||
        recipientDirectorateJson == null) {
      throw "Cannot fetch Recipients for User ${user.id}";
    }

    for (var e in availableCategoriesJson) {
      // print(e);
      switch (e['kod']) {
        case 'TANAR':
          addressable
              .addAll({AddresseeType.teachers: SendRecipientType.fromJson(e)});
          break;
        case 'IGAZGATOSAG':
          addressable.addAll(
              {AddresseeType.directorate: SendRecipientType.fromJson(e)});
          break;
        default:
          break;
      }
    }

    // parse recipients
    List<SendRecipient> recipients = [];

    if (addressable.containsKey(AddresseeType.teachers) &&
        type == AddresseeType.teachers) {
      recipients.addAll(recipientTeachersJson.map((e) =>
          SendRecipient.fromJson(e, addressable[AddresseeType.teachers]!)));
    }
    if (addressable.containsKey(AddresseeType.directorate) &&
        type == AddresseeType.directorate) {
      recipients.addAll(recipientDirectorateJson.map((e) =>
          SendRecipient.fromJson(e, addressable[AddresseeType.directorate]!)));
    }

    // if (kDebugMode) {
    //   print(addressable);
    //   print(recipients);
    //   print(recipients.first.json);
    // }

    await storeRecipients(recipients, type);
  }

  // store recipients
  Future<void> storeRecipients(
      List<SendRecipient> recipients, AddresseeType type) async {
    _recipients.removeWhere((r) => (type == AddresseeType.teachers
        ? (r.type.code == 'TANAR')
        : (type == AddresseeType.directorate
            ? (r.type.code == 'IGAZGATOSAG')
            : r.type.code != '')));
    _recipients.addAll(recipients);

    User? user = Provider.of<UserProvider>(_context, listen: false).user;
    if (user == null) throw "Cannot store Recipients for User null";

    String userId = user.id;
    await Provider.of<DatabaseProvider>(_context, listen: false)
        .userStore
        .storeRecipients(_recipients, userId: userId);

    notifyListeners();
  }

  // send message
  Future<String?> sendMessage({
    required List<SendRecipient> recipients,
    String subject = "Nincs tárgy",
    required String messageText,
  }) async {
    List<Object> recipientList = [];

    User? user = Provider.of<UserProvider>(_context, listen: false).user;
    if (user == null) throw "Cannot send Message as User null";

    // for (var r in recipients) {
    //   recipientList.add({
    //     "azonosito": r.id ?? "",
    //     "kretaAzonosito": r.kretaId ?? "",
    //     "nev": r.name ?? "Teszt Lajos",
    //     "tipus": {
    //       "kod": r.type.code,
    //       "leiras": r.type.description,
    //       "azonosito": r.type.id,
    //       "nev": r.type.name,
    //       "rovidNev": r.type.shortName,
    //     }
    //   });
    // }
    recipientList.addAll(recipients.map((e) => e.kretaJson));

    Map body = {
      "cimzettLista": recipientList,
      "csatolmanyok": [],
      "azonosito": (Random().nextInt(10000) + 10000),
      "feladoNev": user.name,
      "feladoTitulus": user.role == Role.parent ? "Szülő" : "Diák",
      "kuldesDatum": DateTime.now().toIso8601String(),
      "targy": subject,
      "szoveg": messageText,
      // "elozoUzenetAzonosito": 0,
    };

    Map<String, String> headers = {
      "content-type": "application/json",
    };

    var res = await Provider.of<KretaClient>(_context, listen: false).postAPI(
      KretaAPI.sendMessage,
      autoHeader: true,
      json: true,
      body: json.encode(body),
      headers: headers,
    );

    if (res!['hibakod'] == 'UzenetKuldesEngedelyRule') {
      return 'send_permission_error';
    }

    return 'successfully_sent';
  }
}
