import 'package:flutter/material.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'chips.i18n.dart';

class NewChip extends StatelessWidget {
  const NewChip({super.key, this.disabled = false});

  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            disabled ? AppColors.of(context).text.withOpacity(.25) : Colors.red,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding:
          const EdgeInsets.only(left: 6.0, right: 8.0, top: 4.0, bottom: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.hotel_class_rounded,
            color: disabled
                ? AppColors.of(context).text.withOpacity(.5)
                : Colors.white,
            size: 14.0,
          ),
          const SizedBox(width: 2.0),
          Text(
            'new'.i18n,
            style: TextStyle(
              color: disabled
                  ? AppColors.of(context).text.withOpacity(.5)
                  : Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
