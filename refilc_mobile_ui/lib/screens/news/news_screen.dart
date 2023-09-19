import 'dart:math';

import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_mobile_ui/common/empty.dart';
import 'package:refilc_mobile_ui/common/panel/panel.dart';
import 'package:refilc_mobile_ui/screens/news/news_tile.dart';
import 'package:refilc/models/news.dart';
import 'package:refilc_mobile_ui/screens/news/news_view.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc/api/providers/news_provider.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var newsProvider = Provider.of<NewsProvider>(context);

    List<News> news = [];
    news = newsProvider.news.where((e) => e.title != "").toList();

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        title: Text("news".i18n,
            style: TextStyle(color: AppColors.of(context).text)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => newsProvider.fetch(),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemCount: max(news.length, 1),
            itemBuilder: (context, index) {
              if (news.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  child: Panel(
                    child: Material(
                      type: MaterialType.transparency,
                      child: NewsTile(
                        news[index],
                        onTap: () => NewsView.show(news[index],
                            context: context, force: true),
                      ),
                    ),
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Empty(subtitle: "Nothing to see here"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
