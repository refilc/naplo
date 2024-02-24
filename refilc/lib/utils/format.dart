import 'dart:math';

import 'package:refilc_kreta_api/models/week.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:html/parser.dart';
import 'format.i18n.dart';

extension StringFormatUtils on String {
  String specialChars() => replaceAll("é", "e")
      .replaceAll("á", "a")
      .replaceAll("ó", "o")
      .replaceAll("ő", "o")
      .replaceAll("ö", "o")
      .replaceAll("ú", "u")
      .replaceAll("ű", "u")
      .replaceAll("ü", "u")
      .replaceAll("í", "i");

  String capital() => isNotEmpty ? this[0].toUpperCase() + substring(1) : "";

  String capitalize() => split(" ").map((w) => w.capital()).join(" ");

  String escapeHtml() {
    String htmlString = this;
    htmlString = htmlString.replaceAll("\r", "");
    htmlString = htmlString.replaceAll(RegExp(r'<br ?/?>'), "\n");
    htmlString = htmlString.replaceAll(RegExp(r'<p ?>'), "");
    htmlString = htmlString.replaceAll(RegExp(r'</p ?>'), "\n");
    var document = parse(htmlString);
    return document.body?.text.trim() ?? htmlString;
  }

  String limit(int max) {
    if (length <= max) return this;
    return '${substring(0, min(length, 14))}…';
  }
}

extension DateFormatUtils on DateTime {
  String format(BuildContext context,
      {bool timeOnly = false, bool forceToday = false, bool weekday = false}) {
    // Time only
    if (timeOnly) return DateFormat("HH:mm").format(this);

    DateTime now = DateTime.now();
    if (now.year == year && now.month == month && now.day == day) {
      if (hour == 0 && minute == 0 && second == 0 || forceToday)
        return "Today".i18n;
      return DateFormat("HH:mm").format(this);
    }
    if (now.year == year &&
        now.month == month &&
        now.subtract(const Duration(days: 1)).day == day)
      return "Yesterday".i18n;
    if (now.year == year &&
        now.month == month &&
        now.add(const Duration(days: 1)).day == day) return "Tomorrow".i18n;

    String formatString;

    // If date is current week, show only weekday
    if (Week.current().start.isBefore(this) &&
        Week.current().end.isAfter(this)) {
      formatString = "EEEE";
    } else {
      if (year == now.year) {
        formatString = "MMM dd.";
      } else {
        formatString = "yy/MM/dd";
      } // ex. 21/01/01

      if (weekday) formatString += " (EEEE)"; // ex. (monday)
    }
    return DateFormat(formatString, I18n.of(context).locale.toString())
        .format(this)
        .capital();
  }
}
