import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_mobile_ui/screens/summary/summary_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class StartBody extends StatefulWidget {
  const StartBody({Key? key}) : super(key: key);

  @override
  _StartBodyState createState() => _StartBodyState();
}

class _StartBodyState extends State<StartBody> {
  late UserProvider user;
  late GradeProvider gradeProvider;
  late SettingsProvider settings;

  late String firstName;

  @override
  void initState() {
    super.initState();

    gradeProvider = Provider.of<GradeProvider>(context, listen: false);
    settings = Provider.of<SettingsProvider>(context, listen: false);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jó éved volt, $firstName!',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 26.0,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Összegezzünk hát...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // IconButton(
            //   onPressed: () {
            //     Navigator.of(context).maybePop();
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) =>
            //             const SummaryScreen(currentPage: 'lessons'),
            //       ),
            //     );
            //   },
            //   icon: const Icon(
            //     FeatherIcons.arrowRight,
            //     color: Colors.white,
            //   ),
            // )
          ],
        ),
        const SizedBox(height: 40.0),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const SummaryScreen(currentPage: 'grades'),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                FeatherIcons.arrowRight,
                size: 145,
                color: Colors.white,
                grade: 0.001,
                weight: 0.001,
              ),
              Text(
                'Kezdés',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50.69),
      ],
    );
  }
}
