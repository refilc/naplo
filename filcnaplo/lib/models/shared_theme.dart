import 'dart:ui';

class SharedTheme {
  Map json;
  String id;
  bool isPublic;
  String nickname;
  Color backgroundColor;
  Color panelsColor;
  Color accentColor;
  Color iconColor;
  bool shadowEffect;
  SharedGradeColors gradeColors;

  SharedTheme({
    required this.json,
    required this.id,
    this.isPublic = false,
    this.nickname = 'Anonymous',
    required this.backgroundColor,
    required this.panelsColor,
    required this.accentColor,
    required this.iconColor,
    required this.shadowEffect,
    required this.gradeColors,
  });

  factory SharedTheme.fromJson(Map json, SharedGradeColors gradeColors) {
    return SharedTheme(
      json: json,
      id: json['public_id'],
      isPublic: json['is_public'] ?? false,
      nickname: json['nickname'] ?? 'Anonymous',
      backgroundColor: Color(json['background_color']),
      panelsColor: Color(json['panels_color']),
      accentColor: Color(json['accent_color']),
      iconColor: Color(json['icon_color']),
      shadowEffect: json['shadow_effect'] ?? true,
      gradeColors: gradeColors,
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
    );
  }
}
