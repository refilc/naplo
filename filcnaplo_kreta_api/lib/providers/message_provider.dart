import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/models/user.dart';
import 'package:filcnaplo_kreta_api/client/api.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageProvider with ChangeNotifier {
  late List<Message> _messages;
  late BuildContext _context;
  List<Message> get messages => _messages;

  MessageProvider({
    List<Message> initialMessages = const [],
    required BuildContext context,
  }) {
    _messages = List.castFrom(initialMessages);
    _context = context;

    if (_messages.isEmpty) restore();
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

  // fetch recipients
  Future<void> fetchRecipients() async {
    // check user
    User? user = Provider.of<UserProvider>(_context, listen: false).user;
    if (user == null) throw "Cannot fetch Messages for User null";

    // get recipients
    List? recipientsJson =
        await Provider.of<KretaClient>(_context, listen: false)
            .getAPI(KretaAPI.recipientsTeacher);
    if (recipientsJson == null) {
      throw "Cannot fetch Recipients for User ${user.id}";
    }

    print(recipientsJson);
  }

  // send message
  Future<void> sendMessage() async {}
}
