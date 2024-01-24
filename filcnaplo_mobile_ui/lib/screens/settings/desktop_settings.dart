import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
// import 'package:filcnaplo/utils/format.dart';
// import 'package:filcnaplo_kreta_api/models/teacher.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
// import 'package:refilc_plus/models/premium_scopes.dart';
// import 'package:refilc_plus/providers/premium_provider.dart';
// import 'package:refilc_plus/ui/mobile/premium/upsell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:filcnaplo_mobile_ui/common/beta_chip.dart';

class MenuDesktopSettings extends StatelessWidget {
  const MenuDesktopSettings({Key? key, required this.settings})
      : super(key: key);

  final SettingsProvider settings;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      padding: const EdgeInsets.only(left: 14.0),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(
              builder: (context) => const ModifyDesktopSettings()),
        );
      },
      title: Row(
        children: [
          Text(
            "desktop_settings".i18n,
            style: TextStyle(color: AppColors.of(context).text),
          ),
          const Spacer(),
          const BetaChip(),
          const Spacer()
        ],
      ),
      leading: Icon(FeatherIcons.monitor,
          color: Theme.of(context).colorScheme.secondary),
    );
  }
}

class ModifyDesktopSettings extends StatefulWidget {
  const ModifyDesktopSettings({Key? key}) : super(key: key);

  @override
  State<ModifyDesktopSettings> createState() => _ModifyDesktopSettingsState();
}

class _ModifyDesktopSettingsState extends State<ModifyDesktopSettings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late UserProvider user;
  late DatabaseProvider dbProvider;
  late SettingsProvider settings;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false);
    dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          leading: BackButton(color: AppColors.of(context).text),
          title: Text(
            "desktop_settings".i18n,
            style: TextStyle(color: AppColors.of(context).text),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
        ));
  }
}
