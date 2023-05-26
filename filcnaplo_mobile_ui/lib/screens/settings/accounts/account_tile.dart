import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({Key? key, this.onTap, this.onTapMenu, this.profileImage, this.name, this.username}) : super(key: key);

  final void Function()? onTap;
  final void Function()? onTapMenu;
  final Widget? profileImage;
  final Widget? name;
  final Widget? username;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.only(left: 12.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onTap: onTap,
        onLongPress: onTapMenu,
        leading: profileImage,
        title: name,
        subtitle: username,
        trailing: onTapMenu != null
            ? Material(
                color: Colors.transparent,
                child: IconButton(
                  splashRadius: 24.0,
                  onPressed: onTapMenu,
                  icon: Icon(FeatherIcons.moreVertical, color: AppColors.of(context).text.withOpacity(0.8)),
                ),
              )
            : null,
      ),
    );
  }
}
