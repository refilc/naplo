import 'package:confetti/confetti.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import 'summary_screen.i18n.dart';

import 'pages/allsum_page.dart';
import 'pages/start_page.dart';
import 'pages/grades_page.dart';
import 'pages/lessons_page.dart';
import 'pages/personality_page.dart';

class SummaryScreen extends StatefulWidget {
  final String currentPage;
  final bool isBottomSheet;

  const SummaryScreen({
    Key? key,
    this.currentPage = 'personality',
    this.isBottomSheet = false,
  }) : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();

  static show(
          {required BuildContext context,
          String currentPage = 'personality'}) =>
      Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
          builder: (context) => SummaryScreen(currentPage: currentPage)));
}

class _SummaryScreenState extends State<SummaryScreen>
    with SingleTickerProviderStateMixin {
  late UserProvider user;
  late SettingsProvider settings;

  ConfettiController? _confettiController;

  late String firstName;

  final LinearGradient _backgroundGradient = const LinearGradient(
    colors: [
      Color(0xff1d56ac),
      Color(0xff170a3d),
    ],
    begin: Alignment(-0.8, -1.0),
    end: Alignment(0.8, 1.0),
    stops: [-1.0, 1.0],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _confettiController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    settings = Provider.of<SettingsProvider>(context);

    List<String> nameParts = user.displayName?.split(" ") ?? ["?"];
    if (!settings.presentationMode) {
      firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];
    } else {
      firstName = "János";
    }

    return widget.isBottomSheet
        ? buildContainer()
        : Scaffold(
            body: buildContainer(),
          );
  }

  Widget buildContainer() {
    return Container(
      decoration: BoxDecoration(gradient: _backgroundGradient),
      child: Container(
        decoration: BoxDecoration(gradient: _backgroundGradient),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 15.0,
              bottom: 40.0,
            ),
            child: Column(
              crossAxisAlignment: widget.currentPage == 'start'
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisAlignment: widget.currentPage == 'start'
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'greeting'.i18n.fill([firstName]),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 26.0,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.currentPage == 'start'
                                ? 'title_start'.i18n
                                : widget.currentPage == 'grades'
                                    ? 'title_grades'.i18n
                                    : widget.currentPage == 'lessons'
                                        ? 'title_lessons'.i18n
                                        : widget.currentPage == 'personality'
                                            ? 'title_personality'.i18n
                                            : '',
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    widget.currentPage != 'start'
                        ? IconButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              if (widget.currentPage == 'grades') {
                                openNewPage(page: 'lessons');
                              } else if (widget.currentPage == 'lessons') {
                                openNewPage(page: 'allsum');
                              } else if (widget.currentPage == 'allsum') {
                                openNewPage(page: 'personality');
                              } else {
                                Navigator.of(context).maybePop();
                              }
                            },
                            icon: Icon(
                              widget.currentPage == 'personality'
                                  ? FeatherIcons.x
                                  : FeatherIcons.arrowRight,
                              color: Colors.white,
                            ),
                          )
                        : Container()
                  ],
                ),
                const SizedBox(height: 12.0),
                widget.currentPage == 'start'
                    ? const StartBody()
                    : widget.currentPage == 'grades'
                        ? const GradesBody()
                        : widget.currentPage == 'lessons'
                            ? const LessonsBody()
                            : widget.currentPage == 'allsum'
                                ? const AllSumBody()
                                : const PersonalityBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openNewPage({String page = 'personality'}) {
    showSlidingBottomSheet(
      context,
      useRootNavigator: true,
      builder: (context) => SlidingSheetDialog(
        color: Colors.black.withOpacity(0.99),
        duration: const Duration(milliseconds: 400),
        scrollSpec: const ScrollSpec.bouncingScroll(),
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [1.0],
          initialSnap: 1.0,
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        minHeight: MediaQuery.of(context).size.height,
        cornerRadius: 16,
        cornerRadiusOnFullscreen: 0,
        builder: (context, state) => Material(
          color: Colors.black,
          child: SummaryScreen(
            currentPage: page,
            isBottomSheet: true,
          ),
        ),
      ),
    );
    //SummaryScreen.show(context: context, currentPage: page);
  }
}
