import 'package:refilc_premium/models/premium_scopes.dart';

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
      accessToken: json["access_token"] ?? "igen",
      scopes: (json["scopes"] ?? [PremiumScopes.all]).cast<String>(),
      login: json["login"] ?? "igen",
    );
  }
}
