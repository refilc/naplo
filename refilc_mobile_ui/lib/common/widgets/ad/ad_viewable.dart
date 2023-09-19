import 'package:refilc/models/ad.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ad_tile.dart';

class AdViewable extends StatelessWidget {
  const AdViewable(this.ad, {Key? key}) : super(key: key);

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    return AdTile(
      ad,
      onTap: () => launchUrl(
        ad.launchUrl,
        mode: LaunchMode.externalApplication,
      ),
    );
  }
}
