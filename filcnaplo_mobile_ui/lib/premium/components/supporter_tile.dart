import 'package:filcnaplo/models/supporter.dart';
import 'package:flutter/material.dart';

class SupporterTile extends StatelessWidget {
  const SupporterTile({Key? key, required this.supporter}) : super(key: key);

  final Supporter supporter;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(supporter.avatar),
      ),
      title: Text(
        supporter.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(supporter.comment),
    );
  }
}
