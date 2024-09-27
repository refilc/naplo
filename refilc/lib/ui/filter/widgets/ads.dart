import 'package:refilc/models/ad.dart';
import 'package:refilc/ui/date_widget.dart';
import 'package:refilc_mobile_ui/common/widgets/ad/ad_viewable.dart' as mobile;

List<DateWidget> getWidgets(List<Ad> providerAds, bool hasPlus) {
  List<DateWidget> items = [];

  if (providerAds.isNotEmpty) {
    for (var ad in providerAds) {
      if (ad.date.isBefore(DateTime.now()) &&
          ad.expireDate.isAfter(DateTime.now()) &&
          (!hasPlus || ad.overridePremium)) {
        providerAds.sort((a, b) => -a.date.compareTo(b.date));

        items.add(DateWidget(
          key: ad.description,
          date: ad.date,
          widget: mobile.AdViewable(ad),
        ));
      }
    }
  }

  return items;
}
