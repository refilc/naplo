import 'package:filcnaplo/models/supporter.dart';
import 'package:filcnaplo_mobile_ui/premium/components/supporter_chip.dart';
import 'package:filcnaplo_mobile_ui/premium/components/supporter_tile.dart';
import 'package:flutter/material.dart';

class SupporterGroupCard extends StatelessWidget {
  const SupporterGroupCard({
    Key? key,
    this.title,
    this.icon,
    this.expanded = false,
    this.supporters = const [],
    this.glow,
  }) : super(key: key);

  final Widget? icon;
  final Widget? title;
  final bool expanded;
  final List<Supporter> supporters;
  final Color? glow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          if (glow != null)
            BoxShadow(
              color: glow!.withOpacity(.2),
              blurRadius: 60.0,
            ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 12.0)],
                  if (title != null)
                    Expanded(
                      child: DefaultTextStyle(
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w700),
                        child: title!,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12.0),
              if (expanded)
                Column(
                  children: supporters.map((e) => SupporterTile(supporter: e)).toList(),
                )
              else
                Wrap(
                  spacing: 8.0,
                  children: supporters.map((e) => SupporterChip(supporter: e)).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
