import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc_mobile_ui/common/action_button.dart';
import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:refilc_plus/ui/mobile/plus/activation_view/activation_view.dart';
import 'package:refilc_mobile_ui/plus/plus_screen.i18n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class PlusPlanCard extends StatelessWidget {
  const PlusPlanCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.description,
    required this.color,
    required this.gradient,
    this.price = 0,
    required this.id,
    this.active = false,
    this.borderRadius,
    this.features = const [],
    required this.docsAccepted,
  });

  final String iconPath;
  final String title;
  final String description;
  final Color color;
  final LinearGradient gradient;
  final double price;
  final String id;
  final bool active;
  final BorderRadiusGeometry? borderRadius;
  final List<List<String>> features;
  final bool docsAccepted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (!docsAccepted) {
        //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text(
        //       "El kell fogadnod az ÁSZF-et és az Adatkezelési Tájékoztatót!",
        //       style:
        //           TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //     ),
        //     backgroundColor: Colors.white,
        //   ));

        //   return;
        // }

        if (Provider.of<SettingsProvider>(context, listen: false).xFilcId ==
            "none") {
          Provider.of<SettingsProvider>(context, listen: false)
              .update(xFilcId: const Uuid().v4(), store: true);
        }

        // if (Provider.of<SettingsProvider>(context, listen: false).xFilcId ==
        //     "none") {
        //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content: Text(
        //       "Be kell kapcsolnod a Névtelen Analitikát a beállítások főoldalán, mielőtt reFilc+ előfizetést vásárolnál!",
        //       style:
        //           TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //     ),
        //     backgroundColor: Colors.white,
        //   ));

        //   return;
        // }

        if (Provider.of<PlusProvider>(context, listen: false).hasPremium) {
          if (!active) {
            launchUrl(
              Uri.parse(
                  'https://billing.stripe.com/p/login/4gwbIRclL89D5PicMM'),
              mode: LaunchMode.inAppBrowserView,
            );
          }

          return;
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            title: Text('docs'.i18n),
            content: Text('docs_acceptance'.i18n),
            actions: [
              ActionButton(
                label: "next".i18n,
                onTap: () {
                  // pop dialog
                  Navigator.of(context).pop();
                  // start payment process
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return PremiumActivationView(product: id);
                  }));
                },
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: borderRadius!.add(BorderRadius.circular(1.5)),
        ),
        padding: const EdgeInsets.all(1.5),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius!,
          ),
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.white,
          color: Colors.white.withOpacity(0.9),
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
                          width: iconPath.endsWith('ink.png') ? 29.0 : 25.0,
                          height: 25.0,
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 22.0,
                            color: Color(0xFF0B0B0B),
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
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: const Color(0xFFEFF4FE),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 2.0),
                        child: Text(
                          active
                              ? 'active'.i18n
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
                                                TextSpan(
                                                  text: 'every'.i18n,
                                                ),
                                                e[1].startsWith('cap')
                                                    ? const TextSpan(
                                                        text: 'reFilc+',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF7C3EFF),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )
                                                    : TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                            text: 'reFilc+',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF7C3EFF),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: 'and'.i18n,
                                                          ),
                                                          const TextSpan(
                                                            text:
                                                                'reFilc+ Gold',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF0061BB),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                TextSpan(text: 'benefit'.i18n),
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
      ),
    );
  }
}
