import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({Key? key, required this.label, this.activeColor, this.onTap}) : super(key: key);

  final Color? activeColor;
  final void Function()? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 6.0, right: 3.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: 32.0,
          decoration: BoxDecoration(
            color: (activeColor ?? Theme.of(context).colorScheme.secondary).withOpacity(0.25),
            borderRadius: BorderRadius.circular(6.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          child: Center(
              child: Text(label,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: activeColor ?? Theme.of(context).colorScheme.secondary))),
        ),
      ),
    );
  }
}
