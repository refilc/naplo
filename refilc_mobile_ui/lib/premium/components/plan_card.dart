import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlusPlanCard extends StatelessWidget {
  const PlusPlanCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.description,
    required this.color,
    this.price = 0,
    this.url,
    this.active = false,
    this.borderRadius,
    this.features = const [],
  });

  final String iconPath;
  final String title;
  final String description;
  final Color color;
  final double price;
  final Uri? url;
  final bool active;
  final BorderRadiusGeometry? borderRadius;
  final List<List<String>> features;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (url != null) {
          launchUrl(
            url!,
            mode: LaunchMode.externalApplication,
          );
        }
      },
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius!,
        ),
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.white,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 18.0, bottom: 16.0, left: 22.0, right: 18.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        iconPath,
                        width: 25.0,
                        height: 25.0,
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 22.0,
                          color: color,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: active
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 196, 213, 253),
                                Color.fromARGB(255, 227, 235, 250),
                                Color.fromARGB(255, 214, 226, 250),
                              ],
                            )
                          : const LinearGradient(
                              colors: [
                                Color(0xFFEFF4FE),
                                Color(0xFFEFF4FE),
                              ],
                            ),
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: const Color(0xFFEFF4FE),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 0.0),
                      child: Text(
                        active
                            ? 'Aktív'
                            : '${price.toStringAsFixed(2).replaceAll('.', ',')} €',
                        style: const TextStyle(
                          fontSize: 16.6,
                          color: Color(0xFF243F76),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                description,
                style: TextStyle(
                  color: const Color(0xFF011234).withOpacity(0.6),
                  fontSize: 13.69,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 14.20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features
                    .map((e) => Column(
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 22.22,
                                  child: Text(
                                    e[0],
                                    style: const TextStyle(fontSize: 18.0),
                                  ),
                                ),
                                const SizedBox(
                                  width: 14.0,
                                ),
                                Expanded(
                                  child: e[1].endsWith('tier_benefits')
                                      ? Text.rich(
                                          style: const TextStyle(
                                            height: 1.2,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF011234),
                                            fontSize: 13.69,
                                          ),
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Minden ',
                                              ),
                                              e[1].startsWith('cap')
                                                  ? const TextSpan(
                                                      text: 'Kupak',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF47BB00),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )
                                                  : const TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Kupak',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF47BB00),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: ' és ',
                                                        ),
                                                        TextSpan(
                                                          text: 'Tinta',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF0061BB),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              const TextSpan(text: ' előny'),
                                            ],
                                          ),
                                        )
                                      : Text(
                                          e[1],
                                          maxLines: 2,
                                          style: const TextStyle(
                                            height: 1.2,
                                            color: Color(0xFF011234),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13.69,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
