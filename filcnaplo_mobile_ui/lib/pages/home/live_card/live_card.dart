import 'package:animations/animations.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/heads_up_countdown.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo/api/providers/live_card_provider.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/live_card_widget.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'live_card.i18n.dart';

class LiveCard extends StatefulWidget {
  const LiveCard({Key? key}) : super(key: key);

  @override
  _LiveCardState createState() => _LiveCardState();
}

class _LiveCardState extends State<LiveCard> {
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

    if (!liveCard.show) return Container();

    Widget child;
    Duration bellDelay = liveCard.delay;

    switch (liveCard.currentState) {
      case LiveCardState.morning:
        child = LiveCardWidget(
          key: const Key('livecard.morning'),
          title: DateFormat("EEEE", I18n.of(context).locale.toString()).format(DateTime.now()).capital(),
          icon: FeatherIcons.sun,
          description: liveCard.nextLesson != null
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "first_lesson_1".i18n),
                      TextSpan(
                        text: liveCard.nextLesson!.subject.renamedTo ?? liveCard.nextLesson!.subject.name.capital(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary.withOpacity(.85),
                            fontStyle: liveCard.nextLesson!.subject.isRenamed ? FontStyle.italic : null),
                      ),
                      TextSpan(text: "first_lesson_2".i18n),
                      TextSpan(
                        text: liveCard.nextLesson!.room.capital(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(.85),
                        ),
                      ),
                      TextSpan(text: "first_lesson_3".i18n),
                      TextSpan(
                        text: DateFormat('H:mm').format(liveCard.nextLesson!.start),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(.85),
                        ),
                      ),
                      TextSpan(text: "first_lesson_4".i18n),
                    ],
                  ),
                )
              : null,
        );
        break;
      case LiveCardState.duringLesson:
        final elapsedTime = DateTime.now().difference(liveCard.currentLesson!.start).inSeconds.toDouble() + bellDelay.inSeconds;
        final maxTime = liveCard.currentLesson!.end.difference(liveCard.currentLesson!.start).inSeconds.toDouble();

        final showMinutes = maxTime - elapsedTime > 60;

        child = LiveCardWidget(
          key: const Key('livecard.duringLesson'),
          leading: liveCard.currentLesson!.lessonIndex + (RegExp(r'\d').hasMatch(liveCard.currentLesson!.lessonIndex) ? "." : ""),
          title: liveCard.currentLesson!.subject.renamedTo ?? liveCard.currentLesson!.subject.name.capital(),
          titleItalic: liveCard.currentLesson!.subject.isRenamed,
          subtitle: liveCard.currentLesson!.room,
          icon: SubjectIcon.resolveVariant(subject: liveCard.currentLesson!.subject, context: context),
          description: liveCard.currentLesson!.description != "" ? Text(liveCard.currentLesson!.description) : null,
          nextSubject: liveCard.nextLesson?.subject.renamedTo ?? liveCard.nextLesson?.subject.name.capital(),
          nextSubjectItalic: liveCard.nextLesson?.subject.isRenamed ?? false,
          nextRoom: liveCard.nextLesson?.room,
          progressMax: showMinutes ? maxTime / 60 : maxTime,
          progressCurrent: showMinutes ? elapsedTime / 60 : elapsedTime,
          progressAccuracy: showMinutes ? ProgressAccuracy.minutes : ProgressAccuracy.seconds,
          onProgressTap: () {
            showDialog(
              barrierColor: Colors.black,
              context: context,
              builder: (context) => HeadsUpCountdown(maxTime: maxTime, elapsedTime: elapsedTime),
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

        final maxTime = liveCard.nextLesson!.start.difference(liveCard.prevLesson!.end).inSeconds.toDouble();
        final elapsedTime = DateTime.now().difference(liveCard.prevLesson!.end).inSeconds.toDouble() + bellDelay.inSeconds.toDouble();

        final showMinutes = maxTime - elapsedTime > 60;

        child = LiveCardWidget(
          key: const Key('livecard.duringBreak'),
          title: "break".i18n,
          icon: iconFloorMap[diff],
          description: liveCard.nextLesson!.room != liveCard.prevLesson!.room
              ? Text("go $diff".i18n.fill([diff != "to room" ? (liveCard.nextLesson!.getFloor() ?? 0) : liveCard.nextLesson!.room]))
              : Text("stay".i18n),
          nextSubject: liveCard.nextLesson?.subject.renamedTo ?? liveCard.nextLesson?.subject.name.capital(),
          nextSubjectItalic: liveCard.nextLesson?.subject.isRenamed ?? false,
          nextRoom: diff != "to room" ? liveCard.nextLesson?.room : null,
          progressMax: showMinutes ? maxTime / 60 : maxTime,
          progressCurrent: showMinutes ? elapsedTime / 60 : elapsedTime,
          progressAccuracy: showMinutes ? ProgressAccuracy.minutes : ProgressAccuracy.seconds,
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
          title: DateFormat("EEEE", I18n.of(context).locale.toString()).format(DateTime.now()).capital(),
          icon: FeatherIcons.coffee,
        );
        break;
      case LiveCardState.night:
        child = LiveCardWidget(
          key: const Key('livecard.night'),
          title: DateFormat("EEEE", I18n.of(context).locale.toString()).format(DateTime.now()).capital(),
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
          child: child,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
        );
      },
      child: child,
    );
  }
}
