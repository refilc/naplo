import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:refilc/theme/colors/colors.dart';

class CustomSegmentedControl extends StatelessWidget {
  final void Function(int)? onChanged;
  final int value;
  final List<Widget> children;
  final int duration;
  final bool showDivider;
  final double height;

  const CustomSegmentedControl({
    super.key,
    this.onChanged,
    required this.value,
    required this.children,
    this.duration = 200,
    this.showDivider = true,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    Map<int, Widget> finalChildren = {};

    var i = 0;
    for (var e in children) {
      finalChildren.addAll({i: e});
      i++;
    }

    return CustomSlidingSegmentedControl<int>(
      initialValue: value,
      children: finalChildren,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(.069),
        borderRadius: BorderRadius.circular(12.0),
      ),
      thumbDecoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(10.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(.3),
        //     blurRadius: 4.0,
        //     spreadRadius: 1.0,
        //     offset: const Offset(
        //       0.0,
        //       2.0,
        //     ),
        //   ),
        // ],
      ),
      duration: Duration(milliseconds: duration),
      curve: Curves.easeInOutCubic,
      onValueChanged: onChanged ?? (v) {},
      isStretch: true,
      innerPadding: const EdgeInsets.all(4.0),
      padding: 2.0,
      isShowDivider: showDivider,
      dividerSettings: DividerSettings(
        indent: (height / 4) + 1,
        endIndent: (height / 4) + 1,
        // indent: 0,
        // endIndent: 2,
        // thickness: 2,
        decoration: BoxDecoration(
          color: AppColors.of(context).text.withOpacity(0.2),
        ),
      ),
      height: height,
      customSegmentSettings:
          CustomSegmentSettings(hoverColor: Colors.transparent),
    );
  }
}
