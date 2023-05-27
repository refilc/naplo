import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_premium/api/auth.dart';
import 'package:filcnaplo_premium/models/premium_scopes.dart';
import 'package:flutter/widgets.dart';

class PremiumProvider extends ChangeNotifier {
  final SettingsProvider _settings;
  List<String> get scopes => _settings.premiumScopes;
  bool hasScope(String scope) => true;
  String get accessToken => _settings.premiumAccessToken;
  String get login => _settings.premiumLogin;
  bool get hasPremium => true;

  late final PremiumAuth _auth;
  PremiumAuth get auth => _auth;

  PremiumProvider({required SettingsProvider settings}) : _settings = settings {
    _auth = PremiumAuth(settings: _settings);
    _settings.addListener(() {
      notifyListeners();
    });
  }

  Future<void> activate({bool removePremium = false}) async {
    await _auth.refreshAuth(removePremium: removePremium);
    notifyListeners();
  }
}
