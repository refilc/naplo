import 'package:dotted_border/dotted_border.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmptyCard extends StatefulWidget {
  const EmptyCard({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  State<EmptyCard> createState() => _EmptyCardState();
}

class _EmptyCardState extends State<EmptyCard> {
  bool hold = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressDown: (_) => setState(() => hold = true),
      onLongPressEnd: (_) => setState(() => hold = false),
      onLongPressCancel: () => setState(() => hold = false),
      child: AnimatedScale(
        scale: hold ? 1.018 : 1.0,
        curve: Curves.easeInOutBack,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: 444,
          padding:
              const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
          decoration: BoxDecoration(
            color: const Color(0x280008FF),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              if (Provider.of<SettingsProvider>(context, listen: false)
                  .shadowEffect)
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, 5),
                  blurRadius: 20,
                  spreadRadius: 10,
                ),
            ],
          ),
          child: DottedBorder(
            color: Colors.black.withOpacity(0.9),
            dashPattern: const [12, 12],
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
