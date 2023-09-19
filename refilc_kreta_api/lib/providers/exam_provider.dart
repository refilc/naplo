import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/models/user.dart';
import 'package:refilc_kreta_api/client/api.dart';
import 'package:refilc_kreta_api/client/client.dart';
import 'package:refilc_kreta_api/models/exam.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExamProvider with ChangeNotifier {
  late List<Exam> _exams;
  late BuildContext _context;
  List<Exam> get exams => _exams;

  ExamProvider({
    List<Exam> initialExams = const [],
    required BuildContext context,
  }) {
    _exams = List.castFrom(initialExams);
    _context = context;

    if (_exams.isEmpty) restore();
  }

  Future<void> restore() async {
    String? userId = Provider.of<UserProvider>(_context, listen: false).id;

    // Load exams from the database
    if (userId != null) {
      var dbExams = await Provider.of<DatabaseProvider>(_context, listen: false)
          .userQuery
          .getExams(userId: userId);
      _exams = dbExams;
      notifyListeners();
    }
  }

  // Fetches Exams from the Kreta API then stores them in the database
  Future<void> fetch() async {
    User? user = Provider.of<UserProvider>(_context, listen: false).user;
    if (user == null) throw "Cannot fetch Exams for User null";
    String iss = user.instituteCode;

    List? examsJson = await Provider.of<KretaClient>(_context, listen: false)
        .getAPI(KretaAPI.exams(iss));
    if (examsJson == null) throw "Cannot fetch Exams for User ${user.id}";
    List<Exam> exams = examsJson.map((e) => Exam.fromJson(e)).toList();

    if (exams.isNotEmpty || _exams.isNotEmpty) await store(exams);
  }

  // Stores Exams in the database
  Future<void> store(List<Exam> exams) async {
    User? user = Provider.of<UserProvider>(_context, listen: false).user;
    if (user == null) throw "Cannot store Exams for User null";
    String userId = user.id;

    await Provider.of<DatabaseProvider>(_context, listen: false)
        .userStore
        .storeExams(exams, userId: userId);
    _exams = exams;
    notifyListeners();
  }
}
