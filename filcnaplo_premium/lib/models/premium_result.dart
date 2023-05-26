class PremiumResult {
  final String accessToken;
  final List<String> scopes;
  final String login;

  PremiumResult({
    required this.accessToken,
    required this.scopes,
    required this.login,
  });

  factory PremiumResult.fromJson(Map json) {
    return PremiumResult(
      accessToken: json["access_token"] ?? "",
      scopes: (json["scopes"] ?? []).cast<String>(),
      login: json["login"],
    );
  }
}
