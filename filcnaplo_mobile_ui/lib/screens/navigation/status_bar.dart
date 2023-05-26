import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/api/providers/status_provider.dart';
import 'status_bar.i18n.dart';

class StatusBar extends StatefulWidget {
  const StatusBar({Key? key}) : super(key: key);

  @override
  _StatusBarState createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  late StatusProvider statusProvider;

  @override
  Widget build(BuildContext context) {
    statusProvider = Provider.of<StatusProvider>(context);

    Status? currentStatus = statusProvider.getStatus();
    Color backgroundColor = _statusColor(currentStatus);
    Color color = ColorUtils.foregroundColor(backgroundColor);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: currentStatus != null ? 32.0 : 0,
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          // Background
          AnimatedContainer(
            margin: const EdgeInsets.only(left: 6.0, right: 6.0, top: 8.0),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            height: currentStatus != null ? 28.0 : 0,
            decoration: BoxDecoration(
              color: backgroundColor,
              boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 8.0)],
              borderRadius: BorderRadius.circular(45.0),
            ),
          ),

          // Progress bar
          if (currentStatus == Status.syncing)
            Container(
              margin: const EdgeInsets.only(left: 6.0, right: 6.0, top: 8.0),
              alignment: Alignment.bottomLeft,
              child: AnimatedContainer(
                height: currentStatus != null ? 28.0 : 0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                width: MediaQuery.of(context).size.width * statusProvider.progress - 16.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(45.0),
                ),
              ),
            ),

          // Text
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Text(
                _statusString(currentStatus),
                style: TextStyle(color: color, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _statusString(Status? status) {
    switch (status) {
      case Status.syncing:
        return "Syncing data".i18n;
      case Status.maintenance:
        return "KRETA Maintenance".i18n;
      case Status.network:
        return "No connection".i18n;
      default:
        return "";
    }
  }

  Color _statusColor(Status? status) {
    switch (status) {
      case Status.maintenance:
        return AppColors.of(context).red;
      case Status.network:
      case Status.syncing:
      default:
        HSLColor color = HSLColor.fromColor(Theme.of(context).scaffoldBackgroundColor);
        if (color.lightness >= 0.5) {
          color = color.withSaturation(0.3);
          color = color.withLightness(color.lightness - 0.1);
        } else {
          color = color.withSaturation(0);
          color = color.withLightness(color.lightness + 0.2);
        }
        return color.toColor();
    }
  }
}
