import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter/material.dart';

class PlusScreen extends StatelessWidget {
  const PlusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.zero,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/premium_top_banner.png'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                Theme.of(context).scaffoldBackgroundColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.1, 0.15, 0.2, 0.25],
            ),
          ),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.0),
                      Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.4),
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.6, 0.7, 1.0],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'reFilc+',
                            style: TextStyle(
                              fontSize: 33,
                              color: Color(0xFF0a1c41),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              FeatherIcons.x,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Még több reFilc, olcsóbban,\nmint bármi más!',
                          style: const TextStyle(
                            height: 1.2,
                            fontSize: 22,
                            color: Color(0xFF0A1C41),
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(1.0, -5.5),
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    fontSize: 14.4,
                                    color: const Color(0xFF0A1C41)
                                        .withOpacity(0.5),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
