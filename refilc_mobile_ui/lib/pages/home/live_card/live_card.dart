import 'package:animations/animations.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/helpers/subject.dart';
import 'package:refilc/icons/filc_icons.dart';
import 'package:refilc/models/settings.dart';
// import 'package:refilc_kreta_api/models/category.dart';
// import 'package:refilc_kreta_api/models/lesson.dart';
// import 'package:refilc_kreta_api/models/subject.dart';
// import 'package:refilc_kreta_api/models/teacher.dart';
import 'package:refilc_mobile_ui/common/splitted_panel/splitted_panel.dart';
import 'package:refilc_mobile_ui/pages/home/live_card/heads_up_countdown.dart';
import 'package:refilc_mobile_ui/pages/home/live_card/segmented_countdown.dart';
import 'package:refilc_mobile_ui/screens/summary/summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc/api/providers/live_card_provider.dart';
import 'package:refilc_mobile_ui/pages/home/live_card/live_card_widget.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'live_card.i18n.dart';

class LiveCard extends StatefulWidget {
  const LiveCard({super.key});

  @override
  LiveCardStateA createState() => LiveCardStateA();
}

class LiveCardStateA extends State<LiveCard> {
  late void Function() listener;
  late UserProvider _userProvider;
  late LiveCardProvider liveCard;

  @override
  void initState() {
    super.initState();
    listener = () => setState(() {});
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    liveCard = Provider.of<LiveCardProvider>(context, listen: false);
    _userProvider.addListener(liveCard.update);
  }

