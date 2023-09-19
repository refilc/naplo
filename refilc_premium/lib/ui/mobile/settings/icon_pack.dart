import 'package:refilc/models/settings.dart';
import 'package:refilc_mobile_ui/common/panel/panel_button.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_helper.dart';
import 'package:refilc_premium/models/premium_scopes.dart';
import 'package:refilc_premium/providers/premium_provider.dart';
import 'package:refilc_premium/ui/mobile/premium/upsell.dart';
import 'package:flutter/material.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:refilc/utils/format.dart';

class PremiumIconPackSelector extends StatelessWidget {
  const PremiumIconPackSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return PanelButton(
      onPressed: () {
        if (!Provider.of<PremiumProvider>(context, listen: false)
            .hasScope(PremiumScopes.customIcons)) {
          PremiumLockedFeatureUpsell.show(
              context: context, feature: PremiumFeature.iconpack);
          return;
        }

        SettingsHelper.iconPack(context);
      },
      title: Text("icon_pack".i18n),
      leading: const Icon(FeatherIcons.grid),
      trailing: Text(
        settings.iconPack.name.capital(),
        style: const TextStyle(fontSize: 14.0),
      ),
    );
  }
}
