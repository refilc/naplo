import 'dart:ui';

import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:filcnaplo_mobile_ui/premium/premium_screen.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class PremiumButton extends StatefulWidget {
  const PremiumButton({Key? key}) : super(key: key);

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> with TickerProviderStateMixin {
  late final AnimationController _animation;
  bool _heldDown = false;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animation.repeat();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openColor: Theme.of(context).scaffoldBackgroundColor,
      closedColor: Theme.of(context).scaffoldBackgroundColor,
      clipBehavior: Clip.none,
      transitionType: ContainerTransitionType.fadeThrough,
      openElevation: 0,
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      openBuilder: (context, _) => const PremiumScreen(),
      closedBuilder: (context, action) => GestureDetector(
        onTapDown: (_) => setState(() => _heldDown = true),
        onTapUp: (_) => setState(() => _heldDown = false),
        onTapCancel: () => setState(() => _heldDown = false),
        onTap: action,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // RGB background animation
            AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: SweepGradient(colors: const [
                              Colors.blue,
                              Colors.orange,
                              Colors.purple,
                              Colors.blue,
                            ], transform: GradientRotation(_animation.value * 6.283185)),
                          ),
                        ),
                      ),
                    ),
                  );
                }),

            // Button background & text
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                scale: _heldDown ? 1.03 : 1,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.0),
                    gradient: const LinearGradient(colors: [
                      Color(0xff124F3D),
                      Color(0xff1EA18F),
                    ]),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(FilcIcons.premium, color: Colors.white),
                      SizedBox(width: 12.0),
                      Text(
                        "Filc Napló Premium",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
