import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/bottom_sheet_menu_item.dart';
import 'package:filcnaplo_premium/models/premium_scopes.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:filcnaplo_premium/ui/mobile/premium/upsell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:provider/provider.dart';

class UserMenuNickname extends StatelessWidget {
  const UserMenuNickname({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetMenuItem(
      onPressed: () {
        if (!Provider.of<PremiumProvider>(context, listen: false).hasScope(PremiumScopes.nickname)) {
          PremiumLockedFeatureUpsell.show(context: context, feature: PremiumFeature.profile);
          return;
        }
        showDialog(context: context, builder: (context) => const UserNicknameEditor());
      },
      icon: const Icon(FeatherIcons.edit2),
      title: Text("edit_nickname".i18n),
    );
  }
}

class UserNicknameEditor extends StatefulWidget {
  const UserNicknameEditor({Key? key}) : super(key: key);

  @override
  State<UserNicknameEditor> createState() => _UserNicknameEditorState();
}

class _UserNicknameEditorState extends State<UserNicknameEditor> {
  final _userName = TextEditingController();
  late final UserProvider user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("change_username".i18n),
      content: TextField(
        controller: _userName,
        autofocus: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(user.name!),
          suffixIcon: IconButton(
            icon: const Icon(FeatherIcons.x),
            onPressed: () {
              setState(() {
                _userName.text = "";
              });
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            "cancel".i18n,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        TextButton(
          child: Text(
            "done".i18n,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            user.user!.nickname = _userName.text.trim();
            Provider.of<DatabaseProvider>(context, listen: false).store.storeUser(user.user!);
            Provider.of<UserProvider>(context, listen: false).refresh();
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
