import 'dart:math';

import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/self_note_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/soon_alert/soon_alert.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/tick_tile.dart';
import 'package:filcnaplo_mobile_ui/screens/notes/add_note_screen.dart';
import 'package:filcnaplo_mobile_ui/screens/notes/note_view_screen.dart';
import 'package:filcnaplo_mobile_ui/screens/notes/notes_screen.i18n.dart';
import 'package:filcnaplo_mobile_ui/screens/notes/self_note_tile.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:filcnaplo_premium/ui/mobile/premium/premium_inline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key, required this.doneItems});

  final Map<String, bool> doneItems;

  @override
  NotesScreenState createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  late UserProvider user;
  late HomeworkProvider homeworkProvider;
  late DatabaseProvider databaseProvider;
  late SelfNoteProvider selfNoteProvider;

  List<Widget> noteTiles = [];

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    homeworkProvider = Provider.of<HomeworkProvider>(context);
    databaseProvider = Provider.of<DatabaseProvider>(context);
    selfNoteProvider = Provider.of<SelfNoteProvider>(context);

    void generateTiles() {
      List<Widget> tiles = [];

      List<Homework> hw = homeworkProvider.homework
          .where((e) => e.deadline.isAfter(DateTime.now()))
          // e.deadline.isBefore(DateTime(DateTime.now().year,
          //     DateTime.now().month, DateTime.now().day + 3)))
          .toList();

      // todo tiles
      List<Widget> toDoTiles = [];

      if (hw.isNotEmpty) {
        toDoTiles.addAll(hw.map((e) => TickTile(
              padding: EdgeInsets.zero,
              title: 'homework'.i18n,
              description:
                  '${(e.subject.isRenamed ? e.subject.renamedTo : e.subject.name) ?? ''}, ${e.content.escapeHtml()}',
              isTicked: widget.doneItems[e.id] ?? false,
              onTap: (p0) async {
                if (!widget.doneItems.containsKey(e.id)) {
                  widget.doneItems.addAll({e.id: p0});
                } else {
                  widget.doneItems[e.id] = p0;
                }
                await databaseProvider.userStore
                    .storeToDoItem(widget.doneItems, userId: user.id!);
              },
            )));
      }

      if (toDoTiles.isNotEmpty) {
        tiles.add(Panel(
          title: Text('todo'.i18n),
          child: Column(
            children: toDoTiles,
          ),
        ));
      }

      // self notes
      List<Widget> selfNoteTiles = [];

      if (selfNoteProvider.notes.isNotEmpty) {
        selfNoteTiles.addAll(selfNoteProvider.notes.map(
          (e) => SelfNoteTile(
            title: e.title ?? e.content.split(' ')[0],
            content: e.content,
            onTap: () => Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                    builder: (context) => NoteViewScreen(note: e))),
          ),
        ));
      }

      if (selfNoteTiles.isNotEmpty) {
        // padding
        tiles.add(const SizedBox(
          height: 28.0,
        ));

        // actual thing
        tiles.add(Panel(
          title: Text('your_notes'.i18n),
          padding: EdgeInsets.zero,
          isTransparent: true,
          child: Wrap(
            spacing: 18.0,
            runSpacing: 18.0,
            children: selfNoteTiles,
          ),
        ));
      }

      // insert empty tile
      if (tiles.isEmpty) {
        tiles.insert(
          0,
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Empty(subtitle: "empty".i18n),
          ),
        );
      }

      tiles.add(Provider.of<PremiumProvider>(context, listen: false).hasPremium
          ? const SizedBox()
          : const Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: PremiumInline(features: [
                PremiumInlineFeature.stats,
              ]),
            ));

      // padding
      tiles.add(const SizedBox(height: 32.0));

      noteTiles = List.castFrom(tiles);
    }

    generateTiles();

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        title: Text(
          "notes".i18n,
          style: TextStyle(
            color: AppColors.of(context).text,
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.1),
            child: GestureDetector(
              onTap: () {
                // handle tap
                SoonAlert.show(context: context);
              },
              child: Container(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      IconTheme(
                        data: IconThemeData(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: const Icon(
                          FeatherIcons.search,
                          size: 20.0,
                        ),
                      ),
                      IconTheme(
                        data: IconThemeData(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black.withOpacity(.5)
                                  : Colors.white.withOpacity(.3),
                        ),
                        child: const Icon(
                          FeatherIcons.search,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.1),
            child: GestureDetector(
              onTap: () {
                // handle tap
                Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                        builder: (context) => const AddNoteScreen()));
              },
              child: Container(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      IconTheme(
                        data: IconThemeData(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: const Icon(
                          FeatherIcons.plus,
                          size: 20.0,
                        ),
                      ),
                      IconTheme(
                        data: IconThemeData(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black.withOpacity(.5)
                                  : Colors.white.withOpacity(.3),
                        ),
                        child: const Icon(
                          FeatherIcons.plus,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            Provider.of<HomeworkProvider>(context, listen: false)
                .fetch(from: DateTime.now().subtract(const Duration(days: 30)));
            Provider.of<SelfNoteProvider>(context, listen: false).restore();

            return Future(() => null);
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemCount: max(noteTiles.length, 1),
            itemBuilder: (context, index) {
              if (noteTiles.isNotEmpty) {
                EdgeInsetsGeometry panelPadding =
                    const EdgeInsets.symmetric(horizontal: 24.0);

                return Padding(padding: panelPadding, child: noteTiles[index]);
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
