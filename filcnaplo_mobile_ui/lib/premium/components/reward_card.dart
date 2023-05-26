import 'package:flutter/material.dart';

class PremiumRewardCard extends StatelessWidget {
  const PremiumRewardCard({Key? key, this.imageKey, this.icon, this.title, this.description, this.soon = false}) : super(key: key);

  final String? imageKey;
  final Widget? icon;
  final Widget? title;
  final Widget? description;
  final bool soon;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (soon)
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Chip(
                labelPadding: EdgeInsets.zero,
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                backgroundColor: Color(0x777645D3),
                label: Text("Hamarosan", style: TextStyle(fontWeight: FontWeight.w500)),
              ),
            ),
          if (imageKey != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0).add(EdgeInsets.only(bottom: 12.0, top: soon ? 0 : 14.0)),
              child: Image.asset("assets/images/${imageKey!}.png"),
            )
          else
            const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                if (icon != null) ...[icon!, const SizedBox(width: 12.0)],
                if (title != null)
                  Expanded(
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700, fontSize: 20),
                      child: title!,
                    ),
                  ),
              ],
            ),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0).add(const EdgeInsets.only(top: 4.0, bottom: 12.0)),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                child: description!,
              ),
            ),
        ],
      ),
    );
  }
}
