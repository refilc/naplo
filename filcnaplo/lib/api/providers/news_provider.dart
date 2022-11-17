// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:filcnaplo/api/client.dart';
import 'package:filcnaplo/models/news.dart';
import 'package:filcnaplo/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsProvider extends ChangeNotifier {
  // Private
  late List<News> _news;
  late int _state;
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
    var state_ = Provider.of<SettingsProvider>(_context, listen: false).newsState;

    if (state_ == -1) {
      var news_ = await FilcAPI.getNews();
      if (news_ != null) {
        state_ = news_.length;
        _news = news_;
      }
    }

    _state = state_;
    Provider.of<SettingsProvider>(_context, listen: false).update(_context, newsState: _state);
  }

  Future<void> fetch() async {
    var news_ = await FilcAPI.getNews();
    if (news_ == null) return;

    _news = news_;
    _fresh = news_.length - _state;

    if (_fresh < 0) {
      _state = news_.length;
      Provider.of<SettingsProvider>(_context, listen: false).update(_context, newsState: _state);
    }

    _fresh = max(_fresh, 0);

    if (_fresh > 0) {
      show = true;
      notifyListeners();
    }
  }

  void lock() => show = false;

  void release() {
    if (_fresh == 0) return;

    _fresh--;
    _state++;

    Provider.of<SettingsProvider>(_context, listen: false).update(_context, newsState: _state);

    if (_fresh > 0) {
      show = true;
    } else {
      show = false;
    }

    notifyListeners();
  }
}
