import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/models/user.dart';
import 'package:filcnaplo_kreta_api/client/api.dart';
import 'package:filcnaplo_kreta_api/client/client.dart';
import 'package:filcnaplo_kreta_api/models/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventProvider with ChangeNotifier {
  late List<Event> _events;
  late BuildContext _context;
  List<Event> get events => _events;

  EventProvider({
    List<Event> initialEvents = const [],
    required BuildContext context,
  }) {
    _events = List.castFrom(initialEvents);
    _context = context;

    if (_events.isEmpty) restore();
  }

  Future<void> restore() async {
    String? userId = Provider.of<UserProvider>(_context, listen: false).id;

    // Load events from the database
    if (userId != null) {
      var dbEvents = await Provider.of<DatabaseProvider>(_context, listen: false).userQuery.getEvents(userId: userId);
      _events = dbEvents;
      notifyListeners();
    }
  }

  // Fetches Events from the Kreta API then stores them in the database
  Future<void> fetch() async {
    User? user = Provider.of<UserProvider>(_context, listen: false).user;
    if (user == null) throw "Cannot fetch Events for User null";
    String iss = user.instituteCode;
    
    List? eventsJson = await Provider.of<KretaClient>(_context, listen: false).getAPI(KretaAPI.events(iss));
    if (eventsJson == null) throw "Cannot fetch Events for User ${user.id}";
    List<Event> events = eventsJson.map((e) => Event.fromJson(e)).toList();

    if (events.isNotEmpty || _events.isNotEmpty) await store(events);
  }

  // Stores Events in the database
  Future<void> store(List<Event> events) async {
    User? user = Provider.of<UserProvider>(_context, listen: false).user;
    if (user == null) throw "Cannot store Events for User null";
    String userId = user.id;

    await Provider.of<DatabaseProvider>(_context, listen: false).userStore.storeEvents(events, userId: userId);
    _events = events;
    notifyListeners();
  }
}
