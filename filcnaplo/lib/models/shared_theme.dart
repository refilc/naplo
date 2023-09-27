import 'dart:ui';

class SharedTheme {
  Map json;
  String id;
  bool isPublic;
  String nickname;
  Color backgroundColor;
  Color panelsColor;
  Color accentColor;
  SharedGradeColors gradeColors;

  SharedTheme({
    required this.json,
    required this.id,
    this.isPublic = false,
    this.nickname = 'Anonymous',
    required this.backgroundColor,
    required this.panelsColor,
    required this.accentColor,
    required this.gradeColors,
  });

  factory SharedTheme.fromJson(Map json, Map gradeColorsJson) {
    return SharedTheme(
      json: json,
      id: json['public_id'],
      isPublic: json['is_public'] ?? false,
      nickname: json['nickname'] ?? 'Anonymous',
      backgroundColor: Color(json['background_color']),
      panelsColor: Color(json['panels_color']),
      accentColor: Color(json['accent_color']),
      gradeColors: SharedGradeColors.fromJson(gradeColorsJson),
    );
  }
}

class SharedGradeColors {
  Map json;
  String id;
  bool isPublic;
  String nickname;
  Color fiveColor;
  Color fourColor;
  Color threeColor;
  Color twoColor;
  Color oneColor;
  String linkedThemeId;

  SharedGradeColors({
    required this.json,
    required this.id,
    this.isPublic = false,
    this.nickname = 'Anonymous',
    required this.fiveColor,
    required this.fourColor,
    required this.threeColor,
    required this.twoColor,
    required this.oneColor,
    required this.linkedThemeId,
  });

  factory SharedGradeColors.fromJson(Map json) {
    return SharedGradeColors(
      json: json,
      id: json['public_id'],
      isPublic: json['is_public'] ?? false,
      nickname: json['nickname'] ?? 'Anonymous',
      fiveColor: Color(json['five_color']),
      fourColor: Color(json['four_color']),
      threeColor: Color(json['three_color']),
      twoColor: Color(json['two_color']),
      oneColor: Color(json['one_color']),
      linkedThemeId: json['linked_theme_id'],
    );
  }
}
