import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/helpers/subject.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc/theme/colors/utils.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:refilc_mobile_ui/common/round_border_icon.dart';
import 'package:refilc/ui/widgets/lesson/lesson_tile.dart';
import 'package:flutter/material.dart';

class LessonViewable extends StatefulWidget {
  const LessonViewable(
    this.lesson, {
    super.key,
    this.swapDesc = false,
    required this.customDesc,
    this.showSubTiles = true,
  });

  final Lesson lesson;
  final bool swapDesc;
  final String customDesc;
  final bool showSubTiles;

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

    final tile = LessonTile(
      lsn,
      swapDesc: widget.swapDesc,
      showSubTiles: widget.showSubTiles,
    );

    if (lsn.subject.id == '' || tile.lesson.isEmpty) return tile;

    return GestureDetector(
      onTap: () => TimetableLessonPopup.show(
        context: context,
        lesson: lsn,
      ),
      child: LessonTile(
        lsn,
        swapDesc: widget.swapDesc,
        showSubTiles: widget.showSubTiles,
        // onTap: () => TimetableLessonPopup.show(
        //   context: context,
        //   lesson: lsn,
        // ),
      ),
    );

    // return Viewable(
    //   tile: tile,
    //   view: CardHandle(child: LessonView(lsn)),
    //   actions: [
    //     PanelButton(
    //       background: true,
    //       title: Text(
    //         "edit_lesson".i18n,
    //         textAlign: TextAlign.center,
    //         maxLines: 2,
    //         overflow: TextOverflow.ellipsis,
    //       ),
    //       onPressed: () {
    //         Navigator.of(context, rootNavigator: true).pop();

    //         if (!Provider.of<PlusProvider>(context, listen: false)
    //             .hasScope(PremiumScopes.timetableNotes)) {
    //           PlusLockedFeaturePopup.show(
    //               context: context, feature: PremiumFeature.timetableNotes);

    //           return;
    //         }

    //         showDialog(
    //           context: context,
    //           builder: (context) => StatefulBuilder(builder: (context, setS) {
    //             return AlertDialog(
    //               shape: const RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.all(Radius.circular(14.0))),
    //               title: Text("edit_lesson".i18n),
    //               content: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   // description
    //                   TextField(
    //                     controller: _descTxt,
    //                     decoration: InputDecoration(
    //                       border: OutlineInputBorder(
    //                         borderSide: const BorderSide(
    //                             color: Colors.grey, width: 1.5),
    //                         borderRadius: BorderRadius.circular(12.0),
    //                       ),
    //                       focusedBorder: OutlineInputBorder(
    //                         borderSide: const BorderSide(
    //                             color: Colors.grey, width: 1.5),
    //                         borderRadius: BorderRadius.circular(12.0),
    //                       ),
    //                       contentPadding:
    //                           const EdgeInsets.symmetric(horizontal: 12.0),
    //                       hintText: 'l_desc'.i18n,
    //                       suffixIcon: IconButton(
    //                         icon: const Icon(
    //                           FeatherIcons.x,
    //                           color: Colors.grey,
    //                           size: 18.0,
    //                         ),
    //                         onPressed: () {
    //                           setState(() {
    //                             _descTxt.text = '';
    //                           });
    //                         },
    //                       ),
    //                     ),
    //                   ),
    //                   // const SizedBox(
    //                   //   height: 14.0,
    //                   // ),
    //                   // // class
    //                   // TextField(
    //                   //   controller: _descTxt,
    //                   //   onEditingComplete: () async {
    //                   //     // SharedTheme? theme = await shareProvider.getThemeById(
    //                   //     //   context,
    //                   //     //   id: _paintId.text.replaceAll(' ', ''),
    //                   //     // );

    //                   //     // if (theme != null) {
    //                   //     //   // set theme variable
    //                   //     //   newThemeByID = theme;

    //                   //     //   _paintId.clear();
    //                   //     // } else {
    //                   //     //   ScaffoldMessenger.of(context).showSnackBar(
    //                   //     //     CustomSnackBar(
    //                   //     //       content: Text("theme_not_found".i18n,
    //                   //     //           style: const TextStyle(color: Colors.white)),
    //                   //     //       backgroundColor: AppColors.of(context).red,
    //                   //     //       context: context,
    //                   //     //     ),
    //                   //     //   );
    //                   //     // }
    //                   //   },
    //                   //   decoration: InputDecoration(
    //                   //     border: OutlineInputBorder(
    //                   //       borderSide: const BorderSide(
    //                   //           color: Colors.grey, width: 1.5),
    //                   //       borderRadius: BorderRadius.circular(12.0),
    //                   //     ),
    //                   //     focusedBorder: OutlineInputBorder(
    //                   //       borderSide: const BorderSide(
    //                   //           color: Colors.grey, width: 1.5),
    //                   //       borderRadius: BorderRadius.circular(12.0),
    //                   //     ),
    //                   //     contentPadding:
    //                   //         const EdgeInsets.symmetric(horizontal: 12.0),
    //                   //     hintText: 'l_desc'.i18n,
    //                   //     suffixIcon: IconButton(
    //                   //       icon: const Icon(
    //                   //         FeatherIcons.x,
    //                   //         color: Colors.grey,
    //                   //         size: 18.0,
    //                   //       ),
    //                   //       onPressed: () {
    //                   //         setState(() {
    //                   //           _descTxt.text = '';
    //                   //         });
    //                   //       },
    //                   //     ),
    //                   //   ),
    //                   // ),
    //                 ],
    //               ),
    //               actions: [
    //                 TextButton(
    //                   child: Text(
    //                     "cancel".i18n,
    //                     style: const TextStyle(fontWeight: FontWeight.w500),
    //                   ),
    //                   onPressed: () {
    //                     Navigator.of(context).maybePop();
    //                   },
    //                 ),
    //                 TextButton(
    //                   child: Text(
    //                     "done".i18n,
    //                     style: const TextStyle(fontWeight: FontWeight.w500),
    //                   ),
    //                   onPressed: () async {
    //                     saveLesson();

