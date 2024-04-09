// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/api/providers/self_note_provider.dart';
import 'package:refilc/api/providers/update_provider.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_kreta_api/models/absence.dart';
import 'package:refilc_kreta_api/models/homework.dart';
import 'package:refilc_kreta_api/models/subject.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/providers/homework_provider.dart';
import 'package:refilc_mobile_ui/common/empty.dart';
import 'package:refilc_mobile_ui/common/panel/panel.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_button.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_image.dart';
import 'package:refilc_mobile_ui/common/soon_alert/soon_alert.dart';
import 'package:refilc_mobile_ui/common/widgets/tick_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc_mobile_ui/screens/notes/add_note_screen.dart';
import 'package:refilc_mobile_ui/screens/notes/note_view_screen.dart';
import 'package:refilc_mobile_ui/screens/notes/self_note_tile.dart';
import 'package:refilc_plus/models/premium_scopes.dart';
import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:refilc_plus/ui/mobile/plus/premium_inline.dart';
import 'package:refilc_plus/ui/mobile/plus/upsell.dart';
import 'notes_page.i18n.dart';

enum AbsenceFilter { absences, delays, misses }

class SubjectAbsence {
  GradeSubject subject;
  List<Absence> absences;
  double percentage;

  SubjectAbsence(
      {required this.subject, this.absences = const [], this.percentage = 0.0});
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> with TickerProviderStateMixin {
  late UserProvider user;
  late UpdateProvider updateProvider;
  late DatabaseProvider databaseProvider;
  late SelfNoteProvider selfNoteProvider;

  late String firstName;

  Map<String, bool> doneItems = {};
  List<Widget> noteTiles = [];

  void generateTiles() async {
    doneItems = await databaseProvider.userQuery.toDoItems(userId: user.id!);

    List<Widget> tiles = [];

    List<Homework> hw = Provider.of<HomeworkProvider>(context, listen: false)
        .homework
        .where((e) => e.deadline.isAfter(DateTime.now()))
        // e.deadline.isBefore(DateTime(DateTime.now().year,
        //     DateTime.now().month, DateTime.now().day + 3)))
        .toList();

    // todo tiles
    List<Widget> toDoTiles = [];

    if (hw.isNotEmpty &&
        !Provider.of<PlusProvider>(context, listen: false)
            .hasScope(PremiumScopes.unlimitedSelfNotes)) {
      toDoTiles.addAll(hw.map((e) => TickTile(
            padding: EdgeInsets.zero,
            title: 'homework'.i18n,
            description:
                '${(e.subject.isRenamed ? e.subject.renamedTo : e.subject.name) ?? ''}, ${e.content.escapeHtml()}',
            isTicked: doneItems[e.id] ?? false,
            onTap: (p0) async {
              if (!doneItems.containsKey(e.id)) {
                doneItems.addAll({e.id: p0});
              } else {
                doneItems[e.id] = p0;
              }
              await databaseProvider.userStore
                  .storeToDoItem(doneItems, userId: user.id!);
            },
          )));
    }

    if (toDoTiles.isNotEmpty) {
      tiles.add(const SizedBox(
        height: 10.0,
      ));

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
      selfNoteTiles.addAll(selfNoteProvider.notes.reversed.map(
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
        child: Center(
          child: Wrap(
            spacing: 18.0,
            runSpacing: 18.0,
            children: selfNoteTiles,
          ),
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

    tiles.add(Provider.of<PlusProvider>(context, listen: false).hasPremium
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

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    databaseProvider = Provider.of<DatabaseProvider>(context);
    updateProvider = Provider.of<UpdateProvider>(context);
    selfNoteProvider = Provider.of<SelfNoteProvider>(context);

    List<String> nameParts = user.displayName?.split(" ") ?? ["?"];
    firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];

    generateTiles();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: true,
              floating: false,
              snap: false,
              centerTitle: false,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          SoonAlert.show(context: context);
                        },
                        child: Icon(
                          FeatherIcons.search,
                          color: AppColors.of(context).text,
                          size: 22.0,
                        ),
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          // handle tap
                          if (!Provider.of<PlusProvider>(context, listen: false)
                                  .hasScope(PremiumScopes.unlimitedSelfNotes) &&
                              noteTiles.length > 10) {
                            return PlusLockedFeaturePopup.show(
                                context: context,
                                feature: PremiumFeature.selfNotes);
                          }

                          Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute(
                                  builder: (context) => const AddNoteScreen()));
                        },
                        child: Icon(
                          FeatherIcons.plus,
                          color: AppColors.of(context).text,
                        ),
                      ),
                    ],
                  ),
                ),

                // Profile Icon
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: ProfileButton(
                    child: ProfileImage(
                      heroTag: "profile",
                      name: firstName,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary, //ColorUtils.stringToColor(user.displayName ?? "?"),
                      badge: updateProvider.available,
                      role: user.role,
                      profilePictureString: user.picture,
                    ),
                  ),
                ),
              ],
              automaticallyImplyLeading: false,
              shadowColor: Theme.of(context).shadowColor,
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "notes".i18n,
                  style: TextStyle(
                      color: AppColors.of(context).text,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
          body: RefreshIndicator(
            onRefresh: () {
              var state = Provider.of<HomeworkProvider>(context, listen: false)
                  .fetch(
                      from: DateTime.now().subtract(const Duration(days: 30)));
              Provider.of<SelfNoteProvider>(context, listen: false).restore();

              generateTiles();

              return state;
            },
            color: Theme.of(context).colorScheme.secondary,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: max(noteTiles.length, 1),
              itemBuilder: (context, index) {
                if (noteTiles.isNotEmpty) {
                  const EdgeInsetsGeometry panelPadding =
                      EdgeInsets.symmetric(horizontal: 24.0);

                  return Padding(
                      padding: panelPadding, child: noteTiles[index]);
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
