import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen(this.details, {Key? key}) : super(key: key);

  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: AppColors.of(context).text),
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(FeatherIcons.alertTriangle, size: 48.0, color: AppColors.of(context).red),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "An error occurred...",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.0),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: CupertinoScrollbar(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: SelectableText(
                          (details.exceptionAsString() + '\n'),
                          style: const TextStyle(fontFamily: "monospace"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
