// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/api/providers/self_note_provider.dart';
import 'package:refilc/api/providers/update_provider.dart';
import 'package:refilc/models/self_note.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc_kreta_api/models/absence.dart';
import 'package:refilc_kreta_api/models/homework.dart';
import 'package:refilc_kreta_api/models/subject.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/providers/homework_provider.dart';
import 'package:refilc_mobile_ui/common/bottom_sheet_menu/bottom_sheet_menu.dart';
import 'package:refilc_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:refilc_mobile_ui/common/empty.dart';
import 'package:refilc_mobile_ui/common/panel/panel.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_button.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_image.dart';
import 'package:refilc_mobile_ui/common/soon_alert/soon_alert.dart';
import 'package:refilc_mobile_ui/common/widgets/tick_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc_mobile_ui/pages/notes/submenu/add_note_screen.dart';
import 'package:refilc_mobile_ui/pages/notes/submenu/create_image_note.dart';
import 'package:refilc_mobile_ui/pages/notes/submenu/note_view_screen.dart';
import 'package:refilc_mobile_ui/pages/notes/submenu/self_note_tile.dart';
import 'package:refilc_plus/models/premium_scopes.dart';
import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:refilc_plus/ui/mobile/plus/premium_inline.dart';
import 'package:refilc_plus/ui/mobile/plus/upsell.dart';
import 'package:uuid/uuid.dart';
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
  List<TodoItem> todoItems = [];

  final TextEditingController _taskName = TextEditingController();
  final TextEditingController _taskContent = TextEditingController();

  void generateTiles() async {
    doneItems = await databaseProvider.userQuery.toDoItems(userId: user.id!);
    todoItems = await databaseProvider.userQuery.getTodoItems(userId: user.id!);

    List<Widget> tiles = [];

    List<Homework> hw = Provider.of<HomeworkProvider>(context, listen: false)
        .homework
        .where((e) => e.deadline.isAfter(DateTime.now()))
        // e.deadline.isBefore(DateTime(DateTime.now().year,
        //     DateTime.now().month, DateTime.now().day + 3)))
        .toList();

    // todo tiles
    List<Widget> toDoTiles = [];

    // TODO: FIX THIS ASAP
    if (hw.isNotEmpty &&
        Provider.of<PlusProvider>(context, listen: false)
            .hasScope(PremiumScopes.unlimitedSelfNotes)) {
      toDoTiles.addAll(hw.map((e) => TickTile(
            padding: EdgeInsets.zero,
            title: 'homework'.i18n,
            description:
                '${(e.subject.isRenamed ? e.subject.renamedTo : e.subject.name) ?? ''}, ${e.content.escapeHtml()}',
            isTicked: doneItems[e.id] ?? false,
            onTap: (p0) async {
              // print(p0);
              // print(doneItems);
              if (!doneItems.containsKey(e.id)) {
                doneItems.addAll({e.id: p0});
              } else {
                doneItems[e.id] = p0;
              }
              // print(doneItems);
              // print(doneItems[e.id]);
              // print(user.id);
              await databaseProvider.userStore
                  .storeToDoItem(doneItems, userId: user.id!);

              setState(() {});

              // print(
              //     await databaseProvider.userQuery.toDoItems(userId: user.id!));
            },
          )));
    }

    if (selfNoteProvider.todos.isNotEmpty) {
      toDoTiles.addAll(selfNoteProvider.todos.map((e) => TickTile(
            padding: EdgeInsets.zero,
            title: e.title,
            description: e.content,
            isTicked: e.done,
            onTap: (p0) async {
              final todoItemIndex =
                  todoItems.indexWhere((element) => element.id == e.id);
              if (todoItemIndex != -1) {
                TodoItem todoItem = todoItems[todoItemIndex];
                Map<String, dynamic> todoItemJson = todoItem.toJson;
                todoItemJson['done'] = p0;
                todoItem = TodoItem.fromJson(todoItemJson);
                todoItems[todoItemIndex] = todoItem;
                await databaseProvider.userStore
                    .storeSelfTodoItems(todoItems, userId: user.id!);
              }

              // await databaseProvider.userStore
              //     .storeSelfTodoItems(todoItems, userId: user.id!);
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
        (e) => e.noteType == NoteType.text
            ? SelfNoteTile(
                title: e.title ?? e.content.split(' ')[0],
                content: e.content,
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                        builder: (context) => NoteViewScreen(note: e))),
              )
            : GestureDetector(
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                        builder: (context) => NoteViewScreen(note: e))),
                child: Container(
                  height: MediaQuery.of(context).size.width / 2.42,
                  width: MediaQuery.of(context).size.width / 2.42,
                  decoration: BoxDecoration(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.memory(
                      const Base64Decoder().convert(e.content),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
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
        child: selfNoteTiles.length > 1
            ? Center(
                child: Wrap(
                  spacing: 18.0,
                  runSpacing: 18.0,
                  children: selfNoteTiles,
                ),
              )
            : Wrap(
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

                          showCreationModal(context);
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
                          .tertiary, //ColorUtils.stringToColor(user.displayName ?? "?"),
                      badge: updateProvider.available,
                      role: user.role,
                      profilePictureString: user.picture,
                      gradeStreak: (user.gradeStreak ?? 0) > 1,
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
                  style: Provider.of<SettingsProvider>(context).fontFamily !=
                              '' &&
                          Provider.of<SettingsProvider>(context).titleOnlyFont
                      ? GoogleFonts.getFont(
                          Provider.of<SettingsProvider>(context).fontFamily,
                          textStyle: TextStyle(
                              color: AppColors.of(context).text,
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold),
                        )
                      : TextStyle(
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
              Provider.of<SelfNoteProvider>(context, listen: false)
                  .restoreTodo();

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

  void showCreationModal(BuildContext context) {
    // _sheetController = _scaffoldKey.currentState?.showBottomSheet(
    //   (context) => RoundedBottomSheet(
    //       borderRadius: 14.0,
    //       child: BottomSheetMenu(items: [
    //         SwitchListTile(
    //             title: Text('show_lesson_num'.i18n),
    //             value:
    //                 Provider.of<SettingsProvider>(context).qTimetableLessonNum,
    //             onChanged: (v) {
    //               Provider.of<SettingsProvider>(context, listen: false)
    //                   .update(qTimetableLessonNum: v);
    //             })
    //       ])),
    //   backgroundColor: const Color(0x00000000),
    //   elevation: 12.0,
    // );

    // _sheetController!.closed.then((value) {
    //   // Show fab and grades
    //   if (mounted) {}
    // });
    showRoundedModalBottomSheet(
      context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: BottomSheetMenu(items: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).colorScheme.surface),
          child: ListTile(
            title: Row(
              children: [
                const Icon(Icons.sticky_note_2_outlined),
                const SizedBox(
                  width: 10.0,
                ),
                Text('new_note'.i18n),
              ],
            ),
            onTap: () => Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                    builder: (context) => const AddNoteScreen())),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).colorScheme.surface),
          child: ListTile(
            title: Row(
              children: [
                const Icon(Icons.photo_library_outlined),
                const SizedBox(
                  width: 10.0,
                ),
                Text('new_image'.i18n),
              ],
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => ImageNoteEditor(user.user!));
            },
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).colorScheme.surface),
          child: ListTile(
            title: Row(
              children: [
                const Icon(Icons.task_outlined),
                const SizedBox(
                  width: 10.0,
                ),
                Text('new_task'.i18n),
              ],
            ),
            onTap: () {
              // if (!Provider.of<PlusProvider>(context, listen: false)
              //     .hasScope(PremiumScopes.unlimitedSelfNotes)) {
              //   PlusLockedFeaturePopup.show(
              //       context: context, feature: PremiumFeature.selfNotes);

              //   return;
              // }

              showTaskCreation(context);
            },
          ),
        ),
      ]),
    );
  }

  void showTaskCreation(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        contentPadding: const EdgeInsets.only(top: 10.0),
        title: Text("new_task".i18n),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  hintText: "task_name".i18n,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      FeatherIcons.x,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _taskName.text = "";
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: _taskContent,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  hintText: "task_content".i18n,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      FeatherIcons.x,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _taskContent.text = "";
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              "cancel".i18n,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),
          TextButton(
            child: Text(
              "next".i18n,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            onPressed: () async {
              todoItems.add(TodoItem.fromJson({
                'id': const Uuid().v4(),
                'title': _taskName.text.replaceAll(' ', '') != ""
                    ? _taskName.text
                    : 'no_title'.i18n,
                'content': _taskContent.text,
                'done': false,
              }));

              await databaseProvider.userStore
                  .storeSelfTodoItems(todoItems, userId: user.id!);

              setState(() {
                _taskName.text = "";
                _taskContent.text = "";
              });

              Provider.of<SelfNoteProvider>(context, listen: false).restore();
              Provider.of<SelfNoteProvider>(context, listen: false)
                  .restoreTodo();

              generateTiles();

              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }
}
