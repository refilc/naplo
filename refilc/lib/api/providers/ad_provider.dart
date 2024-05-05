import 'package:refilc/api/client.dart';
import 'package:refilc/models/ad.dart';
import 'package:flutter/material.dart';

class AdProvider extends ChangeNotifier {
  // private
  late List<Ad> _ads;
  bool get available => _ads.isNotEmpty;

  // public
  List<Ad> get ads => _ads;

  AdProvider({
    List<Ad> initialAds = const [],
    required BuildContext context,
  }) {
    _ads = List.castFrom(initialAds);
  }

  Future<void> fetch() async {
    _ads = await FilcAPI.getAds() ?? [];
    _ads.sort((a, b) => -a.date.compareTo(b.date));

    // check for new ads
    if (_ads.isNotEmpty) {
      notifyListeners();
    }
  }
}
