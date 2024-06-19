// ignore_for_file: unnecessary_null_comparison

import 'package:animations/animations.dart';
import 'package:flutter/services.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/helpers/subject.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc/ui/widgets/lesson/lesson_tile.dart';
import 'package:refilc_mobile_ui/common/panel/panel.dart';
import 'package:refilc_mobile_ui/common/progress_bar.dart';
import 'package:refilc_mobile_ui/common/round_border_icon.dart';
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
    // TODO: REMOVE IN PRODUCTION BUILD!!!
    /*liveCard.currentState = LiveCardState.duringLesson;
    liveCard.currentLesson = Lesson(
      date: DateTime.now().add(const Duration(
        minutes: 30,
      )),
      subject: GradeSubject(
          category: Category(id: 'asd'), id: 'asd', name: 'Matematika'),
      lessonIndex: '1',
      teacher: Teacher(id: 'id', name: 'name'),
      start: DateTime.now().subtract(const Duration(
        minutes: 30,
      )),
      end: DateTime.now().add(const Duration(
        minutes: 15,
      )),
      homeworkId: 'homeworkId',
      id: 'id',
      description: 'description',
      room: 'ABC69',
      groupName: 'groupName',
      name: 'name',
    );*/

    // liveCard.nextLesson = liveCard.currentLesson;

    // final dt = DateTime(2024, 3, 22, 17, 12, 1, 1, 1);

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
                              SegmentedCountdown(
                                  date: liveCard.nextLesson!.start),
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
                                    '${DateFormat('H:mm').format(liveCard.nextLesson!.start)} - ${DateFormat('H:mm').format(liveCard.nextLesson!.end)}',
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

        // child = LiveCardWidget(
        //   key: const Key('livecard.duringLesson'),
        //   liveCardState: liveCard.currentState,
        //   leading: liveCard.currentLesson!.lessonIndex +
        //       (RegExp(r'\d').hasMatch(liveCard.currentLesson!.lessonIndex)
        //           ? "."
        //           : ""),
        //   title: liveCard.currentLesson!.subject.renamedTo ??
        //       liveCard.currentLesson!.subject.name.capital(),
        //   titleItalic: liveCard.currentLesson!.subject.isRenamed &&
        //       settingsProvider.renamedSubjectsEnabled &&
        //       settingsProvider.renamedSubjectsItalics,
        //   subtitle: liveCard.currentLesson!.room,
        //   icon: SubjectIcon.resolveVariant(
        //       subject: liveCard.currentLesson!.subject, context: context),
        //   description: liveCard.currentLesson!.description != ""
        //       ? Text(liveCard.currentLesson!.description)
        //       : null,
        //   nextSubject: liveCard.nextLesson?.subject.renamedTo ??
        //       liveCard.nextLesson?.subject.name.capital(),
        //   nextSubjectItalic: liveCard.nextLesson?.subject.isRenamed == true &&
        //       settingsProvider.renamedSubjectsEnabled &&
        //       settingsProvider.renamedSubjectsItalics,
        //   nextRoom: liveCard.nextLesson?.room,
        //   progressMax: showMinutes ? maxTime / 60 : maxTime,
        //   progressCurrent: showMinutes ? elapsedTime / 60 : elapsedTime,
        //   progressAccuracy:
        //       showMinutes ? ProgressAccuracy.minutes : ProgressAccuracy.seconds,
        //   onProgressTap: () {
        //     showDialog(
        //       barrierColor: Colors.black,
        //       context: context,
        //       builder: (context) =>
        //           HeadsUpCountdown(maxTime: maxTime, elapsedTime: elapsedTime),
        //     );
        //   },
        // );
        // var titleItalic = liveCard.currentLesson!.subject.isRenamed &&
        //     settingsProvider.renamedSubjectsEnabled &&
        //     settingsProvider.renamedSubjectsItalics;
        var nextSubject = liveCard.nextLesson?.subject.renamedTo ??
            liveCard.nextLesson?.subject.name.capital();
        var nextSubjectItalic =
            liveCard.nextLesson?.subject.isRenamed == true &&
                settingsProvider.renamedSubjectsEnabled &&
                settingsProvider.renamedSubjectsItalics;
        var progressMax = showMinutes ? maxTime / 60 : maxTime;
        var progressCurrent = showMinutes ? elapsedTime / 60 : elapsedTime;
        var progressAccuracy =
            showMinutes ? ProgressAccuracy.minutes : ProgressAccuracy.seconds;

        child = LiveCardWidget(
          key: const Key('livecard.duringLesson'),
          children: liveCard.currentLesson != null
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
                          horizontal: 12.0,
                          vertical: 0.0,
                        ),
                        spacing: 0.0,
                        children: [
                          LessonTile(
                            liveCard.currentLesson!,
                            swapRoom: true,
                            currentLessonIndicator: false,
                            padding:
                                const EdgeInsets.only(top: 2.0, bottom: 4.0),
                            contentPadding: EdgeInsets.zero,
                            showSubTiles: false,
                          ),
                          if (!(nextSubject == null &&
                              progressCurrent == null &&
                              progressMax == null))
                            Row(
                              children: [
                                const SizedBox(
                                  width: 5.0,
                                ),
                                if (progressCurrent != null &&
                                    progressMax != null)
                                  GestureDetector(
                                    onTap: () async {
                                      SystemChrome.setPreferredOrientations([
                                        DeviceOrientation.portraitUp,
                                        DeviceOrientation.portraitDown,
                                        DeviceOrientation.landscapeRight,
                                        DeviceOrientation.landscapeLeft,
                                      ]);

                                      SystemChrome.setSystemUIOverlayStyle(
                                          const SystemUiOverlayStyle(
                                        statusBarColor: Colors.transparent,
                                        statusBarIconBrightness:
                                            Brightness.dark,
                                        systemNavigationBarColor:
                                            Colors.transparent,
                                        systemNavigationBarIconBrightness:
                                            Brightness.dark,
                                      ));

                                      var result = await showDialog(
                                        barrierColor: Colors.black,
                                        context: context,
                                        builder: (context) => HeadsUpCountdown(
                                            maxTime: maxTime,
                                            elapsedTime: elapsedTime),
                                      );

                                      if (result != null) {
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.portraitUp,
                                        ]);
                                      }
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Text(
                                        "remaining ${progressAccuracy == ProgressAccuracy.minutes ? 'min' : 'sec'}"
                                            .plural(
                                                (progressMax - progressCurrent)
                                                    .round()),
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.of(context)
                                              .text
                                              .withOpacity(.75),
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          if (progressCurrent != null && progressMax != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 12.0),
                              child: ProgressBar(
                                  value: progressCurrent / progressMax),
                            )
                        ],
                      ),
                      SplittedPanel(
                        hasShadow: false,
                        isTransparent: true,
                        padding: EdgeInsets.zero,
                        cardPadding: const EdgeInsets.symmetric(
                          horizontal: 18.0,
                          vertical: 11.0,
                        ),
                        spacing: 0.0,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    liveCard.nextLesson == null
                                        ? Icons.home_outlined
                                        : SubjectIcon.resolveVariant(
                                            context: context,
                                            subject:
                                                liveCard.nextLesson!.subject,
                                          ),
                                    size: 23.0,
                                  ),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    (liveCard.nextLesson?.subject
                                                    .isRenamed ??
                                                false
                                            ? liveCard
                                                .nextLesson?.subject.renamedTo
                                            : liveCard
                                                .nextLesson?.subject.name) ??
                                        'go_home'.i18n,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: nextSubjectItalic
                                          ? FontStyle.italic
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: liveCard.nextLesson != null
                                    ? [
                                        Container(
                                          width: (liveCard.nextLesson?.room
                                                          .length ??
                                                      0) >
                                                  20
                                              ? 111
                                              : null,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.5, vertical: 3.0),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary
                                                .withOpacity(.15),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Text(
                                            liveCard.nextLesson!.room,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              height: 1.1,
                                              fontSize: 12.0,
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
                                          '${DateFormat('H:mm').format(liveCard.nextLesson!.start)} - ${DateFormat('H:mm').format(liveCard.nextLesson!.end)}',
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ]
                                    : [],
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
      case LiveCardState.duringBreak:
        if (liveCard.prevLesson == null || liveCard.nextLesson == null) {
          child = Container();
          break;
        }

        // final iconFloorMap = {
        //   "to room": FeatherIcons.chevronsRight,
        //   "up floor": FilcIcons.upstairs,
        //   "down floor": FilcIcons.downstairs,
        //   "ground floor": FilcIcons.downstairs,
        // };

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

        // child = LiveCardWidget(
        //   key: const Key('livecard.duringBreak'),
        //   title: "break".i18n,
        //   icon: iconFloorMap[diff],
        //   description: liveCard.nextLesson!.room != liveCard.prevLesson!.room
        //       ? Text("go $diff".i18n.fill([
        //           diff != "to room"
        //               ? (liveCard.nextLesson!.getFloor() ?? 0)
        //               : liveCard.nextLesson!.room
        //         ]))
        //       : Text("stay".i18n),
        //   nextSubject: liveCard.nextLesson?.subject.renamedTo ??
        //       liveCard.nextLesson?.subject.name.capital(),
        //   nextSubjectItalic: liveCard.nextLesson?.subject.isRenamed == true &&
        //       settingsProvider.renamedSubjectsItalics,
        //   nextRoom: diff != "to room" ? liveCard.nextLesson?.room : null,
        //   progressMax: showMinutes ? maxTime / 60 : maxTime,
        //   progressCurrent: showMinutes ? elapsedTime / 60 : elapsedTime,
        //   progressAccuracy:
        //       showMinutes ? ProgressAccuracy.minutes : ProgressAccuracy.seconds,
        //   onProgressTap: () {
        //     showDialog(
        //       barrierColor: Colors.black,
        //       context: context,
        //       builder: (context) => HeadsUpCountdown(
        //         maxTime: maxTime,
        //         elapsedTime: elapsedTime,
        //       ),
        //     );
        //   },
        // );

        var nextSubject = liveCard.nextLesson?.subject.renamedTo ??
            liveCard.nextLesson?.subject.name.capital();
        var nextSubjectItalic =
            liveCard.nextLesson?.subject.isRenamed == true &&
                settingsProvider.renamedSubjectsItalics;
        // var nextRoom = diff != "to room" ? liveCard.nextLesson?.room : null;
        var progressMax = showMinutes ? maxTime / 60 : maxTime;
        var progressCurrent = showMinutes ? elapsedTime / 60 : elapsedTime;
        var progressAccuracy =
            showMinutes ? ProgressAccuracy.minutes : ProgressAccuracy.seconds;

        // Lesson breakLesson = Lesson(
        //   date: DateTime.now(),
        //   start: liveCard.prevLesson!.end,
        //   end: liveCard.nextLesson!.start,
        //   name: 'break'.i18n,
        //   description: 'Menj a XY terembe...',
        // );

        child = LiveCardWidget(
          key: const Key('livecard.duringBreak'),
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
                          horizontal: 12.0,
                          vertical: 0.0,
                        ),
                        spacing: 0.0,
                        children: [
                          // LessonTile(
                          //   liveCard.currentLesson!,
                          //   swapRoom: true,
                          //   currentLessonIndicator: false,
                          //   padding:
                          //       const EdgeInsets.only(top: 8.0, bottom: 4.0),
                          //   contentPadding: EdgeInsets.zero,
                          // ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 4.0),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12.0),
                              child: Visibility(
                                visible:
                                    liveCard.nextLesson!.subject.id != '' ||
                                        liveCard.nextLesson!.isEmpty,
                                replacement: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: PanelTitle(
                                      title: Text(liveCard.nextLesson!.name)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      minVerticalPadding: 0.0,
                                      dense: true,
                                      // onLongPress: kDebugMode ? () => log(jsonEncode(lesson.json)) : null,
                                      visualDensity: VisualDensity.compact,
                                      contentPadding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                      title: Text(
                                        "break".i18n,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.5,
                                            color: AppColors.of(context)
                                                .text
                                                .withOpacity(!liveCard
                                                        .nextLesson!.isEmpty
                                                    ? 1.0
                                                    : 0.5),
                                            fontStyle: liveCard.nextLesson!
                                                        .subject.isRenamed &&
                                                    settingsProvider
                                                        .renamedSubjectsItalics
                                                ? FontStyle.italic
                                                : null),
                                      ),

                                      subtitle: DefaultTextStyle(
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15.0,
                                              height: 1.0,
                                              color: AppColors.of(context)
                                                  .text
                                                  .withOpacity(.75),
                                            ),
                                        maxLines: !(nextSubject == null &&
                                                progressCurrent == null &&
                                                progressMax == null)
                                            ? 1
                                            : 2,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        child: liveCard.nextLesson!.room !=
                                                liveCard.prevLesson!.room
                                            ? Text("go $diff".i18n.fill([
                                                diff != "to room"
                                                    ? (liveCard.nextLesson!
                                                            .getFloor() ??
                                                        0)
                                                    : liveCard.nextLesson!.room
                                              ]))
                                            : Text("stay".i18n),
                                      ),

                                      // subtitle: description != ""
                                      //     ? Text(
                                      //         description,
                                      //         style: const TextStyle(
                                      //           fontWeight: FontWeight.w500,
                                      //           fontSize: 14.0,
                                      //         ),
                                      //         maxLines: 1,
                                      //         softWrap: false,
                                      //         overflow: TextOverflow.ellipsis,
                                      //       )
                                      //     : null,
                                      minLeadingWidth: 34.0,
                                      leading: AspectRatio(
                                        aspectRatio: 1,
                                        child: Center(
                                          child: Stack(
                                            children: [
                                              RoundBorderIcon(
                                                color:
                                                    AppColors.of(context).text,
                                                width: 1.0,
                                                icon: const SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.local_cafe,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // xix alignment hack :p
                                              const Opacity(
                                                  opacity: 0,
                                                  child: Text("EE:EE")),
                                              Text(
                                                "${DateFormat("H:mm").format(liveCard.prevLesson!.end)}\n${DateFormat("H:mm").format(liveCard.nextLesson!.start)}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.of(context)
                                                      .text
                                                      .withOpacity(.9),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (!(nextSubject == null &&
                              progressCurrent == null &&
                              progressMax == null))
                            Row(
                              children: [
                                const SizedBox(
                                  width: 5.0,
                                ),
                                if (progressCurrent != null &&
                                    progressMax != null)
                                  GestureDetector(
                                    onTap: () async {
                                      SystemChrome.setPreferredOrientations([
                                        DeviceOrientation.portraitUp,
                                        DeviceOrientation.portraitDown,
                                        DeviceOrientation.landscapeRight,
                                        DeviceOrientation.landscapeLeft,
                                      ]);

                                      SystemChrome.setSystemUIOverlayStyle(
                                          const SystemUiOverlayStyle(
                                        statusBarColor: Colors.transparent,
                                        statusBarIconBrightness:
                                            Brightness.dark,
                                        systemNavigationBarColor:
                                            Colors.transparent,
                                        systemNavigationBarIconBrightness:
                                            Brightness.dark,
                                      ));

                                      var result = await showDialog(
                                        barrierColor: Colors.black,
                                        context: context,
                                        builder: (context) => HeadsUpCountdown(
                                            maxTime: maxTime,
                                            elapsedTime: elapsedTime),
                                      );

                                      if (result != null) {
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.portraitUp,
                                        ]);
                                      }
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Text(
                                        "remaining ${progressAccuracy == ProgressAccuracy.minutes ? 'min' : 'sec'}"
                                            .plural(
                                                (progressMax - progressCurrent)
                                                    .round()),
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.of(context)
                                              .text
                                              .withOpacity(.75),
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          if (progressCurrent != null && progressMax != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 12.0),
                              child: ProgressBar(
                                  value: progressCurrent / progressMax),
                            )
                        ],
                      ),
                      SplittedPanel(
                        hasShadow: false,
                        isTransparent: true,
                        padding: EdgeInsets.zero,
                        cardPadding: const EdgeInsets.symmetric(
                          horizontal: 18.0,
                          vertical: 11.0,
                        ),
                        spacing: 0.0,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    liveCard.nextLesson == null
                                        ? Icons.home_outlined
                                        : SubjectIcon.resolveVariant(
                                            context: context,
                                            subject:
                                                liveCard.nextLesson!.subject,
                                          ),
                                    size: 23.0,
                                  ),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    (liveCard.nextLesson?.subject
                                                    .isRenamed ??
                                                false
                                            ? liveCard
                                                .nextLesson?.subject.renamedTo
                                            : liveCard
                                                .nextLesson?.subject.name) ??
                                        'go_home'.i18n,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: nextSubjectItalic
                                          ? FontStyle.italic
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: liveCard.nextLesson != null
                                    ? [
                                        Container(
                                          width: (liveCard.nextLesson?.room
                                                          .length ??
                                                      0) >
                                                  20
                                              ? 111
                                              : null,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.5, vertical: 3.0),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary
                                                .withOpacity(.15),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Text(
                                            liveCard.nextLesson!.room,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              height: 1.1,
                                              fontSize: 12.0,
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
                                          '${DateFormat('H:mm').format(liveCard.nextLesson!.start)} - ${DateFormat('H:mm').format(liveCard.nextLesson!.end)}',
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ]
                                    : [],
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
