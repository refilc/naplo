import 'package:refilc/models/release.dart';
import 'package:refilc_mobile_ui/common/widgets/update/update_tile.dart';
import 'package:refilc_mobile_ui/common/widgets/update/updates_view.dart';
import 'package:flutter/material.dart';

class UpdateViewable extends StatelessWidget {
  const UpdateViewable(this.release, {super.key});

  final Release release;

  @override
  Widget build(BuildContext context) {
    return UpdateTile(
      release,
      onTap: () => UpdateView.show(release, context: context),
    );
  }
}
