// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';

import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:live_activities/live_activities.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/live_card.i18n.dart';

enum LiveCardState {
  empty,
  duringLesson,
  duringBreak,
  morning,
  afternoon,
  night,
  summary
}

class LiveCardProvider extends ChangeNotifier {
  Lesson? currentLesson;
  Lesson? nextLesson;
  Lesson? prevLesson;
  List<Lesson>? nextLessons;

  LiveCardState currentState = LiveCardState.empty;
  late Timer _timer;
  late final TimetableProvider _timetable;
  late final SettingsProvider _settings;

  late Duration _delay;

  final _liveActivitiesPlugin = LiveActivities();
  String? _latestActivityId;
  Map<String, String> _lastActivity = {};

  bool _hasCheckedTimetable = false;

  LiveCardProvider({
    required TimetableProvider timetable,
    required SettingsProvider settings,
  })  : _timetable = timetable,
        _settings = settings {
    if (Platform.isIOS) {
      _liveActivitiesPlugin.areActivitiesEnabled().then((value) {
        // Console log
        if (kDebugMode) {
          print("iOS LiveActivity enabled: $value");
        }

        if (value) {
          _liveActivitiesPlugin.init(appGroupId: "group.refilc2.livecard");

          _liveActivitiesPlugin.getAllActivitiesIds().then((value) {
            _latestActivityId = value.isNotEmpty ? value.first : null;
          });
        }
      });
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => update());
    _delay = settings.bellDelayEnabled
        ? Duration(seconds: settings.bellDelay)
        : Duration.zero;
    update();
  }

  @override
  void dispose() {
    _timer.cancel();
    if (Platform.isIOS) {
      _liveActivitiesPlugin.areActivitiesEnabled().then((value) {
        if (value) {
          if (_latestActivityId != null) {
            _liveActivitiesPlugin.endActivity(_latestActivityId!);
          }
        }
      });
    }
    super.dispose();
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
              ? currentLesson?.subject.renamedTo ?? ShortSubject.resolve(subject: currentLesson?.subject).capital()
              : "",
          "subtitle": currentLesson?.room.replaceAll("_", " ") ?? "",
          "description": currentLesson?.description ?? "",
          "startDate": ((currentLesson?.start.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "endDate": ((currentLesson?.end.millisecondsSinceEpoch ?? 0) -
                  _delay.inMilliseconds)
              .toString(),
          "nextSubject": nextLesson != null
              ? nextLesson?.subject.renamedTo ?? ShortSubject.resolve(subject: nextLesson?.subject).capital()
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
                  ? nextLesson?.subject.renamedTo ?? ShortSubject.resolve(subject: nextLesson?.subject).capital()
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
    if (Platform.isIOS) {
      _liveActivitiesPlugin.areActivitiesEnabled().then((value) {
        if (value) {
          final cmap = toMap();
          if (!mapEquals(cmap, _lastActivity)) {
            _lastActivity = cmap;
            try {
              if (_lastActivity.isNotEmpty) {
                if (_latestActivityId == null) {
                  _liveActivitiesPlugin
                      .createActivity(_lastActivity)
                      .then((value) => _latestActivityId = value);
                } else {
                  _liveActivitiesPlugin.updateActivity(
                      _latestActivityId!, _lastActivity);
                }
              } else {
                if (_latestActivityId != null) {
                  _liveActivitiesPlugin.endActivity(_latestActivityId!);
                }
              }
            } catch (e) {
              if (kDebugMode) {
                print('ERROR: Unable to create or update iOS LiveActivity!');
              }
            }
          }
        }
      });
    }

    List<Lesson> today = _today(_timetable);

    if (today.isEmpty && !_hasCheckedTimetable) {
      _hasCheckedTimetable = true;
      await _timetable.fetch(week: Week.current());
      today = _today(_timetable);
    }

    _delay = _settings.bellDelayEnabled
        ? Duration(seconds: _settings.bellDelay)
        : Duration.zero;

    final now = _now().add(_delay);

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
      currentState = LiveCardState.morning;
    } else {
      currentState = LiveCardState.empty;
    }

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
