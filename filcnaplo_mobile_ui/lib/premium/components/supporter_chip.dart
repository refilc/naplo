import 'package:filcnaplo/models/supporter.dart';
import 'package:flutter/material.dart';

class SupporterChip extends StatelessWidget {
  const SupporterChip({Key? key, required this.supporter}) : super(key: key);

  final Supporter supporter;

  @override
  Widget build(BuildContext context) {
    return Chip(
      side: BorderSide.none,
      shape: const StadiumBorder(side: BorderSide.none),
      padding: const EdgeInsets.all(8.0),
      avatar: supporter.avatar != ""
          ? CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              backgroundImage: NetworkImage(supporter.avatar),
            )
          : null,
      labelPadding: const EdgeInsets.only(left: 12.0, right: 8.0),
      label: Text.rich(
        TextSpan(children: [
          TextSpan(text: supporter.name),
          if (supporter.type == DonationType.once)
            TextSpan(
              text: "  \$${supporter.price}",
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
        ]),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
      ),
    );
  }
}
