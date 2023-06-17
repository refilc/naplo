import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'pages/grades_page.dart';
import 'pages/lessons_page.dart';
import 'pages/personality_page.dart';

class SummaryScreen extends StatefulWidget {
  final String currentPage;

  const SummaryScreen({Key? key, this.currentPage = 'personality'})
      : super(key: key);

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _hideContainersController;
  ConfettiController? _confettiController;

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

    _hideContainersController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _confettiController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hideContainersController,
      builder: (context, child) => Opacity(
        opacity: 1 - _hideContainersController.value,
        child: Container(
          decoration: BoxDecoration(gradient: _backgroundGradient),
          child: Container(
            decoration: BoxDecoration(gradient: _backgroundGradient),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  top: MediaQuery.of(context).padding.top,
                  bottom: 52.0,
                ),
                child: widget.currentPage == 'grades'
                    ? const GradesBody()
                    : widget.currentPage == 'lessons'
                        ? const LessonsBody()
                        : widget.currentPage == 'allsum'
                            ? const GradesBody()
                            : const PersonalityBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
