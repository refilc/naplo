import 'package:filcnaplo/models/user.dart';
import 'package:filcnaplo_kreta_api/models/student.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  final Map<String, User> _users = {};
  String? _selectedUserId;
  User? get user => _users[_selectedUserId];

  // _user properties
  String? get instituteCode => user?.instituteCode;
  String? get id => user?.id;
  String? get name => user?.name;
  String? get username => user?.username;
  String? get password => user?.password;
  Role? get role => user?.role;
  Student? get student => user?.student;

  void setUser(String userId) {
    _selectedUserId = userId;
    notifyListeners();
  }

  void addUser(User user) {
    _users[user.id] = user;
    if (kDebugMode) {
      print("DEBUG: Added User: ${user.id}");
    }
  }

  void removeUser(String userId) {
    _users.removeWhere((key, value) => key == userId);
    if (_users.isNotEmpty) _selectedUserId = _users.keys.first;
    notifyListeners();
  }

  User getUser(String userId) {
    return _users[userId]!;
  }

  List<User> getUsers() {
    return _users.values.toList();
  }
}
