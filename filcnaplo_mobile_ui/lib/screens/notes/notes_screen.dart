import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        title: Text("notes".i18n,
            style: TextStyle(color: AppColors.of(context).text)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
            onRefresh: () {
              return Future(() => null);
            },
            child: Text('soon')),
      ),
    );
  }
}
