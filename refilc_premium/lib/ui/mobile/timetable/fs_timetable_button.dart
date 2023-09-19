import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/controllers/timetable_controller.dart';
import 'package:refilc_mobile_ui/common/system_chrome.dart';
import 'package:refilc_premium/models/premium_scopes.dart';
import 'package:refilc_premium/providers/premium_provider.dart';
import 'package:refilc_premium/ui/mobile/premium/upsell.dart';
import 'package:refilc_premium/ui/mobile/timetable/fs_timetable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:refilc_mobile_ui/pages/timetable/timetable_page.i18n.dart';

class PremiumFSTimetableButton extends StatelessWidget {
  const PremiumFSTimetableButton(
      {Key? key, required this.controller, required this.tabcontroller})
      : super(key: key);

  final TimetableController controller;
  final TabController tabcontroller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        splashRadius: 24.0,
        onPressed: () {
          if (!Provider.of<PremiumProvider>(context, listen: false)
              .hasScope(PremiumScopes.fsTimetable)) {
            PremiumLockedFeatureUpsell.show(
                context: context, feature: PremiumFeature.weeklytimetable);
            return;
          }

          // If timetable empty, show empty
          if (tabcontroller.length == 0) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("empty_timetable".i18n),
              duration: const Duration(seconds: 2),
            ));
            return;
          }

          Navigator.of(context, rootNavigator: true)
              .push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PremiumFSTimetable(
              controller: controller,
            ),
          ))
              .then((_) {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
            setSystemChrome(context);
          });
        },
        icon: Icon(FeatherIcons.trello, color: AppColors.of(context).text),
      ),
    );
  }
}
