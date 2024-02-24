import 'dart:io';

import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc_mobile_ui/common/personality_card/empty_card.dart';
import 'package:refilc_mobile_ui/common/personality_card/personality_card.dart';
import 'package:refilc_mobile_ui/screens/summary/summary_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class PersonalityBody extends StatefulWidget {
  const PersonalityBody({super.key});

  @override
  PersonalityBodyState createState() => PersonalityBodyState();
}

class PersonalityBodyState extends State<PersonalityBody> {
  late UserProvider user;

  bool isRevealed = false;

  ScreenshotController screenshotController = ScreenshotController();

  sharePersonality() async {
    await screenshotController.capture().then((image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        if (await File('${directory.path}/refilc_personality.png').exists()) {
          await File('${directory.path}/refilc_personality.png').delete();
        }
        final imagePath =
            await File('${directory.path}/refilc_personality.png').create();
        await imagePath.writeAsBytes(image);

        await Share.shareXFiles([XFile(imagePath.path)]);
      }
    }).catchError((err) {
      throw err;
    });
  }

  savePersonality() async {
    await screenshotController.capture().then((image) async {
      if (image != null) {
        await ImageGallerySaver.saveImage(image, name: 'refilc_personality');
      }
    }).catchError((err) {
      throw err;
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);

    return Expanded(
      child: ListView(
        children: [
          const SizedBox(height: 30),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 1000),
            sizeCurve: Curves.easeInToLinear,
            firstChild: Screenshot(
              controller: screenshotController,
              child: PersonalityCard(user: user),
            ),
            secondChild: GestureDetector(
              onTap: () => setState(() {
                isRevealed = true;
              }),
              child: EmptyCard(text: 'click_reveal'.i18n),
            ),
            crossFadeState: isRevealed
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          ),
          const SizedBox(height: 30),
          if (isRevealed)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await sharePersonality();
                    },
                    icon: const Icon(
                      FeatherIcons.share,
                      color: Colors.white,
                      size: 30,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.2)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () async {
                      await savePersonality();
                    },
                    icon: const Icon(
                      FeatherIcons.bookmark,
                      color: Colors.white,
                      size: 30,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.2)),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
