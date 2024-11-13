import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc/models/ad.dart';
import 'package:refilc/ui/date_widget.dart';
import 'package:refilc_mobile_ui/common/widgets/ad/ad_tile.dart';
import 'package:refilc_mobile_ui/common/widgets/ad/ad_viewable.dart' as mobile;
import 'package:refilc_mobile_ui/plus/plus_screen.dart';
import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:uuid/uuid.dart';

List<DateWidget> getWidgets(List<Ad> providerAds, BuildContext context) {
  List<DateWidget> items = [];

  bool hasPlus = Provider.of<PlusProvider>(context).hasPremium;

  DateWidget plusWidget = DateWidget(
    key: const Uuid().v4(),
    date: DateTime.now(),
    widget: AdTile(
      Ad(
        title: 'reFilc+',
        description:
            'Fizess elő reFilc+-ra, rejtsd el a hirdetéseket és támogasd az app működését!',
        author: '',
        logoUrl: Uri.parse('https://refilc.hu/image/brand/logo.png'),
        overridePremium: false,
        date: DateTime(2007, 6, 29, 9, 41),
        expireDate: DateTime.now().add(const Duration(days: 11)),
        launchUrl: Uri.parse('https://refilc.hu/plus'),
      ),
      onTap: () => Navigator.of(context, rootNavigator: true)
          .push(MaterialPageRoute(builder: (context) {
        return const PlusScreen();
      })),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      showExternalIcon: false,
    ),
  );

  if (providerAds.isNotEmpty) {
    for (var ad in providerAds) {
      if (ad.date.isBefore(DateTime.now()) &&
          ad.expireDate.isAfter(DateTime.now()) &&
          DateTime.now().hour.isOdd) {
        if (!hasPlus || ad.overridePremium) {
          providerAds.sort((a, b) => -a.date.compareTo(b.date));

          items.add(DateWidget(
            key: ad.description,
            date: ad.date,
            widget: mobile.AdViewable(ad),
          ));
        }
      } else {
        if (DateTime.now().weekday == DateTime.saturday &&
            items.isEmpty &&
            !hasPlus) {
          items.add(plusWidget);
        }
      }
    }
  } else {
    if (DateTime.now().weekday == DateTime.saturday &&
        items.isEmpty &&
        !hasPlus) {
      items.add(plusWidget);
    }
  }

  return items;
}
