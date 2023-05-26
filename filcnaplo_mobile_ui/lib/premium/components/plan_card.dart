import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumPlanCard extends StatelessWidget {
  const PremiumPlanCard({
    Key? key,
    this.icon,
    this.title,
    this.description,
    this.price = 0,
    this.url,
    this.gradient,
    this.active = false,
  }) : super(key: key);

  final Widget? icon;
  final Widget? title;
  final int price;
  final Widget? description;
  final String? url;
  final Gradient? gradient;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onTap: () {
          if (url != null) {
            launchUrl(
              Uri.parse(url!),
              mode: LaunchMode.externalApplication,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!active)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (icon != null) ...[
                            IconTheme(
                              data: Theme.of(context).iconTheme.copyWith(size: 42.0),
                              child: icon!,
                            ),
                            const SizedBox(height: 12.0),
                          ],
                          DefaultTextStyle(
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold, fontSize: 25.0),
                            child: title!,
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: BorderRadius.circular(99.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(99.0),
                            ),
                            margin: const EdgeInsets.all(4.0),
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: const Text(
                              "Aktív",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(text: "\$$price"),
                      TextSpan(
                        text: " / hó",
                        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(.7)),
                      ),
                    ]),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                ],
              ),
              if (active) ...[
                const SizedBox(height: 18.0),
                Row(
                  children: [
                    if (icon != null) ...[
                      IconTheme(
                        data: Theme.of(context).iconTheme.copyWith(size: 24.0, color: AppColors.of(context).text),
                        child: icon!,
                      ),
                    ],
                    const SizedBox(width: 12.0),
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold, fontSize: 25.0),
                      child: title!,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 6.0),
              if (description != null)
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(.8), fontSize: 18),
                  child: description!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
