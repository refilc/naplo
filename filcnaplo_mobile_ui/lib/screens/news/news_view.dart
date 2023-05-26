import 'dart:io';

import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo_mobile_ui/common/dialog_button.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/models/news.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.i18n.dart';

class NewsView extends StatelessWidget {
  const NewsView(this.news, {Key? key}) : super(key: key);

  final News news;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 32.0),
      child: Material(
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Column(
            children: [
              // Content
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 6.0, top: 14.0, bottom: 8.0),
                      child: Text(
                        news.title,
                        maxLines: 3,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                      ),
                    ),
                    SelectableLinkify(
                      text: news.content.escapeHtml(),
                      options: const LinkifyOptions(looseUrl: true, removeWww: true),
                      onOpen: (link) {
                        launch(
                          link.url,
                          customTabsOption: CustomTabsOption(showPageTitle: true, toolbarColor: Theme.of(context).scaffoldBackgroundColor),
                        );
                      },
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
                    ),
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (news.link != "")
                    DialogButton(
                      label: news.openLabel != "" ? news.openLabel : "open".i18n.toUpperCase(),
                      onTap: () => launch(
                        news.link,
                        customTabsOption: CustomTabsOption(showPageTitle: true, toolbarColor: Theme.of(context).scaffoldBackgroundColor),
                      ),
                    ),
                  DialogButton(
                    label: "done".i18n,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<T?> show<T>(News news, {required BuildContext context, bool force = false}) {
    if (news.title == "") return Future<T?>.value(null);

    bool popup = news.platform == '' || force;

    if (Provider.of<SettingsProvider>(context, listen: false).newsEnabled || news.emergency || force) {
      switch (news.platform.trim().toLowerCase()) {
        case "android":
          if (Platform.isAndroid) popup = true;
          break;
        case "ios":
          if (Platform.isIOS) popup = true;
          break;
        case "linux":
          if (Platform.isLinux) popup = true;
          break;
        case "windows":
          if (Platform.isWindows) popup = true;
          break;
        case "macos":
          if (Platform.isMacOS) popup = true;
          break;
        default:
          popup = true;
      }
    } else {
      popup = false;
    }

    if (popup) {
      return showDialog<T?>(context: context, builder: (context) => NewsView(news), barrierDismissible: true);
    } else {
      return Future<T?>.value(null);
    }
  }
}
