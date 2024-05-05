// ignore_for_file: use_build_context_synchronously

import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:refilc/helpers/subject.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc/theme/colors/utils.dart';
import 'package:refilc/utils/format.dart';
import 'package:refilc/utils/reverse_search.dart';
import 'package:refilc_kreta_api/models/exam.dart';
import 'package:refilc_kreta_api/models/lesson.dart';
import 'package:refilc_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:refilc_mobile_ui/common/round_border_icon.dart';
import 'package:refilc_mobile_ui/common/widgets/exam/exam_tile.dart';
import 'package:flutter/material.dart';

class ExamViewable extends StatelessWidget {
  const ExamViewable(this.exam,
      {super.key, this.showSubject = true, this.tilePadding});

  final Exam exam;
  final bool showSubject;
  final EdgeInsetsGeometry? tilePadding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ExamPopup.show(context: context, exam: exam),
      child: ExamTile(
        exam,
        showSubject: showSubject,
        padding: tilePadding,
      ),
    );
    // return Viewable(
    //   tile: ExamTile(
    //     exam,
    //     showSubject: showSubject,
    //     padding: tilePadding,
    //   ),
    //   view: CardHandle(child: ExamView(exam)),
    // );
  }
}

class ExamPopup extends StatelessWidget {
  const ExamPopup({
    super.key,
    required this.exam,
    required this.outsideContext,
    required this.lesson,
  });

  final Exam exam;
  final BuildContext outsideContext;
  final Lesson? lesson;

  static void show({
    required BuildContext context,
    required Exam exam,
  }) async =>
      showRoundedModalBottomSheet(
        context,
        child: ExamPopup(
          exam: exam,
          outsideContext: context,
          lesson: (await ReverseSearch.getLessonByExam(exam, context)),
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
                            context: context, subject: exam.subject),
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
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0),
                          bottom: Radius.circular(6.0)),
                    ),
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        const RoundBorderIcon(
                          padding: 8.0,
                          icon: Icon(
                            Icons.edit_document,
                            size: 20.0,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exam.description.capital(),
                              style: TextStyle(
                                color:
                                    AppColors.of(context).text.withOpacity(0.9),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              (exam.mode?.description ?? 'Ismeretlen')
                                  .capital(),
                              style: TextStyle(
                                color: AppColors.of(context).text,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (lesson != null)
                    const SizedBox(
                      height: 6.0,
                    ),
                  if (lesson != null)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6.0),
                            bottom: Radius.circular(12.0)),
                      ),
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                SubjectIcon.resolveVariant(
                                    context: context, subject: exam.subject),
                                size: 20.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                (((lesson?.subject.isRenamed ?? false) &&
                                            Provider.of<SettingsProvider>(
                                                    context,
                                                    listen: false)
                                                .renamedSubjectsEnabled)
                                        ? lesson?.subject.renamedTo
                                        : (lesson?.subject.name ?? '')
                                            .capital()) ??
                                    'Ismeretlen',
                                style: TextStyle(
                                  color: AppColors.of(context)
                                      .text
                                      .withOpacity(0.9),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: ((lesson?.subject.isRenamed ??
                                              false) &&
                                          Provider.of<SettingsProvider>(context,
                                                  listen: false)
                                              .renamedSubjectsItalics)
                                      ? FontStyle.italic
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${DateFormat('H:mm').format(lesson!.start)} - ${DateFormat('H:mm').format(lesson!.end)}',
                            style: TextStyle(
                              color:
                                  AppColors.of(context).text.withOpacity(0.85),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
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
