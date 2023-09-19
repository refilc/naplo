import 'package:refilc/models/ad.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:refilc_mobile_ui/common/panel/panel_button.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class AdTile extends StatelessWidget {
  const AdTile(this.ad, {Key? key, this.onTap, this.padding}) : super(key: key);

  final Ad ad;
  final Function()? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    print('geic');
    print(ad);

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
      child: PanelButton(
        padding: const EdgeInsets.only(left: 8.0, right: 16.0),
        onPressed: onTap,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ad.title,
            ),
            Text(
              ad.description,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.of(context).text.withOpacity(0.7),
              ),
            ),
          ],
        ),
        leading: ad.logoUrl != null
            ? Image.network(
                ad.logoUrl.toString(),
                errorBuilder: (context, error, stackTrace) {
                  ad.logoUrl = null;
                  return const SizedBox();
                },
              )
            : null,
        trailing: const Icon(FeatherIcons.externalLink),
      ),
    );
  }
}
