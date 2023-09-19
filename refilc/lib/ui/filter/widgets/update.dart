import 'package:refilc/models/release.dart';
import 'package:refilc/ui/date_widget.dart';
import 'package:refilc_mobile_ui/common/widgets/update/update_viewable.dart'
    as mobile;

DateWidget getWidget(Release providerRelease) {
  return DateWidget(
    date: DateTime.now(),
    widget: mobile.UpdateViewable(providerRelease),
  );
}
