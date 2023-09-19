import 'package:filcnaplo/models/release.dart';
import 'package:filcnaplo/ui/date_widget.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/update/update_viewable.dart' as mobile;

DateWidget getWidget(Release providerRelease) {
  return DateWidget(
    date: DateTime.now(),
    widget: mobile.UpdateViewable(providerRelease),
  );
}
