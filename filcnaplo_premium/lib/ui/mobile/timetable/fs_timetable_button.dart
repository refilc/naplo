import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/controllers/timetable_controller.dart';
import 'package:filcnaplo_mobile_ui/common/system_chrome.dart';
import 'package:filcnaplo_premium/models/premium_scopes.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:filcnaplo_premium/ui/mobile/premium/upsell.dart';
import 'package:filcnaplo_premium/ui/mobile/timetable/fs_timetable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class PremiumFSTimetableButton extends StatelessWidget {
  const PremiumFSTimetableButton({Key? key, required this.controller}) : super(key: key);

  final TimetableController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        splashRadius: 24.0,
        onPressed: () {
          if (!Provider.of<PremiumProvider>(context, listen: false).hasScope(PremiumScopes.fsTimetable)) {
            PremiumLockedFeatureUpsell.show(context: context, feature: PremiumFeature.weeklytimetable);
            return;
          }

          Navigator.of(context, rootNavigator: true)
              .push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => PremiumFSTimetable(
              controller: controller,
            ),
          ))
              .then((_) {
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
            setSystemChrome(context);
          });
        },
        icon: Icon(FeatherIcons.trello, color: AppColors.of(context).text),
      ),
    );
  }
}
