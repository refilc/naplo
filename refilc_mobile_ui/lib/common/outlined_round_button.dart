import 'package:flutter/material.dart';

class OutlinedRoundButton extends StatelessWidget {
  final Widget child;
  final double size;
  final Function()? onTap;
  final EdgeInsets padding;

  const OutlinedRoundButton({
    super.key,
    required this.child,
    this.size = 35.0,
    this.onTap,
    this.padding = const EdgeInsets.all(5.0),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            width: 1.1,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.center,
        padding: padding,
        child: child,
      ),
    );
  }
}
