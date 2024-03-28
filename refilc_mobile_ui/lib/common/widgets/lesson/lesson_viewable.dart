import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc_mobile_ui/common/panel/panel_button.dart';
import 'package:refilc_mobile_ui/common/viewable.dart';
import 'package:refilc_mobile_ui/common/widgets/card_handle.dart';
import 'package:refilc/ui/widgets/lesson/lesson_tile.dart';
import 'package:refilc_mobile_ui/common/widgets/lesson/lesson_view.dart';
import 'package:flutter/material.dart';
import 'package:refilc_plus/models/premium_scopes.dart';
import 'package:refilc_plus/providers/premium_provider.dart';
import 'package:refilc_plus/ui/mobile/premium/upsell.dart';
import 'lesson_view.i18n.dart';

class LessonViewable extends StatefulWidget {
  const LessonViewable(this.lesson,
      {super.key, this.swapDesc = false, required this.customDesc});

  final Lesson lesson;
  final bool swapDesc;
  final String customDesc;

  @override
  State<LessonViewable> createState() => LessonViewableState();
}

class LessonViewableState extends State<LessonViewable> {
  final _descTxt = TextEditingController();

  late UserProvider user;
  late DatabaseProvider databaseProvider;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    databaseProvider = Provider.of<DatabaseProvider>(context);

    if (widget.customDesc.replaceAll(' ', '') != '' &&
        widget.customDesc != widget.lesson.description) {
      _descTxt.text = widget.customDesc;
    }

    Lesson lsn = widget.lesson;
    lsn.description = widget.customDesc;

    final tile = LessonTile(lsn, swapDesc: widget.swapDesc);

    if (lsn.subject.id == '' || tile.lesson.isEmpty) return tile;

    return Viewable(
      tile: tile,
      view: CardHandle(child: LessonView(lsn)),
      actions: [
        PanelButton(
          background: true,
          title: Text(
            "edit_lesson".i18n,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();

            if (!Provider.of<PremiumProvider>(context, listen: false)
                .hasScope(PremiumScopes.timetableNotes)) {
              PlusLockedFeaturePopup.show(
                  context: context, feature: PremiumFeature.timetableNotes);

              return;
            }

            showDialog(
              context: context,
              builder: (context) => StatefulBuilder(builder: (context, setS) {
                return AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0))),
                  title: Text("edit_lesson".i18n),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // description
                      TextField(
                        controller: _descTxt,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12.0),
                          hintText: 'l_desc'.i18n,
                          suffixIcon: IconButton(
                            icon: const Icon(
                              FeatherIcons.x,
                              color: Colors.grey,
                              size: 18.0,
                            ),
                            onPressed: () {
                              setState(() {
                                _descTxt.text = '';
                              });
                            },
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 14.0,
                      // ),
                      // // class
                      // TextField(
                      //   controller: _descTxt,
                      //   onEditingComplete: () async {
                      //     // SharedTheme? theme = await shareProvider.getThemeById(
                      //     //   context,
                      //     //   id: _paintId.text.replaceAll(' ', ''),
                      //     // );

                      //     // if (theme != null) {
                      //     //   // set theme variable
                      //     //   newThemeByID = theme;

                      //     //   _paintId.clear();
                      //     // } else {
                      //     //   ScaffoldMessenger.of(context).showSnackBar(
                      //     //     CustomSnackBar(
                      //     //       content: Text("theme_not_found".i18n,
                      //     //           style: const TextStyle(color: Colors.white)),
                      //     //       backgroundColor: AppColors.of(context).red,
                      //     //       context: context,
                      //     //     ),
                      //     //   );
                      //     // }
                      //   },
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(
                      //       borderSide: const BorderSide(
                      //           color: Colors.grey, width: 1.5),
                      //       borderRadius: BorderRadius.circular(12.0),
                      //     ),
                      //     focusedBorder: OutlineInputBorder(
                      //       borderSide: const BorderSide(
                      //           color: Colors.grey, width: 1.5),
                      //       borderRadius: BorderRadius.circular(12.0),
                      //     ),
                      //     contentPadding:
                      //         const EdgeInsets.symmetric(horizontal: 12.0),
                      //     hintText: 'l_desc'.i18n,
                      //     suffixIcon: IconButton(
                      //       icon: const Icon(
                      //         FeatherIcons.x,
                      //         color: Colors.grey,
                      //         size: 18.0,
                      //       ),
                      //       onPressed: () {
                      //         setState(() {
                      //           _descTxt.text = '';
                      //         });
                      //       },
                      //     ),
                      //   ),
                      // ),
                    ],
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
                        "done".i18n,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onPressed: () async {
                        saveLesson();

                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    ),
                  ],
                );
              }),
            );
          },
        ),
      ],
    );
  }

  void saveLesson() async {
    Map<String, String> lessonDesc = await databaseProvider.userQuery
        .getCustomLessonDescriptions(userId: user.id!);

    lessonDesc[widget.lesson.id] = _descTxt.text;

    if (_descTxt.text.replaceAll(' ', '') == '') {
      lessonDesc.remove(widget.lesson.id);
    }

    // ignore: use_build_context_synchronously
    await databaseProvider.userStore
        .storeCustomLessonDescriptions(lessonDesc, userId: user.id!);
  }
}
