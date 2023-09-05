import 'package:filcnaplo/models/ad.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel_button.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class AdTile extends StatelessWidget {
  const AdTile(this.ad, {Key? key, this.onTap, this.padding}) : super(key: key);

  final Ad ad;
  final Function()? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
      child: PanelButton(
        onPressed: onTap,
        title: Column(
          children: [
            Text(ad.title),
            Text(ad.description),
          ],
        ),
        leading: Image.network(ad.logoUrl.toString()),
        trailing: const Icon(FeatherIcons.externalLink),
      ),
    );
  }
}
