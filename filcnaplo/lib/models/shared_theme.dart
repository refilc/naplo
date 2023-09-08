import 'dart:ui';

class SharedTheme {
  Map json;
  String id;
  bool isPublic;
  String nickname;
  Color backgroundColor;
  Color panelsColor;
  Color accentColor;

  SharedTheme({
    required this.json,
    required this.id,
    this.isPublic = false,
    this.nickname = 'Anonymous',
    required this.backgroundColor,
    required this.panelsColor,
    required this.accentColor,
  });

  factory SharedTheme.fromJson(Map json) {
    return SharedTheme(
      json: json,
      id: json['public_id'],
      isPublic: json['is_public'] ?? false,
      nickname: json['nickname'] ?? 'Anonymous',
      backgroundColor: json['background_color'],
      panelsColor: json['panels_color'],
      accentColor: json['accent_color'],
    );
  }
}
