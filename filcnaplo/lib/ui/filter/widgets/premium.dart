import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo_premium/ui/mobile/premium/premium_banner_button.dart';
import 'package:flutter/widgets.dart';

DateWidget getWidget() {
  return DateWidget(
    date: DateTime.now().add(const Duration(minutes: 1)),
    widget: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.0),
        child: const PremiumBannerButton(),
      ),
    ),
  );
}
