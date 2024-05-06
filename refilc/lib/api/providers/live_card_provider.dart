// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:refilc/api/providers/liveactivity/platform_channel.dart';
import 'package:refilc/helpers/subject.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc_kreta_api/models/week.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_kreta_api/providers/timetable_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:refilc_mobile_ui/pages/home/live_card/live_card.i18n.dart';

enum LiveCardState {
  empty,
  duringLesson,
  duringBreak,
  morning,
  weekendMorning,
  afternoon,
  night,
  summary,
}

class LiveCardProvider extends ChangeNotifier {
  Lesson? currentLesson;
  Lesson? nextLesson;
  Lesson? prevLesson;
  List<Lesson>? nextLessons;

  // new variables
  static bool hasActivityStarted = false;
  static bool hasDayEnd = false;
  static DateTime? storeFirstRunDate;
  static bool hasActivitySettingsChanged = false;
  // ignore: non_constant_identifier_names
  static Map<String, String> LAData = {};
  static DateTime? now;
  //

  LiveCardState currentState = LiveCardState.empty;
  // ignore: unused_field
  late Timer _timer;
  late final TimetableProvider _timetable;
  late final SettingsProvider _settings;

  late Duration _delay;

  bool _hasCheckedTimetable = false;

  LiveCardProvider({
    required TimetableProvider timetable,
    required SettingsProvider settings,
  })  : _timetable = timetable,
        _settings = settings {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => update());
    _delay = settings.bellDelayEnabled
        ? Duration(seconds: settings.bellDelay)
        : Duration.zero;
    update();
  }

  // Debugging
  static DateTime _now() {
    // return DateTime(2023, 9, 27, 9, 30);
    return DateTime.now();
  }

  String getFloorDifference() {
    final prevFloor = prevLesson!.getFloor();
    final nextFloor = nextLesson!.getFloor();
    if (prevFloor == null || nextFloor == null || prevFloor == nextFloor) {
      return "to room";
    }
    if (nextFloor == 0) {
      return "ground floor";
    }
    if (nextFloor > prevFloor) {
      return "up floor";
    } else {
      return "down floor";
    }
  }

  Map<String, String> toMap() {
    switch (currentState) {
      case LiveCardState.morning:
        return {
          "color":
              '#${_settings.liveActivityColor.toString().substring(10, 16)}',
          "icon": nextLesson != null
              ? SubjectIcon.resolveName(subject: nextLesson?.subject)
              : "book",
          "title": "Jó reggelt! Az első órádig:",
          "subtitle": "",
          "description": "",
          "startDate": storeFirstRunDate != null
              ? ((storeFirstRunDate?.millisecondsSinceEpoch ?? 0) -
                      (_delay.inMilliseconds))
                  .toString()
              : "",
          "endDate": ((nextLesson?.start.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "nextSubject": nextLesson != null
              ? nextLesson?.subject.renamedTo ??
                  ShortSubject.resolve(subject: nextLesson?.subject).capital()
              : "",
          "nextRoom": nextLesson?.room.replaceAll("_", " ") ?? "",
        };

      case LiveCardState.afternoon:
        return {
          "color":
              '#${_settings.liveActivityColor.toString().substring(10, 16)}',
          "icon": nextLesson != null
              ? SubjectIcon.resolveName(subject: nextLesson?.subject)
              : "book",
          "title": "Jó napot! Az első órádig:",
          "subtitle": "",
          "description": "",
          "startDate": storeFirstRunDate != null
              ? ((storeFirstRunDate?.millisecondsSinceEpoch ?? 0) -
                      (_delay.inMilliseconds))
                  .toString()
              : "",
          "endDate": ((nextLesson?.start.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "nextSubject": nextLesson != null
              ? nextLesson?.subject.renamedTo ??
                  ShortSubject.resolve(subject: nextLesson?.subject).capital()
              : "",
          "nextRoom": nextLesson?.room.replaceAll("_", " ") ?? "",
        };

      case LiveCardState.night:
        return {
          "color":
              '#${_settings.liveActivityColor.toString().substring(10, 16)}',
          "icon": nextLesson != null
              ? SubjectIcon.resolveName(subject: nextLesson?.subject)
              : "book",
          "title": "Jó estét! Az első órádig:",
          "subtitle": "",
          "description": "",
          "startDate": storeFirstRunDate != null
              ? ((storeFirstRunDate?.millisecondsSinceEpoch ?? 0) -
                      (_delay.inMilliseconds))
                  .toString()
              : "",
          "endDate": ((nextLesson?.start.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "nextSubject": nextLesson != null
              ? nextLesson?.subject.renamedTo ??
                  ShortSubject.resolve(subject: nextLesson?.subject).capital()
              : "",
          "nextRoom": nextLesson?.room.replaceAll("_", " ") ?? "",
        };

      case LiveCardState.duringLesson:
        return {
          "color":
              '#${_settings.liveActivityColor.toString().substring(10, 16)}',
          "icon": currentLesson != null
              ? SubjectIcon.resolveName(subject: currentLesson?.subject)
              : "book",
          "index":
              currentLesson != null ? '${currentLesson!.lessonIndex}. ' : "",
          "title": currentLesson != null
              ? currentLesson?.subject.renamedTo ??
                  ShortSubject.resolve(subject: currentLesson?.subject)
                      .capital()
              : "",
          "subtitle": "Terem: ${currentLesson?.room.replaceAll("_", " ") ?? ""}",
          "description": currentLesson?.description ?? "",
          "startDate": ((currentLesson?.start.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "endDate": ((currentLesson?.end.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "nextSubject": nextLesson != null
              ? nextLesson?.subject.renamedTo ??
                  ShortSubject.resolve(subject: nextLesson?.subject).capital()
              : "",
          "nextRoom": nextLesson?.room.replaceAll("_", " ") ?? "",
        };
      case LiveCardState.duringBreak:
        final iconFloorMap = {
          "to room": "chevron.right.2",
          "up floor": "arrow.up.right",
          "down floor": "arrow.down.left",
          "ground floor": "arrow.down.left",
        };

        final diff = getFloorDifference();

        return {
          "color":
              '#${_settings.liveActivityColor.toString().substring(10, 16)}',
          "icon": iconFloorMap[diff] ?? "cup.and.saucer",
          "title": "Szünet",
          "description": "go $diff".i18n.fill([
            diff != "to room" ? (nextLesson!.getFloor() ?? 0) : nextLesson!.room
          ]),
          "startDate": ((prevLesson?.end.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "endDate": ((nextLesson?.start.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "nextSubject": (nextLesson != null
                  ? nextLesson?.subject.renamedTo ??
                      ShortSubject.resolve(subject: nextLesson?.subject)
                          .capital()
                  : "")
              .capital(),
          "nextRoom": nextLesson?.room.replaceAll("_", " ") ?? "",
          "index": "",
          "subtitle": "",
        };
      default:
        return {};
    }
  }

  void update() async {
    List<Lesson> today = _today(_timetable);

    if (today.isEmpty && !_hasCheckedTimetable) {
      _hasCheckedTimetable = true;
      await _timetable.fetch(week: Week.current());
      today = _today(_timetable);
    }

    _delay = _settings.bellDelayEnabled
        ? Duration(seconds: _settings.bellDelay)
        : Duration.zero;

    DateTime now = _now().add(_delay);

    if ((currentState == LiveCardState.morning ||
            currentState == LiveCardState.afternoon ||
            currentState == LiveCardState.night) &&
        storeFirstRunDate == null) {
      storeFirstRunDate = now;
    }

    // Filter cancelled lessons #20
    // Filter label lessons #128
    today = today
        .where((lesson) =>
            lesson.status?.name != "Elmaradt" &&
            lesson.subject.id != '' &&
            !lesson.isEmpty)
        .toList();

    if (today.isNotEmpty) {
      // sort
      today.sort((a, b) => a.start.compareTo(b.start));

      final _lesson = today.firstWhere(
          (l) => l.start.isBefore(now) && l.end.isAfter(now),
          orElse: () => Lesson.fromJson({}));

      if (_lesson.start.year != 0) {
        currentLesson = _lesson;
      } else {
        currentLesson = null;
      }

      final _next = today.firstWhere((l) => l.start.isAfter(now),
          orElse: () => Lesson.fromJson({}));
      nextLessons = today.where((l) => l.start.isAfter(now)).toList();

      if (_next.start.year != 0) {
        nextLesson = _next;
      } else {
        nextLesson = null;
      }

      final _prev = today.lastWhere((l) => l.end.isBefore(now),
          orElse: () => Lesson.fromJson({}));

      if (_prev.start.year != 0) {
        prevLesson = _prev;
      } else {
        prevLesson = null;
      }
    }

    if (now.isBefore(DateTime(now.year, DateTime.august, 31)) &&
        now.isAfter(DateTime(now.year, DateTime.june, 14))) {
      currentState = LiveCardState.summary;
    } else if (currentLesson != null) {
      currentState = LiveCardState.duringLesson;
    } else if (nextLesson != null && prevLesson != null) {
      currentState = LiveCardState.duringBreak;
    } else if (now.hour >= 12 && now.hour < 20) {
      currentState = LiveCardState.afternoon;
    } else if (now.hour >= 20) {
      currentState = LiveCardState.night;
    } else if (now.hour >= 5 && now.hour <= 10) {
      if (nextLesson == null || now.weekday == 6 || now.weekday == 7) {
        currentState = LiveCardState.empty;
      } else {
        currentState = LiveCardState.morning;
      }
    } else {
      currentState = LiveCardState.empty;
    }

    //LIVE ACTIVITIES

    //CREATE
    if (!hasActivityStarted &&
        nextLesson != null &&
        nextLesson!.start.difference(now).inMinutes <= 60 &&
        (currentState == LiveCardState.morning ||
            currentState == LiveCardState.afternoon ||
            currentState == LiveCardState.night)) {
      debugPrint(
          "Az első óra előtt állunk, kevesebb mint egy órával. Létrehozás...");
      PlatformChannel.createLiveActivity(toMap());
      hasActivityStarted = true;
    } else if (!hasActivityStarted &&
        ((currentState == LiveCardState.duringLesson &&
                currentLesson != null) ||
            currentState == LiveCardState.duringBreak)) {
      debugPrint("Óra van, vagy szünet, de nincs LiveActivity. létrehozás...");
      PlatformChannel.createLiveActivity(toMap());
      hasActivityStarted = true;
    }

    //UPDATE
    else if (hasActivityStarted) {
      if (hasActivitySettingsChanged) {
        debugPrint("Valamelyik beállítás megváltozott. Frissítés...");
        PlatformChannel.updateLiveActivity(toMap());
        hasActivitySettingsChanged = false;
      } else if (nextLesson != null || currentLesson != null) {
        bool afterPrevLessonEnd = prevLesson != null &&
            now
                .subtract(const Duration(seconds: 1))
                .isBefore(prevLesson!.end) &&
            now.isAfter(prevLesson!.end);

        bool afterCurrentLessonStart = currentLesson != null &&
            now
                .subtract(const Duration(seconds: 1))
                .isBefore(currentLesson!.start) &&
            now.isAfter(currentLesson!.start);
        if (afterPrevLessonEnd || afterCurrentLessonStart) {
          debugPrint(
              "Óra kezdete/vége után 1 másodperccel vagyunk. Frissítés...");
          PlatformChannel.updateLiveActivity(toMap());
        }
      }
    }

    //END
    if (hasActivityStarted &&
        !hasDayEnd &&
        nextLesson == null &&
        now.isAfter(prevLesson!.end)) {
      debugPrint("Az utolsó óra véget ért. Befejezés...");
      PlatformChannel.endLiveActivity();
      hasDayEnd = true;
      hasActivityStarted = false;
    }
    LAData = toMap();
    notifyListeners();
  }

  bool get show => currentState != LiveCardState.empty;
  Duration get delay => _delay;

  bool _sameDate(DateTime a, DateTime b) =>
      (a.year == b.year && a.month == b.month && a.day == b.day);

  List<Lesson> _today(TimetableProvider p) => (p.getWeek(Week.current()) ?? [])
      .where((l) => _sameDate(l.date, _now()))
      .toList();
}
