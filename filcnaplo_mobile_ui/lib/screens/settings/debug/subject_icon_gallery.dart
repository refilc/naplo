import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:flutter/material.dart';

class SubjectIconGallery extends StatelessWidget {
  const SubjectIconGallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        title: Text(
          "Subject Icon Gallery",
          style: TextStyle(color: AppColors.of(context).text),
        ),
      ),
      body: ListView(
        children: const [
          SubjectIconItem("Matematika"),
          SubjectIconItem("Magyar Nyelv"),
          SubjectIconItem("Nyelvtan"),
          SubjectIconItem("Irodalom"),
          SubjectIconItem("Történelem"),
          SubjectIconItem("Földrajz"),
          SubjectIconItem("Rajz"),
          SubjectIconItem("Vizuális kultúra"),
          SubjectIconItem("Fizika"),
          SubjectIconItem("Ének"),
          SubjectIconItem("Testnevelés"),
          SubjectIconItem("Kémia"),
          SubjectIconItem("Biológia"),
          SubjectIconItem("Természetismeret"),
          SubjectIconItem("Erkölcstan"),
          SubjectIconItem("Pénzügy"),
          SubjectIconItem("Informatika"),
          SubjectIconItem("Digitális kultúra"),
          SubjectIconItem("Programozás"),
          SubjectIconItem("Hálózat"),
          SubjectIconItem("Színház technika"),
          SubjectIconItem("Média"),
          SubjectIconItem("Elektronika"),
          SubjectIconItem("Gépészet"),
          SubjectIconItem("Technika"),
          SubjectIconItem("Tánc"),
          SubjectIconItem("Filozófia"),
          SubjectIconItem("Osztályfőnöki"),
          SubjectIconItem("Gazdaság"),
          SubjectIconItem("Szorgalom"),
          SubjectIconItem("Magatartás"),
          SubjectIconItem("Angol nyelv"),
          SubjectIconItem("Linux"),
        ],
      ),
    );
  }
}

class SubjectIconItem extends StatelessWidget {
  const SubjectIconItem(this.name, {Key? key}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        SubjectIcon.resolveVariant(subjectName: name, context: context),
        color: AppColors.of(context).text,
      ),
      title: Text(
        name,
        style: TextStyle(
          color: AppColors.of(context).text,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
