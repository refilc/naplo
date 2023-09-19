import 'package:refilc/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class BetaChip extends StatelessWidget {
  const BetaChip({Key? key, this.disabled = false}) : super(key: key);

  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Center(
            child: Text(
              "BETA",
              softWrap: true,
              style: TextStyle(
                fontSize: 10,
                color: disabled
                    ? AppColors.of(context).text.withOpacity(.5)
                    : Colors.white,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: !disabled
              ? Theme.of(context).colorScheme.secondary
              : AppColors.of(context).text.withOpacity(.25),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }
}
