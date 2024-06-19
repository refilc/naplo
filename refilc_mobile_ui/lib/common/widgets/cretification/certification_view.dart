import 'package:refilc_kreta_api/models/grade.dart';
import 'package:refilc_mobile_ui/common/panel/panel.dart';
import 'package:refilc_mobile_ui/common/widgets/cretification/certification_card.dart';
import 'package:refilc_mobile_ui/common/widgets/cretification/certification_tile.dart';
import 'package:refilc_mobile_ui/common/hero_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CertificationView extends StatelessWidget {
  const CertificationView(this.grades, {super.key, required this.gradeType});

  final List<Grade> grades;
  final GradeType gradeType;

  static show(List<Grade> grades,
          {required BuildContext context, required GradeType gradeType}) =>
      Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
          builder: (context) =>
              CertificationView(grades, gradeType: gradeType)));

  @override
  Widget build(BuildContext context) {
    grades.sort((a, b) => a.subject.name.compareTo(b.subject.name));
    List<Widget> tiles = grades
        .map((e) => CertificationTile(
              e,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            ))
        .toList();
    return Scaffold(
      body: HeroScrollView(
        title: getGradeTypeTitle(gradeType),
        icon: FeatherIcons.award,
        iconSize: 50,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          physics: const BouncingScrollPhysics(),
          children: [
            SafeArea(
              child: Panel(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Column(
                  children: tiles,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
