import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class BottomCard extends StatelessWidget {
  const BottomCard({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Theme.of(context).colorScheme.background,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42.0,
                height: 4.0,
                margin: const EdgeInsets.only(top: 12.0, bottom: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45.0),
                  color: AppColors.of(context).text.withOpacity(0.10),
                ),
              ),
              if (child != null) child!,
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showBottomCard({
  required BuildContext context,
  Widget? child,
  bool rootNavigator = true,
}) async =>
    await showModalBottomSheet(
        backgroundColor: const Color(0x00000000),
        useRootNavigator: rootNavigator,
        elevation: 0,
        isDismissible: true,
        context: context,
        builder: (context) => BottomCard(child: child));
