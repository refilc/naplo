// import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:provider/provider.dart';
import 'submenu_screen.i18n.dart';

class MenuPersonalizeSettings extends StatelessWidget {
  const MenuPersonalizeSettings({
    super.key,
    this.borderRadius = const BorderRadius.vertical(
        top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
  });

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      onPressed: () => Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(
            builder: (context) => const PersonalizeSettingsScreen()),
      ),
      title: Text("personalization".i18n),
      leading: Icon(
        FeatherIcons.droplet,
        size: 22.0,
        color: AppColors.of(context).text.withOpacity(0.95),
      ),
      trailing: Icon(
        FeatherIcons.chevronRight,
        size: 22.0,
        color: AppColors.of(context).text.withOpacity(0.95),
      ),
      borderRadius: borderRadius,
    );
  }
}

class PersonalizeSettingsScreen extends StatelessWidget {
  const PersonalizeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // SettingsProvider settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        title: Text(
          "personalization".i18n,
          style: TextStyle(color: AppColors.of(context).text),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
