// import 'package:filcnaplo/data/context/app.dart';
// import 'package:filcnaplo/data/models/lesson.dart';
// import 'package:filcnaplo/generated/i18n.dart';
// import 'package:filcnaplo/ui/common/custom_snackbar.dart';
// import 'package:filcnaplo/ui/pages/planner/timetable/day.dart';
// import 'package:filcnaplo/utils/format.dart';
// import 'package:filcnaplo/modules/printing/printerDebugScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:filcnaplo/ui/pages/planner/timetable/builder.dart';
// import 'package:flutter/foundation.dart';

// /*
// Author: daaniiieel
// Name: Timetable Printer (Experimental)
// Description: This module prints out the timetable for the selected user on the
// current week.
// */

// class TimetablePrinter {
//   pw.Document build(
//       BuildContext context, pw.Document pdf, List<Day> days, int min, int max) {
//     List rows = <pw.TableRow>[];

//     // build header row
//     List<pw.Widget> headerChildren = <pw.Widget>[pw.Container()];
//     days.forEach((day) => headerChildren.add(pw.Padding(
//         padding: pw.EdgeInsets.all(5),
//         child:
//             pw.Center(child: pw.Text(weekdayStringShort(context, day.date.weekday))))));
//     pw.TableRow headerRow = pw.TableRow(
//         children: headerChildren,
//         verticalAlignment: pw.TableCellVerticalAlignment.middle);
//     rows.add(headerRow);

//     // for each row
//     for (int i = min; i < max; i++) {
//       var children = <pw.Widget>[];
//       var row = pw.TableRow(children: children);

//       children.add(pw.Padding(
//           padding: pw.EdgeInsets.all(5),
//           child: pw.Center(child: pw.Text('$i. '))));
//       days.forEach((Day day) {
//         var lesson = day.lessons.firstWhere(
//             (element) => element.lessonIndex != '+'
//                 ? int.parse(element.lessonIndex) == i
//                 : false,
//             orElse: () => null);

//         children.add(lesson != null
//             ? pw.Padding(
//                 padding: pw.EdgeInsets.fromLTRB(5, 10, 5, 5),
//                 child: pw.Column(children: [
//                   pw.Text(lesson.name ?? lesson.subject.name),
//                   pw.Footer(
//                       leading: pw.Text(lesson.room),
//                       trailing: pw.Text(monogram(lesson.teacher))),
//                 ]))
//             : pw.Padding(padding: pw.EdgeInsets.all(5)));
//       });
//       rows.add(row);
//     }

//     // add timetable to pdf
//     pw.Table table = pw.Table(
//       children: rows,
//       border: pw.TableBorder.all(),
//       defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
//     );

//     // header and footer
//     pw.Footer footer = pw.Footer(
//       trailing: pw.Text('filcnaplo.hu'),
//       margin: pw.EdgeInsets.only(top: 12.0),
//     );
//     String className = app.user.sync.student.student.className;

//     pw.Footer header = pw.Footer(
//       margin: pw.EdgeInsets.all(5),
//       title: pw.Text(className, style: pw.TextStyle(fontSize: 30)),
//     );

//     pdf.addPage(pw.Page(
//         pageFormat: PdfPageFormat.a4
//             .landscape, // so the page looks normal both in portrait and landscape
//         orientation: pw.PageOrientation.landscape,
//         build: (pw.Context context) =>
//             pw.Column(children: <pw.Widget>[header, table, footer])));

//     return pdf;
//   }

//   void printPDF(final _scaffoldKey, BuildContext context) {
//     // pdf theme (for unicode support)
//     rootBundle.load("assets/Roboto-Regular.ttf").then((font) {
//       pw.ThemeData myTheme = pw.ThemeData.withFont(base: pw.Font.ttf(font));
//       pw.Document pdf = pw.Document(theme: myTheme);

//       // sync indicator
//       ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
//         message: I18n.of(context).syncTimetable,
//       ));

//       // get a builder and build current week
//       final timetableBuilder = TimetableBuilder();
//       timetableBuilder.build(timetableBuilder.getCurrentWeek());

//       int minLessonIndex = 1;
//       int maxLessonIndex = 1;
//       List<Day> weekDays = timetableBuilder.week.days;
//       for (Day day in weekDays) {
//         for (Lesson lesson in day.lessons) {
//           if (lesson.lessonIndex == '+') {
//             continue;
//           }
//           if (int.parse(lesson.lessonIndex) < minLessonIndex) {
//             minLessonIndex = int.parse(lesson.lessonIndex);
//           }
//           if (int.parse(lesson.lessonIndex) > maxLessonIndex) {
//             maxLessonIndex = int.parse(lesson.lessonIndex);
//           }
//         }
//       }

//       pdf = build(context, pdf, weekDays, minLessonIndex, maxLessonIndex);

//       // print pdf
//       if (kReleaseMode) {
//         Printing.layoutPdf(onLayout: (format) => pdf.save()).then((success) {
//           if (success)
//             ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
//               message: I18n.of(context).settingsExportExportTimetableSuccess,
//             ));
//         });
//       } else {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (c) =>
//                     PrintingDebugScreen((format) => Future.value(pdf.save()))));
//       }
//     });
//   }
// }
