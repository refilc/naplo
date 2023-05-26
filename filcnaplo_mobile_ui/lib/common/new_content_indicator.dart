import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class NewContentIndicator extends StatelessWidget {
  const NewContentIndicator({Key? key, this.size = 64.0}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.topRight,
      width: size,
      height: size,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: size / 3.0,
        width: size / 3.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: size / 20.0),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.of(context).red,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
