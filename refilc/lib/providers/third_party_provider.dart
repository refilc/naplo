import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:provider/provider.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/models/linked_account.dart';
import 'package:refilc_kreta_api/controllers/timetable_controller.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ThirdPartyProvider with ChangeNotifier {
  late List<LinkedAccount> _linkedAccounts;
  // google specific
  late List<Event>? _googleEvents;
  late List<Calendar>? _googleCalendars;

  late BuildContext _context;

  static final _googleSignIn = GoogleSignIn(scopes: [
    CalendarApi.calendarScope,
    CalendarApi.calendarEventsScope,
  ]);

  // public
  List<LinkedAccount> get linkedAccounts => _linkedAccounts;

  List<Event> get googleEvents => _googleEvents ?? [];
  List<Calendar> get googleCalendars => _googleCalendars ?? [];

  ThirdPartyProvider({
    required BuildContext context,
    List<LinkedAccount>? initialLinkedAccounts,
  }) {
    _context = context;
    _linkedAccounts = initialLinkedAccounts ?? [];

    if (_linkedAccounts.isEmpty) restore();
  }

  Future<void> restore() async {
    String? userId = Provider.of<UserProvider>(_context, listen: false).id;

    // load accounts from db
    if (userId != null) {
      var dbLinkedAccounts =
          await Provider.of<DatabaseProvider>(_context, listen: false)
              .userQuery
              .getLinkedAccounts(userId: userId);
      _linkedAccounts = dbLinkedAccounts;
    }
  }

  void fetch() async {}

  Future<GoogleSignInAccount?> googleSignIn() async {
    if (!await _googleSignIn.isSignedIn()) {
      GoogleSignInAccount? account = await _googleSignIn.signIn();

      LinkedAccount linked = LinkedAccount.fromJson({
        'type': 'google',
        'username': account?.email ?? '',
        'display_name': account?.displayName ?? '',
        'id': account?.id ?? ''
      });
      _linkedAccounts.add(linked);

      return account;
    }
    return null;
  }

  Future<void> signOutAll() async {
    await _googleSignIn.signOut();
    _linkedAccounts.clear();
  }

  // Future<void> fetchGoogle() async {
  //   try {
  //     var httpClient = (await _googleSignIn.authenticatedClient())!;
  //     var calendarApi = CalendarApi(httpClient);

  //     var calendarList = await calendarApi.calendarList.list();

  //     if (calendarList.items == null) return;
  //     if (calendarList.items!.isEmpty) return;

  //     _googleEvents = (await calendarApi.events.list(
  //             '13342d17fe1e68680c43c0c44dcb7e30cb0171cc4e4ee9ee13c9ff3082d3279c@group.calendar.google.com'))
  //         .items;

  //     print(calendarList.items!
  //         .map((e) => (e.id ?? 'noid') + '-' + (e.description ?? 'nodesc')));
  //     print(_googleEvents!.map((e) => e.toJson()));
  //   } catch (e) {
  //     print(e);
  //     await _googleSignIn.signOut();
  //   }
  // }

  Future<Event?> pushEvent({
    required String title,
    required String calendarId,
    required DateTime start,
    required DateTime end,
  }) async {
    try {
      var httpClient = (await _googleSignIn.authenticatedClient())!;
      var calendarApi = CalendarApi(httpClient);

      Event event = Event(
        created: DateTime.now(),
        creator: EventCreator(self: true),
        start: EventDateTime(dateTime: start),
        end: EventDateTime(dateTime: end),
        summary: title,
      );

      return await calendarApi.events.insert(event, calendarId);
    } catch (e) {
      if (kDebugMode) print(e);
      await _googleSignIn.signOut();
    }

    return null;
  }

  Future<Calendar?> createCalendar({
    required String name,
    required String description,
  }) async {
    try {
      var httpClient = (await _googleSignIn.authenticatedClient())!;
      var calendarApi = CalendarApi(httpClient);

      Calendar calendar = Calendar(
        summary: name,
        description: description,
        timeZone: 'Europe/Budapest',
      );

      return await calendarApi.calendars.insert(calendar);
    } catch (e) {
      if (kDebugMode) print(e);
      await _googleSignIn.signOut();
    }

    return null;
  }

  Future<void> pushTimetable(
      BuildContext context, TimetableController controller) async {
    Calendar? calendar = await createCalendar(
      name: 'reFilc - Órarend',
      description:
          'Ez egy automatikusan generált naptár, melyet a reFilc hozott létre az órarend számára.',
    );

    if (calendar == null) return;

    final days = controller.days!;
    final everyLesson = days.expand((x) => x).toList();
    everyLesson.sort((a, b) => a.start.compareTo(b.start));

    for (Lesson l in everyLesson) {
      Event? event = await pushEvent(
        title: l.name,
        calendarId: calendar.id!,
        start: l.start,
        end: l.end,
      );

      // temp shit (DONT BULLY ME, ILL CUM)
      if (kDebugMode) {
        if (false != true) print(event);
      }
    }

    return;
    // print('finished');
  }
}
