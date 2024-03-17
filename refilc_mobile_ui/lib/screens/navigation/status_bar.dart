import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc/api/providers/status_provider.dart';
import 'status_bar.i18n.dart';

class StatusBar extends StatefulWidget {
  const StatusBar({super.key});

  @override
  StatusBarState createState() => StatusBarState();
}

class StatusBarState extends State<StatusBar> {
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
      height: currentStatus != null ? 48.0 : 0,
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          // Background
          AnimatedContainer(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            height: currentStatus != null ? 4.0 : 0,
            decoration: BoxDecoration(
              color: backgroundColor,
              boxShadow: [
                BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 8.0)
              ],
              borderRadius: BorderRadius.circular(45.0),
            ),
          ),

          // Progress bar
          if (currentStatus == Status.syncing)
            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
              alignment: Alignment.topLeft,
              child: AnimatedContainer(
                height: currentStatus != null ? 4.0 : 0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                width: MediaQuery.of(context).size.width *
                        statusProvider.progress -
                    36.0,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(45.0),
                ),
              ),
            ),

          // Text
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Center(
              child: Text(
                _statusString(currentStatus),
                style: TextStyle(color: color, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          // pct
          if (currentStatus == Status.syncing)
            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 34.0),
              alignment: Alignment.topLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                width: MediaQuery.of(context).size.width *
                        statusProvider.progress -
                    36.0,
                alignment: Alignment.centerRight,
                child: Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(1.0),
                    borderRadius: BorderRadius.zero,
                    color: AppColors.of(context).background,
                  ),
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(
                    '${(statusProvider.progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          // Padding(
          //   padding: EdgeInsets.only(
          //     top: 32.0,
          //     left: ((MediaQuery.of(context).size.width) *
          //             statusProvider.progress) -
          //         28.0,
          //   ),
          //   child:
          // ),
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
      case Status.apiError:
        return "KRETA API error".i18n;
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
      case Status.apiError:
        return AppColors.of(context).red;
      case Status.network:
      case Status.syncing:
      default:
        HSLColor color =
            HSLColor.fromColor(Theme.of(context).scaffoldBackgroundColor);
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
