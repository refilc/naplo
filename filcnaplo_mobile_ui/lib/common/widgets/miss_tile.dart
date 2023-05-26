import 'package:filcnaplo_kreta_api/models/note.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'miss_tile.i18n.dart';

class MissTile extends StatelessWidget {
  const MissTile(this.note, {Key? key}) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_missIcon(), color: Theme.of(context).colorScheme.secondary, size: 36.0),
      visualDensity: VisualDensity.compact,
      title: Text(
        _missName(),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        note.content.split("órán nem volt")[0].capital(),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  IconData _missIcon() {
    if (note.type?.name == "HaziFeladatHiany") {
      return FeatherIcons.home;
    } else if (note.type?.name == "Felszereleshiany") {
      return FeatherIcons.book;
    }
    return FeatherIcons.slash;
  }

  String _missName() {
    if (note.type?.name == "HaziFeladatHiany") {
      return "Missing homework".i18n;
    } else if (note.type?.name == "Felszereleshiany") {
      return "Missing equipment".i18n;
    }
    return "?";
  }
}
