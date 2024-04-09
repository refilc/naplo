import 'package:refilc/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelfNoteTile extends StatelessWidget {
  const SelfNoteTile(
      {super.key, required this.title, required this.content, this.onTap});

  final String title;
  final String content;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.width / 2.42,
            width: MediaQuery.of(context).size.width / 2.42,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Theme.of(context).colorScheme.background,
              boxShadow: [
                if (Provider.of<SettingsProvider>(context, listen: false)
                    .shadowEffect)
                  BoxShadow(
                    offset: const Offset(0, 21),
                    blurRadius: 23.0,
                    color: Theme.of(context).shadowColor,
                  ),
              ],
            ),
            child: Text(
              content.replaceAll('\n', ' '),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              maxLines: 6,
              style: const TextStyle(fontSize: 17.0),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          SizedBox(
            width: 152.0,
            child: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
