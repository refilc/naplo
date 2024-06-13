import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:refilc/utils/format.dart';

class DayTitle extends StatefulWidget {
  const DayTitle({super.key, required this.dayTitle, required this.controller});

  final String Function(int) dayTitle;
  final TabController controller;

  @override
  State<DayTitle> createState() => _DayTitleState();
}

class _DayTitleState extends State<DayTitle> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listener);
  }

  void listener() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
        animation: widget.controller.animation!,
        builder: (context, _) {
          double value = widget.controller.animation!.value;

          return Transform.translate(
            offset: Offset(-value * width / 1.5, 0),
            child: Row(
              children: List.generate(
                widget.controller.length,
                (index) {
                  double opacity = (value - index + 1).clamp(0, 1);

                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text(
                      widget.dayTitle(index).capital(),
                      style: Provider.of<SettingsProvider>(context)
                                      .fontFamily !=
                                  '' &&
                              Provider.of<SettingsProvider>(context)
                                  .titleOnlyFont
                          ? GoogleFonts.getFont(
                              Provider.of<SettingsProvider>(context).fontFamily,
                              textStyle: TextStyle(
                                  color: AppColors.of(context)
                                      .text
                                      .withOpacity(opacity),
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold),
                            )
                          : TextStyle(
                              color: AppColors.of(context)
                                  .text
                                  .withOpacity(opacity),
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
