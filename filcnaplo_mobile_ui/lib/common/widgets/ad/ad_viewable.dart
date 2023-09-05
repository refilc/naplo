import 'package:filcnaplo/models/ad.dart';
import 'package:flutter/material.dart';

import 'ad_tile.dart';

class AdViewable extends StatelessWidget {
  const AdViewable(this.ad, {Key? key}) : super(key: key);

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    return AdTile(
      ad,
      onTap: () => [],
    );
  }
}
