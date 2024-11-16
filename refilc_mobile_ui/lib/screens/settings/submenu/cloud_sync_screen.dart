// import 'package:refilc/models/settings.dart';
import 'package:refilc/api/client.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_mobile_ui/common/panel/panel_button.dart';
import 'package:refilc_mobile_ui/common/splitted_panel/splitted_panel.dart';
import 'package:refilc_mobile_ui/screens/login/qwid_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:refilc/models/cloud_sync_data.dart';
// import 'package:provider/provider.dart';
import 'submenu_screen.i18n.dart';

class MenuCloudSyncSettings extends StatelessWidget {
  const MenuCloudSyncSettings({
    super.key,
    this.borderRadius = const BorderRadius.vertical(
        top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
  });

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      onPressed: () => Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(
            builder: (context) => const CloudSyncSettingsScreen()),
      ),
      title: Text("cloud_sync".i18n),
      leading: Icon(
        FeatherIcons.uploadCloud,
        size: 22.0,
        color: AppColors.of(context).text.withOpacity(0.95),
      ),
      borderRadius: borderRadius,
    );
  }
}

class CloudSyncSettingsScreen extends StatefulWidget {
  const CloudSyncSettingsScreen({super.key});

  @override
  CloudSyncSettingsScreenState createState() => CloudSyncSettingsScreenState();
}

class CloudSyncSettingsScreenState extends State<CloudSyncSettingsScreen> {
  late SettingsProvider settingsProvider;
  late UserProvider user;

  String longLivedToken = '';

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    // UserProvider user = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        title: Text(
          "cloud_sync".i18n,
          style: TextStyle(color: AppColors.of(context).text),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            children: [
              SplittedPanel(
                padding: const EdgeInsets.only(top: 8.0),
                cardPadding: const EdgeInsets.all(4.0),
                isSeparated: true,
                children: [
                  PanelButton(
                    padding: const EdgeInsets.only(left: 14.0, right: 6.0),
                    onPressed: () async {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled:
                            true, // This ensures the modal accommodates input fields properly
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.9 +
                                MediaQuery.of(context).viewInsets.bottom,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDAE4F7),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(24.0),
                                topLeft: Radius.circular(24.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFB9C8E5),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(2.0),
                                        topLeft: Radius.circular(2.0),
                                      ),
                                    ),
                                    width: 40,
                                    height: 4,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 14, left: 14, bottom: 24),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: QwIDLoginWidget(
                                          onLogin: (String token) {
                                            setState(() {
                                              longLivedToken = token;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ).then((value) {
                        // After closing the modal bottom sheet, check if the code is set
                        if (longLivedToken.isNotEmpty) {
                          // Call your API after retrieving the code
                          settingsProvider.update(
                            cloudSyncToken: longLivedToken,
                            store: true,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('login_successful'.i18n)));
                        }
                      });
                    },
                    trailingDivider: true,
                    title: Text(
                      "qwit_sign_in".i18n,
                      style: TextStyle(
                        color: AppColors.of(context).text.withOpacity(
                            settingsProvider.gradeOpeningFun ? .95 : .25),
                      ),
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12.0),
                      bottom: Radius.circular(12.0),
                    ),
                  ),
                  SwitchListTile(
                    value: settingsProvider.cloudSyncEnabled,
                    onChanged: (value) {
                      settingsProvider.update(
                        cloudSyncEnabled: value,
                        store: true,
                      );
                    },
                    title: Text("cloud_sync_enabled".i18n),
                  ),
                  PanelButton(
                    padding: const EdgeInsets.only(left: 14.0, right: 6.0),
                    onPressed: () async {
                      if (settingsProvider.cloudSyncToken.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('sign_in_first'.i18n),
                          ),
                        );
                        return;
                      } else {
                        FilcAPI.cloudSync(
                          {
                            "settings": settingsProvider.toMap(),
                            // "device_ids": [
                            //   settingsProvider.xFilcId,
                            // ],
                            // "refilc_plus_id": settingsProvider.plusSessionId,
                          },
                          settingsProvider.cloudSyncToken,
                        ).then((response) {
                          if (response == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('sync_failed'.i18n),
                              ),
                            );
                            return;
                          }

                          CloudSyncData cloudSyncData = CloudSyncData.fromJson(
                              response['data']['cloud_sync_data']);

                          settingsProvider.updateFromMap(
                            map: cloudSyncData.settings,
                            store: true,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('sync_successful'.i18n),
                            ),
                          );
                        });
                      }
                    },
                    trailingDivider: true,
                    title: Text(
                      "sync_now".i18n,
                      style: TextStyle(
                        color: AppColors.of(context).text.withOpacity(
                            settingsProvider.gradeOpeningFun ? .95 : .25),
                      ),
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12.0),
                      bottom: Radius.circular(12.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
