import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/models/user.dart';
import 'package:filcnaplo_kreta_api/models/student.dart';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter/services.dart';

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
  String? get nickname => user?.nickname;
  String? get displayName => user?.displayName;

  final SettingsProvider _settings;

  UserProvider({required SettingsProvider settings}) : _settings = settings;

  void setUser(String userId) async {
    _selectedUserId = userId;
    await _settings.update(lastAccountId: userId);
    updateWidget();
    notifyListeners();
  }

  Future<bool?> updateWidget() async {
    try {
      print("FILC | Widget updated from users");
      return HomeWidget.updateWidget(name: 'widget_timetable.WidgetTimetable');
    } on PlatformException catch (exception) {
      print('Error Updating Widget After setUser. $exception');
    }
    return false;
  }

  void addUser(User user) {
    _users[user.id] = user;
    if (kDebugMode) {
      print("DEBUG: Added User: ${user.id}");
    }
  }

  void removeUser(String userId) async {
    _users.removeWhere((key, value) => key == userId);
    if (_users.isNotEmpty) {
      setUser(_users.keys.first);
    } else {
      print("FILC | Setting last account id to null");
      await _settings.update(lastAccountId: "");
    }
    updateWidget();
    notifyListeners();
}

  User getUser(String userId) {
    return _users[userId]!;
  }

  List<User> getUsers() {
    return _users.values.toList();
  }
}