  @override
  void dispose() {
    _userProvider.removeListener(liveCard.update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    liveCard = Provider.of<LiveCardProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    if (!liveCard.show) return Container();

    Widget child;
    Duration bellDelay = liveCard.delay;

    // test
    // liveCard.currentState = LiveCardState.morning;
    // liveCard.nextLesson = Lesson(
    //   date: DateTime.now().add(Duration(
    //     minutes: 30,
    //   )),
    //   subject: GradeSubject(
    //       category: Category(id: 'asd'), id: 'asd', name: 'Matematika'),
    //   lessonIndex: 'lessonIndex',
    //   teacher: Teacher(id: 'id', name: 'name'),
    //   start: DateTime.now().add(Duration(
    //     minutes: 30,
    //   )),
    //   end: DateTime.now().add(Duration(
    //     minutes: 30 + 45,
    //   )),
    //   homeworkId: 'homeworkId',
    //   id: 'id',
    //   description: 'description',
    //   room: 'ABC69',
    //   groupName: 'groupName',
    //   name: 'name',
    // );

    final dt = DateTime(2024, 3, 22, 17, 12, 1, 1, 1);

    switch (liveCard.currentState) {
      case LiveCardState.summary:
        child = LiveCardWidget(
          key: const Key('livecard.summary'),
          title: 'Vége a tanévnek! 🥳',
          icon: FeatherIcons.arrowRight,
          description: Text(
            'Irány az összefoglaláshoz',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          onTap: () {
            // showSlidingBottomSheet(
            //   context,
            //   useRootNavigator: true,
            //   builder: (context) => SlidingSheetDialog(
            //     color: Colors.black.withOpacity(0.99),
            //     duration: const Duration(milliseconds: 400),
            //     scrollSpec: const ScrollSpec.bouncingScroll(),
            //     snapSpec: const SnapSpec(
            //       snap: true,
            //       snappings: [1.0],
            //       initialSnap: 1.0,
            //       positioning: SnapPositioning.relativeToAvailableSpace,
            //     ),
            //     minHeight: MediaQuery.of(context).size.height,
            //     cornerRadius: 16,
            //     cornerRadiusOnFullscreen: 0,
            //     builder: (context, state) => const Material(
            //       color: Colors.black,
            //       child: SummaryScreen(
            //         currentPage: 'start',
            //       ),
            //     ),
            //   ),
            // );
            SummaryScreen.show(context: context, currentPage: 'start');
          },
        );
        break;
      case LiveCardState.morning:
        child = LiveCardWidget(
          key: const Key('livecard.morning'),
          // title: DateFormat("EEEE", I18n.of(context).locale.toString())
          //     .format(DateTime.now())
          //     .capital(),
          // icon: FeatherIcons.sun,
          onTap: () async {
            await MapsLauncher.launchQuery(
                '${_userProvider.student?.school.city ?? ''} ${_userProvider.student?.school.name ?? ''}');
          },
          // description: liveCard.nextLesson != null
          //     ? Text.rich(
          //         TextSpan(
          //           children: [
          //             TextSpan(text: "first_lesson_1".i18n),
          //             TextSpan(
          //               text: liveCard.nextLesson!.subject.renamedTo ??
          //                   liveCard.nextLesson!.subject.name.capital(),
          //               style: TextStyle(
          //                   fontWeight: FontWeight.w600,
          //                   color: Theme.of(context)
          //                       .colorScheme
          //                       .secondary
          //                       .withOpacity(.85),
          //                   fontStyle: liveCard.nextLesson!.subject.isRenamed &&
          //                           settingsProvider.renamedSubjectsItalics
          //                       ? FontStyle.italic
          //                       : null),
          //             ),
          //             TextSpan(text: "first_lesson_2".i18n),
          //             TextSpan(
          //               text: liveCard.nextLesson!.room.capital(),
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 color: Theme.of(context)
          //                     .colorScheme
          //                     .secondary
          //                     .withOpacity(.85),
          //               ),
          //             ),
          //             TextSpan(text: "first_lesson_3".i18n),
          //             TextSpan(
          //               text: DateFormat('H:mm')
          //                   .format(liveCard.nextLesson!.start),
          //               style: TextStyle(
          //                 fontWeight: FontWeight.w600,
          //                 color: Theme.of(context)
          //                     .colorScheme
          //                     .secondary
          //                     .withOpacity(.85),
          //               ),
          //             ),
          //             TextSpan(text: "first_lesson_4".i18n),
          //           ],
          //         ),
          //       )
          //     : null,
          children: liveCard.nextLesson != null
              ? [
                  SplittedPanel(
                    hasShadow: false,
                    padding: EdgeInsets.zero,
                    cardPadding: EdgeInsets.zero,
                    spacing: 8.0,
                    children: [
                      SplittedPanel(
                        hasShadow: false,
                        isTransparent: true,
                        padding: EdgeInsets.zero,
                        cardPadding: const EdgeInsets.symmetric(
                          horizontal: 18.0,
                          vertical: 16.0,
                        ),
                        spacing: 0.0,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'first_lesson_soon'.i18n,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              SegmentedCountdown(date: dt)
                            ],
                          ),
                        ],
                      ),
                      SplittedPanel(
                        hasShadow: false,
                        isTransparent: true,
                        padding: EdgeInsets.zero,
                        cardPadding: const EdgeInsets.symmetric(
                          horizontal: 18.0,
                          vertical: 14.0,
                        ),
                        spacing: 0.0,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    SubjectIcon.resolveVariant(
                                      context: context,
                                      subject: liveCard.nextLesson!.subject,
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    (liveCard.nextLesson!.subject.isRenamed
                                            ? liveCard
                                                .nextLesson!.subject.renamedTo
                                            : liveCard
                                                .nextLesson!.subject.name) ??
                                        '',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: liveCard.nextLesson!.room.length > 20
                                        ? 111
                                        : null,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0, vertical: 3.5),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(.15),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      liveCard.nextLesson!.room,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        height: 1.1,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(.9),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '${DateFormat('H:mm').format(liveCard.nextLesson!.start)}-${DateFormat('H:mm').format(liveCard.nextLesson!.end)}',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ]
              : null,
        );
        break;
      case LiveCardState.duringLesson:
        final elapsedTime = DateTime.now()
                .difference(liveCard.currentLesson!.start)
                .inSeconds
                .toDouble() +
            bellDelay.inSeconds;
        final maxTime = liveCard.currentLesson!.end
            .difference(liveCard.currentLesson!.start)
            .inSeconds
            .toDouble();

        final showMinutes = maxTime - elapsedTime > 60;

        child = LiveCardWidget(
          key: const Key('livecard.duringLesson'),
          leading: liveCard.currentLesson!.lessonIndex +
              (RegExp(r'\d').hasMatch(liveCard.currentLesson!.lessonIndex)
                  ? "."
                  : ""),
          title: liveCard.currentLesson!.subject.renamedTo ??
              liveCard.currentLesson!.subject.name.capital(),
          titleItalic: liveCard.currentLesson!.subject.isRenamed &&
              settingsProvider.renamedSubjectsEnabled &&
              settingsProvider.renamedSubjectsItalics,
          subtitle: liveCard.currentLesson!.room,
          icon: SubjectIcon.resolveVariant(
              subject: liveCard.currentLesson!.subject, context: context),
          description: liveCard.currentLesson!.description != ""
              ? Text(liveCard.currentLesson!.description)
              : null,
          nextSubject: liveCard.nextLesson?.subject.renamedTo ??
              liveCard.nextLesson?.subject.name.capital(),
          nextSubjectItalic: liveCard.nextLesson?.subject.isRenamed == true &&
              settingsProvider.renamedSubjectsEnabled &&
              settingsProvider.renamedSubjectsItalics,
          nextRoom: liveCard.nextLesson?.room,
          progressMax: showMinutes ? maxTime / 60 : maxTime,
          progressCurrent: showMinutes ? elapsedTime / 60 : elapsedTime,
          progressAccuracy:
              showMinutes ? ProgressAccuracy.minutes : ProgressAccuracy.seconds,
          onProgressTap: () {
            showDialog(
              barrierColor: Colors.black,
              context: context,
              builder: (context) =>
                  HeadsUpCountdown(maxTime: maxTime, elapsedTime: elapsedTime),
            );
          },
        );
        break;
      case LiveCardState.duringBreak:
        final iconFloorMap = {
          "to room": FeatherIcons.chevronsRight,
          "up floor": FilcIcons.upstairs,
          "down floor": FilcIcons.downstairs,
          "ground floor": FilcIcons.downstairs,
        };

        final diff = liveCard.getFloorDifference();

        final maxTime = liveCard.nextLesson!.start
            .difference(liveCard.prevLesson!.end)
            .inSeconds
            .toDouble();
        final elapsedTime = DateTime.now()
                .difference(liveCard.prevLesson!.end)
                .inSeconds
                .toDouble() +
            bellDelay.inSeconds.toDouble();

        final showMinutes = maxTime - elapsedTime > 60;

        child = LiveCardWidget(
          key: const Key('livecard.duringBreak'),
          title: "break".i18n,
          icon: iconFloorMap[diff],
          description: liveCard.nextLesson!.room != liveCard.prevLesson!.room
              ? Text("go $diff".i18n.fill([
                  diff != "to room"
                      ? (liveCard.nextLesson!.getFloor() ?? 0)
                      : liveCard.nextLesson!.room
                ]))
              : Text("stay".i18n),
          nextSubject: liveCard.nextLesson?.subject.renamedTo ??
              liveCard.nextLesson?.subject.name.capital(),
          nextSubjectItalic: liveCard.nextLesson?.subject.isRenamed == true &&
              settingsProvider.renamedSubjectsItalics,
          nextRoom: diff != "to room" ? liveCard.nextLesson?.room : null,
          progressMax: showMinutes ? maxTime / 60 : maxTime,
          progressCurrent: showMinutes ? elapsedTime / 60 : elapsedTime,
          progressAccuracy:
              showMinutes ? ProgressAccuracy.minutes : ProgressAccuracy.seconds,
          onProgressTap: () {
            showDialog(
              barrierColor: Colors.black,
              context: context,
              builder: (context) => HeadsUpCountdown(
                maxTime: maxTime,
                elapsedTime: elapsedTime,
              ),
            );
          },
        );
        break;
      case LiveCardState.afternoon:
        child = LiveCardWidget(
          key: const Key('livecard.afternoon'),
          title: DateFormat("EEEE", I18n.of(context).locale.toString())
              .format(DateTime.now())
              .capital(),
          icon: FeatherIcons.coffee,
        );
        break;
      case LiveCardState.night:
        child = LiveCardWidget(
          key: const Key('livecard.night'),
          title: DateFormat("EEEE", I18n.of(context).locale.toString())
              .format(DateTime.now())
              .capital(),
          icon: FeatherIcons.moon,
        );
        break;
      default:
        child = Container();
    }

    return PageTransitionSwitcher(
      transitionBuilder: (
        Widget child,
        Animation<double> primaryAnimation,
        Animation<double> secondaryAnimation,
      ) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          child: child,
        );
      },
      child: child,
    );
  }
}