    //                     Navigator.of(context).pop();
    //                     setState(() {});
    //                   },
    //                 ),
    //               ],
    //             );
    //           }),
    //         );
    //       },
    //     ),
    //   ],
    // );
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

class TimetableLessonPopup extends StatelessWidget {
  const TimetableLessonPopup({
    super.key,
    required this.lesson,
    required this.outsideContext,
  });

  final Lesson lesson;
  final BuildContext outsideContext;

  static void show({
    required BuildContext context,
    required Lesson lesson,
  }) =>
      showRoundedModalBottomSheet(
        context,
        child: TimetableLessonPopup(
          lesson: lesson,
          outsideContext: context,
        ),
        showHandle: false,
      );

  // IconData _getIcon() => _featureLevels[feature] == PremiumFeatureLevel.cap
  //     ? FilcIcons.kupak
  //     : _featureLevels[feature] == PremiumFeatureLevel.ink
  //         ? FilcIcons.tinta
  //         : FilcIcons.tinta;
  // Color _getColor(BuildContext context) =>
  //     _featureLevels[feature] == PremiumFeatureLevel.gold
  //         ? const Color(0xFFC89B08)
  //         : Theme.of(context).brightness == Brightness.light
  //             ? const Color(0xff691A9B)
  //             : const Color(0xffA66FC8);
  // String? _getAsset() => _featureAssets[feature];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      child: Stack(
        children: [
          Stack(
            children: [
              SvgPicture.asset(
                "assets/svg/mesh_bg.svg",
                // ignore: deprecated_member_use
                color: ColorsUtils()
                    .fade(context, Theme.of(context).colorScheme.secondary,
                        darkenAmount: 0.1, lightenAmount: 0.1)
                    .withOpacity(0.33),
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12.0),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor,
                      Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.1),
                      Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.1),
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                    stops: const [0.1, 0.5, 0.7, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: 175.0,
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ColorsUtils()
                          .fade(
                              context, Theme.of(context).colorScheme.secondary,
                              darkenAmount: 0.1, lightenAmount: 0.1)
                          .withOpacity(0.33),
                      borderRadius: BorderRadius.circular(
                        2.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 38.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: RoundBorderIcon(
                      color: ColorsUtils()
                          .darken(
                            Theme.of(context).colorScheme.secondary,
                            amount: 0.1,
                          )
                          .withOpacity(0.9),
                      width: 1.5,
                      padding: 10.0,
                      icon: Icon(
                        SubjectIcon.resolveVariant(
                            context: context, subject: lesson.subject),
                        size: 32.0,
                        color: ColorsUtils()
                            .darken(
                              Theme.of(context).colorScheme.secondary,
                              amount: 0.1,
                            )
                            .withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 55.0,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.vertical(
                        top: const Radius.circular(12.0),
                        bottom: (lesson.description.replaceAll(' ', '') != '')
                            ? const Radius.circular(6.0)
                            : const Radius.circular(12.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${DateFormat('H:mm').format(lesson.start)} - ${DateFormat('H:mm').format(lesson.end)}',
                          style: TextStyle(
                            color: AppColors.of(context).text.withOpacity(0.85),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          lesson.name,
                          style: TextStyle(
                            color: AppColors.of(context).text,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          lesson.teacher.name,
                          style: TextStyle(
                            color: AppColors.of(context).text.withOpacity(0.9),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (lesson.description.replaceAll(' ', '') != '')
                    const SizedBox(
                      height: 6.0,
                    ),
                  if (lesson.description.replaceAll(' ', '') != '')
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6.0),
                          bottom: Radius.circular(12.0),
                        ),
                      ),
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.description,
                            style: TextStyle(
                              color:
                                  AppColors.of(context).text.withOpacity(0.9),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // const SizedBox(
                  //   height: 24.0,
                  // ),
                  // GestureDetector(
                  //   onTap: () async {
                  //     ReverseSearch.getSubjectByLesson(lesson, context)
                  //         .then((subject) {
                  //       if (subject != null) {
                  //         GradesPage.jump(outsideContext, subject: subject);
                  //       } else {
                  //         ScaffoldMessenger.of(context)
                  //             .showSnackBar(CustomSnackBar(
                  //           content: Text("Cannot find subject".i18n,
                  //               style: const TextStyle(color: Colors.white)),
                  //           backgroundColor: AppColors.of(context).red,
                  //           context: context,
                  //         ));
                  //       }
                  //     });
                  //   },
                  //   child: Container(
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       color: Theme.of(context).colorScheme.background,
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //     padding: const EdgeInsets.all(16.0),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Text(
                  //           'view_subject'.i18n,
                  //           style: TextStyle(
                  //             color:
                  //                 AppColors.of(context).text.withOpacity(0.9),
                  //             fontSize: 18.0,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
