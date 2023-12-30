import 'dart:math';

import 'package:filcnaplo/api/providers/database_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/tick_tile.dart';
import 'package:filcnaplo_mobile_ui/screens/notes/notes_screen.i18n.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:filcnaplo_premium/ui/mobile/premium/premium_inline.dart';
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

  List<Widget> noteTiles = [];

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    homeworkProvider = Provider.of<HomeworkProvider>(context);
    databaseProvider = Provider.of<DatabaseProvider>(context);

    void generateTiles() {
      List<Widget> tiles = [];

      List<Homework> hw = homeworkProvider.homework
          .where((e) => e.deadline.isAfter(DateTime.now()))
          // e.deadline.isBefore(DateTime(DateTime.now().year,
          //     DateTime.now().month, DateTime.now().day + 3)))
          .toList();

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

      if (tiles.isNotEmpty) {
      } else {
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
          onRefresh: () async {
            await homeworkProvider.fetch();
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
