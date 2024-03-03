// ignore_for_file: use_build_context_synchronously
import 'package:refilc/api/client.dart';
import 'package:refilc/models/news.dart';
import 'package:refilc/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsProvider extends ChangeNotifier {
  // Private
  late List<News> _news;
  //late int _state;
  late int _fresh;
  bool show = false;
  late BuildContext _context;

  // Public
  List<News> get news => _news;
  int get state => _fresh - 1;

  NewsProvider({
    List<News> initialNews = const [],
    required BuildContext context,
  }) {
    _news = List.castFrom(initialNews);
    _context = context;
  }

  Future<void> restore() async {
    // Load news state from the database
    var seen_ = Provider.of<SettingsProvider>(_context, listen: false).seenNews;

    if (seen_.isEmpty) {
      var news_ = await FilcAPI.getNews();
      if (news_ != null) {
        _news = news_;
        show = true;
      }
    }

    //_state = seen_;
    // Provider.of<SettingsProvider>(_context, listen: false)
    //     .update(seenNewsId: news_.id);
  }

  Future<void> fetch() async {
    var news_ = await FilcAPI.getNews();
    if (news_ == null) return;

    show = false;

    _news = news_;

    for (var news in news_) {
      if (news.expireDate.isAfter(DateTime.now()) &&
          Provider.of<SettingsProvider>(_context, listen: false)
                  .seenNews
                  .contains(news.id) ==
              false) {
        show = true;
        Provider.of<SettingsProvider>(_context, listen: false)
            .update(seenNewsId: news.id);

        notifyListeners();
      }
    }
    // print(news_.length);
    // print(_state);

    // _news = news_;
    // _fresh = news_.length - _state;

    // if (_fresh < 0) {
    //   _state = news_.length;
    //   Provider.of<SettingsProvider>(_context, listen: false)
    //       .update(newsState: _state);
    // }

    // _fresh = max(_fresh, 0);

    // if (_fresh > 0) {
    //   show = true;
    //   notifyListeners();
    // }

    // print(_fresh);
    // print(_state);
    // print(show);
  }

  void lock() => show = false;

  void release() {
    // if (_fresh == 0) return;

    // _fresh--;
    // //_state++;

    // // Provider.of<SettingsProvider>(_context, listen: false)
    // //     .update(seenNewsId: _state);

    // if (_fresh > 0) {
    //   show = true;
    // } else {
    //   show = false;
    // }

    // notifyListeners();
  }
}
