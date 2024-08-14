// import 'package:refilc/models/settings.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_mobile_ui/common/panel/panel_button.dart';
import 'package:refilc_mobile_ui/common/splitted_panel/splitted_panel.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:refilc_plus/ui/mobile/settings/submenu/calendar_sync.dart';
import 'package:refilc_plus/ui/mobile/settings/submenu/grade_exporting.dart';
import 'package:refilc_plus/models/premium_scopes.dart';
import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:refilc_plus/ui/mobile/plus/upsell.dart';
import 'package:refilc_plus/ui/mobile/settings/welcome_message.dart';
// import 'package:provider/provider.dart';
import 'submenu_screen.i18n.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://stickermap.refilc.hu');

class MenuOtherSettings extends StatelessWidget {
  const MenuOtherSettings({
    super.key,
    this.borderRadius = const BorderRadius.vertical(
        top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
  });

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      onPressed: () => Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(builder: (context) => const ExtrasSettingsScreen()),
      ),
      title: Text("other".i18n),
      leading: Icon(
        FeatherIcons.hash,
        size: 22.0,
        color: AppColors.of(context).text.withOpacity(0.95),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FeatherIcons.chevronRight,
            size: 22.0,
            color: AppColors.of(context).text.withOpacity(0.95),
          )
        ],
      ),
      borderRadius: borderRadius,
    );
  }
}

class ExtrasSettingsScreen extends StatefulWidget {
  const ExtrasSettingsScreen({super.key});

  @override
  ExtrasSettingsScreenState createState() => ExtrasSettingsScreenState();
}

class ExtrasSettingsScreenState extends State<ExtrasSettingsScreen> {
  late SettingsProvider settingsProvider;
  late UserProvider user;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    UserProvider user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        title: Text(
          "other".i18n,
          style: TextStyle(color: AppColors.of(context).text),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            children: [
              SplittedPanel(
                padding: const EdgeInsets.only(top: 9.0),
                cardPadding: const EdgeInsets.all(4.0),
                isSeparated: true,
                children: [
                  PanelButton(
                    onPressed: _launchUrl,
                    title: Text(
                      "stickermap".i18n,
                      style: TextStyle(
                        color: AppColors.of(context).text.withOpacity(.95),
                      ),
                    ),
                    leading: Icon(
                      FeatherIcons.calendar,
                      size: 22.0,
                      color: AppColors.of(context).text.withOpacity(.95),
                    ),
                    trailing: Icon(
                      FeatherIcons.chevronRight,
                      size: 22.0,
                      color: AppColors.of(context).text.withOpacity(0.95),
                    ),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4.0),
                        bottom: Radius.circular(4.0)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
