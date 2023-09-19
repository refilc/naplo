import 'package:flutter/material.dart';
import 'package:refilc/models/news.dart';
import 'package:refilc/utils/format.dart';

class NewsTile extends StatelessWidget {
  const NewsTile(this.news, {Key? key, this.onTap}) : super(key: key);

  final News news;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        news.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        news.content.escapeHtml().replaceAll("\n", " "),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    );
  }
}
