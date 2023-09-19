import 'package:flutter/material.dart';

class AvatarStack extends StatelessWidget {
  const AvatarStack({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (children.isNotEmpty) children[0],
        if (children.length > 1)
          Transform.translate(
            offset: const Offset(-20.0, 0.0),
            child: children[1],
          ),
        if (children.length > 2)
          Transform.translate(
            offset: const Offset(-40.0, 0.0),
            child: children[2],
          ),
      ],
    );
  }
}
