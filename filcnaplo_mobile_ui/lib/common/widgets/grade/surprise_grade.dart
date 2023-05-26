import 'dart:math';
import 'dart:ui';

import 'package:animated_background/animated_background.dart' as bg;
import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_mobile_ui/pages/home/particle.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:rive/rive.dart' as rive;

import 'new_grades.i18n.dart';

class SurpriseGrade extends StatefulWidget {
  const SurpriseGrade(this.grade, {Key? key}) : super(key: key);

  final Grade grade;

  @override
  State<SurpriseGrade> createState() => _SurpriseGradeState();
}

class _SurpriseGradeState extends State<SurpriseGrade> with TickerProviderStateMixin {
  late AnimationController _revealAnimFade;
  late AnimationController _revealAnimScale;
  late AnimationController _revealAnimGrade;
  late AnimationController _revealAnimParticle;
  late rive.RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _revealAnimFade = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _revealAnimScale = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _revealAnimGrade = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _revealAnimParticle = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _revealAnimScale.animateTo(0.7, duration: Duration.zero);
    _controller = rive.SimpleAnimation('Timeline 1', autoplay: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _revealAnimFade.animateTo(1.0, curve: Curves.easeInOut);
      Future.delayed(const Duration(milliseconds: 200), () {
        _revealAnimScale.animateTo(1.0, curve: Curves.easeInOut).then((_) {
          setState(() => subtitle = true);
        });
      });
    });

    seed = Random().nextInt(100000000);
  }

  @override
  void dispose() {
    _revealAnimFade.dispose();
    _revealAnimScale.dispose();
    _revealAnimGrade.dispose();
    _revealAnimParticle.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool hold = false;
  bool subtitle = false;
  late int seed;

  void reveal() async {
    if (!subtitle) {
      _revealAnimParticle.animateBack(0.0, curve: Curves.fastLinearToSlowEaseIn, duration: const Duration(milliseconds: 300));
      await Future.delayed(const Duration(milliseconds: 50));
      _revealAnimGrade.animateBack(0.0, curve: Curves.fastLinearToSlowEaseIn);
      await Future.delayed(const Duration(milliseconds: 50));
      _revealAnimFade.animateBack(0.0, curve: Curves.easeInOut);
      _revealAnimScale.animateBack(0.0, curve: Curves.easeInOut);
      if (mounted) Navigator.of(context).pop();
      return;
    }
    subtitle = false;
    setState(() => hold = false);
    _controller.isActive = true;
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) _revealAnimGrade.animateTo(1.0, curve: Curves.fastLinearToSlowEaseIn);
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) await _revealAnimParticle.animateTo(1.0, curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _revealAnimFade,
      builder: (context, child) {
        return FadeTransition(
          opacity: _revealAnimFade,
          child: Material(
            color: Colors.black.withOpacity(.75),
            child: Container(
              color: Theme.of(context).colorScheme.secondary.withOpacity(.05),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.transparent, Colors.black],
                    radius: 1.5,
                    stops: [0.2, 1.0],
                  ),
                ),
                child: bg.AnimatedBackground(
                  vsync: this,
                  behaviour: bg.RandomParticleBehaviour(
                    options: bg.ParticleOptions(
                      baseColor: Theme.of(context).colorScheme.secondary,
                      spawnMinSpeed: 5.0,
                      spawnMaxSpeed: 10.0,
                      minOpacity: .05,
                      maxOpacity: .08,
                      spawnMinRadius: 30.0,
                      spawnMaxRadius: 50.0,
                      particleCount: 20,
                    ),
                  ),
                  child: ScaleTransition(
                    scale: _revealAnimScale,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: AnimatedBuilder(
          animation: _revealAnimGrade,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideTransition(
                      position: _revealAnimGrade.drive(Tween(begin: Offset.zero, end: const Offset(0, 0.7))),
                      child: AnimatedScale(
                        scale: hold ? 1.1 : 1.0,
                        curve: Curves.easeOutBack,
                        duration: const Duration(milliseconds: 200),
                        child: GestureDetector(
                          onLongPressDown: (_) => setState(() => hold = true),
                          onLongPressEnd: (_) => reveal(),
                          onLongPressCancel: reveal,
                          child: ScaleTransition(
                            scale: CurvedAnimation(curve: Curves.easeInOut, parent: _revealAnimGrade.drive(Tween(begin: 1.0, end: 0.8))),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 300,
                                  height: 300,
                                  child: rive.RiveAnimation.asset(
                                    "assets/animations/backpack-2.riv",
                                    fit: BoxFit.contain,
                                    controllers: [_controller],
                                    antialiasing: false,
                                  ),
                                ),
                                SlideTransition(
                                  position: _revealAnimParticle.drive(Tween(begin: const Offset(0, 0.3), end: const Offset(0, 0.8))),
                                  child: FadeTransition(
                                    opacity: _revealAnimParticle,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24.0),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 32.0, sigmaY: 32.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(.3),
                                            borderRadius: BorderRadius.circular(24.0),
                                            border: Border.all(color: Colors.black.withOpacity(.3), width: 1.0),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    if (widget.grade.description != "")
                                                      Text(
                                                        widget.grade.description,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 26.0,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    Text(
                                                      widget.grade.subject.renamedTo ?? widget.grade.subject.name.capital(),
                                                      style: TextStyle(
                                                          color: Colors.white.withOpacity(.8),
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 24.0,
                                                          fontStyle: widget.grade.subject.isRenamed ? FontStyle.italic : null),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      "${widget.grade.value.weight}%",
                                                      style: TextStyle(
                                                        color: Colors.white.withOpacity(.7),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 20.0,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 20.0),
                                              Icon(
                                                SubjectIcon.resolveVariant(subject: widget.grade.subject, context: context),
                                                color: Colors.white,
                                                size: 82.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 42.0),
                    AnimatedOpacity(
                      opacity: subtitle ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        "open_subtitle".i18n,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.8),
                          fontWeight: FontWeight.w600,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_revealAnimGrade.value > 0)
                  AnimatedBuilder(
                    animation: _revealAnimParticle,
                    builder: (context, child) {
                      bool shouldPaint = false;
                      if (_revealAnimParticle.status == AnimationStatus.forward || _revealAnimParticle.status == AnimationStatus.reverse) {
                        shouldPaint = true;
                      }
                      return ScaleTransition(
                        scale: _revealAnimGrade,
                        child: FadeTransition(
                          opacity: _revealAnimGrade,
                          child: SlideTransition(
                            position: _revealAnimGrade.drive(Tween(begin: Offset.zero, end: const Offset(0, -0.6))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SlideTransition(
                                  position: _revealAnimGrade.drive(Tween(begin: Offset.zero, end: const Offset(0, -0.9))),
                                  child: Text(
                                    ["legendary", "epic", "rare", "uncommon", "common"][5 - widget.grade.value.value].i18n,
                                    style: TextStyle(
                                      fontSize: 46.0,
                                      fontWeight: FontWeight.bold,
                                      color: gradeColor(context: context, value: widget.grade.value.value),
                                      shadows: [
                                        Shadow(
                                          color: gradeColor(context: context, value: widget.grade.value.value).withOpacity(.5),
                                          blurRadius: 24.0,
                                        ),
                                        Shadow(
                                          color: gradeColor(context: context, value: widget.grade.value.value).withOpacity(.3),
                                          offset: const Offset(-3, -3),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32.0),
                                ScaleTransition(
                                  scale: CurvedAnimation(curve: Curves.easeInOutBack, parent: _revealAnimParticle.drive(Tween(begin: 0.6, end: 1.0))),
                                  child: CustomPaint(
                                    painter: PimpPainter(
                                      particle: Sprinkles(),
                                      controller: _revealAnimParticle,
                                      seed: seed + 1,
                                      shouldPaint: shouldPaint,
                                    ),
                                    child: CustomPaint(
                                      painter: PimpPainter(
                                        particle: Sprinkles(),
                                        controller: _revealAnimParticle,
                                        seed: seed,
                                        shouldPaint: shouldPaint,
                                      ),
                                      child: RotationTransition(
                                        turns:
                                            CurvedAnimation(curve: Curves.easeInBack, parent: _revealAnimGrade).drive(Tween(begin: 0.95, end: 1.0)),
                                        child: GradeValueWidget(
                                          widget.grade.value,
                                          fill: true,
                                          contrast: true,
                                          shadow: true,
                                          outline: true,
                                          size: 100.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            );
          }),
    );
  }
}

class PimpPainter extends CustomPainter {
  PimpPainter({required this.particle, required this.seed, required this.controller, required this.shouldPaint}) : super(repaint: controller);

  final Particle particle;
  final int seed;
  final AnimationController controller;
  final bool shouldPaint;

  @override
  void paint(Canvas canvas, Size size) {
    if (shouldPaint) {
      canvas.translate(size.width / 2, size.height / 2);
      particle.paint(canvas, size, controller.value, seed);
    }
  }

  @override
  bool shouldRepaint(PimpPainter oldDelegate) => shouldPaint;
}

Color randomColor(int c) {
  c = c % 5;
  if (c == 0) return Colors.red.shade300;
  if (c == 1) return Colors.green.shade300;
  if (c == 2) return Colors.orange.shade300;
  if (c == 3) return Colors.blue.shade300;
  if (c == 4) return Colors.pink.shade300;
  if (c == 5) return Colors.brown.shade300;
  return Colors.black;
}

class Sprinkles extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    Random random = Random(seed);
    int randomMirrorOffset = random.nextInt(8) + 1;
    CompositeParticle(children: [
      Firework(),
      RectangleMirror.builder(
          numberOfParticles: 6,
          particleBuilder: (n) {
            return AnimatedPositionedParticle(
              begin: const Offset(0.0, -10.0),
              end: const Offset(0.0, -60.0),
              child: FadingRect(width: 5.0, height: 15.0, color: randomColor(n)),
            );
          },
          initialDistance: -pi / randomMirrorOffset),
    ]).paint(canvas, size, progress, seed);
  }
}
