import 'package:flutter/widgets.dart';

class FilcIcons {
  static const IconData home = FilcIconData(0x41);
  static const IconData linux = FilcIconData(0x42);
}

class FilcIconData extends IconData {
  const FilcIconData(int codePoint) : super(codePoint, fontFamily: "FilcIcons");
}
