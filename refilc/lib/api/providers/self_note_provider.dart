import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/models/self_note.dart';
import 'package:refilc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelfNoteProvider with ChangeNotifier {
  late List<SelfNote> _notes;
  late BuildContext _context;
  List<SelfNote> get notes => _notes;

  SelfNoteProvider({
    List<SelfNote> initialNotes = const [],
    required BuildContext context,
  }) {
    _notes = List.castFrom(initialNotes);
    _context = context;

    if (_notes.isEmpty) restore();
  }

  // restore self notes from db
  Future<void> restore() async {
    String? userId = Provider.of<UserProvider>(_context, listen: false).id;

    // load self notes from db
    if (userId != null) {
      var dbNotes = await Provider.of<DatabaseProvider>(_context, listen: false)
          .userQuery
          .getSelfNotes(userId: userId);
      _notes = dbNotes;
      notifyListeners();
    }
  }

  // fetches fresh data from api (not needed, cuz no api for that)
  // Future<void> fetch() async {
  // }

  // store self notes in db
  Future<void> store(List<SelfNote> notes) async {
    User? user = Provider.of<UserProvider>(_context, listen: false).user;
    if (user == null) throw "Cannot store Self Notes for User null";
    String userId = user.id;

    await Provider.of<DatabaseProvider>(_context, listen: false)
        .userStore
        .storeSelfNotes(notes, userId: userId);
    _notes = notes;
    notifyListeners();
  }
}
