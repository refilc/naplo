import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc_kreta_api/providers/grade_provider.dart';
import 'package:refilc_mobile_ui/screens/summary/summary_screen.dart';
import 'package:refilc_mobile_ui/screens/summary/summary_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

class StartBody extends StatefulWidget {
  const StartBody({super.key});

  @override
  StartBodyState createState() => StartBodyState();
}

class StartBodyState extends State<StartBody> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 40.0),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
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
                builder: (context, state) => const Material(
                  color: Colors.black,
                  child: SummaryScreen(
                    currentPage: 'grades',
                    isBottomSheet: true,
                  ),
                ),
              ),
            );
          },
          child: Center(
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
                  'start'.i18n,
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
        ),
        const SizedBox(height: 169.69),
      ],
    );
  }
}
