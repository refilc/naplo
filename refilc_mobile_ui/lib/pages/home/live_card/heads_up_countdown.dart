import 'dart:async';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HeadsUpCountdown extends StatefulWidget {
  const HeadsUpCountdown({Key? key, required this.maxTime, required this.elapsedTime}) : super(key: key);

  final double maxTime;
  final double elapsedTime;

  @override
  State<HeadsUpCountdown> createState() => _HeadsUpCountdownState();
}

class _HeadsUpCountdownState extends State<HeadsUpCountdown> {
  static const _style = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 70.0,
    letterSpacing: -.5,
  );

  late final Timer _timer;
  late double elapsed;

  @override
  void initState() {
    super.initState();
    elapsed = widget.elapsedTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (elapsed <= widget.maxTime) elapsed += 1;
      setState(() {});

      if (elapsed >= widget.maxTime) {
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dur = Duration(seconds: (widget.maxTime - elapsed).round());
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              opacity: dur.inSeconds > 0 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if ((dur.inHours % 24) > 0) ...[
                    AnimatedFlipCounter(
                      value: dur.inHours % 24,
                      curve: Curves.fastLinearToSlowEaseIn,
                      textStyle: _style,
                    ),
                    const Text(":", style: _style),
                  ],
                  AnimatedFlipCounter(
                    duration: const Duration(seconds: 2),
                    value: dur.inMinutes % 60,
                    curve: Curves.fastLinearToSlowEaseIn,
                    wholeDigits: (dur.inHours % 24) > 0 ? 2 : 1,
                    textStyle: _style,
                  ),
                  const Text(":", style: _style),
                  AnimatedFlipCounter(
                    duration: const Duration(seconds: 1),
                    value: dur.inSeconds % 60,
                    curve: Curves.fastLinearToSlowEaseIn,
                    wholeDigits: 2,
                    textStyle: _style,
                  ),
                ],
              ),
            ),
            if (dur.inSeconds < 0)
              AnimatedOpacity(
                opacity: dur.inSeconds > 0 ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 500),
                child: Lottie.asset("assets/animations/bell-alert.json", width: 400),
              ),
          ],
        ),
      ),
    );
  }
}
