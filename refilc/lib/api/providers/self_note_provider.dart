import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/models/self_note.dart';
import 'package:refilc/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelfNoteProvider with ChangeNotifier {
  late List<SelfNote> _notes;
  late List<TodoItem> _todoItems;
  late BuildContext _context;

  List<SelfNote> get notes => _notes;
  List<TodoItem> get todos => _todoItems;

  SelfNoteProvider({
    List<SelfNote> initialNotes = const [],
    List<TodoItem> initialTodoItems = const [],
    required BuildContext context,
  }) {
    _notes = List.castFrom(initialNotes);
    _todoItems = List.castFrom(initialTodoItems);
    _context = context;

    if (_notes.isEmpty) restore();
    if (_todoItems.isEmpty) restoreTodo();
  }

  // restore self notes from db
  Future<void> restore() async {
    String? userId = Provider.of<UserProvider>(_context, listen: false).id;

    // await Provider.of<DatabaseProvider>(_context, listen: false)
    //     .userStore
    //     .storeSelfNotes([], userId: userId!);

    // load self notes from db
    if (userId != null) {
      var dbNotes = await Provider.of<DatabaseProvider>(_context, listen: false)
          .userQuery
          .getSelfNotes(userId: userId);
      _notes = dbNotes;
      notifyListeners();
    }
  }

  // restore todo items from db
  Future<void> restoreTodo() async {
    String? userId = Provider.of<UserProvider>(_context, listen: false).id;

    // await Provider.of<DatabaseProvider>(_context, listen: false)
    //     .userStore
    //     .storeSelfNotes([], userId: userId!);

    // load self notes from db
    if (userId != null) {
      var dbTodo = await Provider.of<DatabaseProvider>(_context, listen: false)
          .userQuery
          .getTodoItems(userId: userId);
      _todoItems = dbTodo;
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

  // store todo items in db
  Future<void> storeTodo(List<TodoItem> todos) async {
    User? user = Provider.of<UserProvider>(_context, listen: false).user;
    if (user == null) throw "Cannot store Self Notes for User null";
    String userId = user.id;

    await Provider.of<DatabaseProvider>(_context, listen: false)
        .userStore
        .storeSelfTodoItems(todos, userId: userId);
    _todoItems = todos;
    notifyListeners();
  }
}
