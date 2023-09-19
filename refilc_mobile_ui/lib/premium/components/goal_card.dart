import 'dart:ui';

import 'package:flutter/material.dart';

class PremiumGoalCard extends StatelessWidget {
  const PremiumGoalCard({Key? key, this.progress = 100, this.target = 1}) : super(key: key);

  final double progress;
  final double target;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cél: ${target.round()} támogató",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.2),
                    borderRadius: BorderRadius.circular(45.0),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, size) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            height: 12,
                            width: size.maxWidth * (progress / 100),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFFFF2A9D), Color(0xFFFF37F7)]),
                              borderRadius: BorderRadius.circular(45.0),
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(-15.0, 0),
                            child: Stack(
                              children: [
                                ImageFiltered(
                                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Image.asset("assets/images/heart.png", color: Colors.black.withOpacity(.3)),
                                ),
                                Image.asset("assets/images/heart.png"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
