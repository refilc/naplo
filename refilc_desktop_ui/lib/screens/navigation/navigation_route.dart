class NavigationRoute {
  late String _name;
  late int _index;

  final List<String> _internalPageMap = [
    "home",
    "grades",
    "timetable",
    "messages",
    "absences",
  ];

  String get name => _name;
  int get index => _index;

  set name(String n) {
    _name = n;
    _index = _internalPageMap.indexOf(n);
  }

  set index(int i) {
    _index = i;
    _name = _internalPageMap.elementAt(i);
  }
}
