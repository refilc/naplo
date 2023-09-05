import 'package:filcnaplo/models/ad.dart';
import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/ad/ad_viewable.dart'
    as mobile;

List<DateWidget> getWidgets(List<Ad> providerAds) {
  List<DateWidget> items = [];

  if (providerAds.isNotEmpty) {
    for (var ad in providerAds) {
      if (ad.date.isBefore(DateTime.now())) {
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
