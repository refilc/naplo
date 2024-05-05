import 'package:refilc/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this.onPressed, required this.child});

  final void Function()? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      minWidth: double.infinity,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: AppColors.of(context).buttonBackground,
      textColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6.0,
        ),
        child: child,
      ),
    );
  }
}
