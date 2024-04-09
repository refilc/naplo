// ignore_for_file: use_build_context_synchronously

import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_mobile_ui/plus/plus_screen.i18n.dart';
import 'package:refilc_mobile_ui/plus/components/plan_card.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:refilc_plus/ui/mobile/plus/upsell.dart';

import 'components/active_sponsor_card.dart';
// import 'components/github_button.dart';

class PlusScreen extends StatefulWidget {
  const PlusScreen({super.key});

  @override
  State<PlusScreen> createState() => PlusScreenState();
}

class PlusScreenState extends State<PlusScreen> {
  Uri parseTierUri({required String tierId}) {
    return Uri.parse(
        'https://github.com/sponsors/refilc/sponsorships?tier_id=$tierId&preview=true');
  }

  bool showLifetime = false;

  @override
  Widget build(BuildContext context) {
    LinearGradient plusGradient = const LinearGradient(
      colors: [
        Color(0xFF7087FF),
        Color(0xFF9069FF),
        Color(0xFFE4D7FF),
        Color(0xFFDBC5FF),
        Color(0xFFE57DFF),
        Color(0xFFDBB7FF),
        Color(0xFF6850FF),
        Color(0xFF2144FF),
      ],
      stops: [0.0, 0.16, 0.32, 0.49, 0.69, 0.8, 0.92, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    LinearGradient goldGradient = const LinearGradient(
      colors: [
        Color(0xFFFFBD70),
        Color(0xFFFFDE69),
        Color(0xFFFFECD7),
        Color(0xFFFFE4C5),
        Color(0xFFFFDB7D),
        Color(0xFFFFDEB7),
        Color(0xFFFFAE50),
        Color(0xFFFF9921),
      ],
      stops: [0.0, 0.16, 0.32, 0.49, 0.69, 0.8, 0.92, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: const Color(0xffF4F9FF),
      body: Container(
        padding: EdgeInsets.zero,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/premium_top_banner.png'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xffF4F9FF).withOpacity(0.30),
                const Color(0xffF4F9FF).withOpacity(0.40),
                const Color(0xffF4F9FF).withOpacity(0.50),
                const Color(0xffF4F9FF).withOpacity(0.60),
                const Color(0xffF4F9FF).withOpacity(0.70),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.1, 0.15, 0.2, 0.25],
            ),
          ),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xffF4F9FF).withOpacity(0.0),
                      const Color(0xffF4F9FF).withOpacity(0.7),
                      const Color(0xffF4F9FF).withOpacity(0.8),
                      const Color(0xffF4F9FF).withOpacity(0.9),
                      const Color(0xffF4F9FF),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.1, 0.15, 0.18, 0.22],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // heading (title, x button)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'reFilc+',
                              style: TextStyle(
                                fontSize: 33,
                                color: Color(0xFF0a1c41),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                FeatherIcons.x,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text.rich(
                          TextSpan(
                            text: 'even_more_cheaper'.i18n,
                            style: const TextStyle(
                              height: 1.2,
                              fontSize: 22,
                              color: Color(0xFF0A1C41),
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              WidgetSpan(
                                child: Transform.translate(
                                  offset: const Offset(1.0, -5.5),
                                  child: Text(
                                    '1',
                                    style: TextStyle(
                                      fontSize: 14.4,
                                      color: const Color(0xFF0A1C41)
                                          .withOpacity(0.5),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // cards and description
                      const SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'support_1'.i18n),
                              WidgetSpan(
                                child: Transform.translate(
                                  offset: const Offset(1.0, -3.6),
                                  child: Text(
                                    '2',
                                    style: TextStyle(
                                      color: const Color(0xFF011234)
                                          .withOpacity(0.5),
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: 'support_2'.i18n,
                              ),
                            ],
                            style: TextStyle(
                              color: const Color(0xFF011234).withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      PlusPlanCard(
                        active: ActiveSponsorCard.estimateLevel(
                                context.watch<PlusProvider>().scopes) ==
                            PremiumFeatureLevel.cap,
                        iconPath: 'assets/images/plus_tier_cap.png',
                        title: 'reFilc+',
                        description: 'tier_rfp'.i18n,
                        color: const Color(0xFF7C3EFF),
                        gradient: plusGradient,
                        id: showLifetime ? 'refilcpluslifetime' : 'refilcplus',
                        price: showLifetime ? 29.99 : 0.99,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16.0),
                            bottom: Radius.circular(16.0)),
                        features: [
                          ['✨', 'rfp_1'.i18n],
                          ['1️⃣', 'rfp_5'.i18n],
                          // ['👥', 'rfp_2'.i18n],
                          ['👋', 'rfp_3'.i18n],
                          ['📓', 'rfp_4'.i18n],
                          ['🎓', 'rfp_6'.i18n],
                          ['👕', 'rfp_14'.i18n],
                          ['👑', 'rfp_15'.i18n],
                          ['🔜', 'more_soon'.i18n],
                        ],
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      PlusPlanCard(
                        active: ActiveSponsorCard.estimateLevel(
                                context.watch<PlusProvider>().scopes) ==
                            PremiumFeatureLevel.ink,
                        iconPath: 'assets/images/plus_tier_ink.png',
                        title: 'reFilc+ Gold',
                        description: 'tier_rfpgold'.i18n,
                        color: const Color(0xFFFFBD3E),
                        gradient: goldGradient,
                        id: showLifetime
                            ? 'refilcplusgoldlifetime'
                            : 'refilcplusgold',
                        price: showLifetime ? 49.99 : 2.99,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16.0),
                            bottom: Radius.circular(16.0)),
                        features: [
                          ['🕑', 'rfp_7'.i18n],
                          ['🔤', 'rfp_8'.i18n],
                          // ['👥', 'rfp_9'.i18n],
                          // ['🎓', 'Összesített átlagszámoló'],
                          ['📱', 'rfp_10'.i18n],
                          ['🟦', 'rfp_11'.i18n],
                          ['📒', 'rfp_12'.i18n],
                          ['📅', 'rfp_13'.i18n],
                          ['👀', 'rfp_16'.i18n],
                          const ['🖋️', 'cap_tier_benefits'],
                          ['🔜', 'more_soon'.i18n],
                        ],
                      ),
                      // const SizedBox(
                      //   height: 8.0,
                      // ),
                      // PlusPlanCard(
                      //   active: ActiveSponsorCard.estimateLevel(
                      //           context.watch<PlusProvider>().scopes) ==
                      //       PremiumFeatureLevel.sponge,
                      //   iconPath: 'assets/images/plus_tier_sponge.png',
                      //   title: 'Szivacs',
                      //   description:
                      //       'Férj hozzá még több funkcióhoz, használj még több profilt és tedd egyszerűbbé mindennapjaid.',
                      //   color: const Color(0xFFFFC700),
                      //   id: 'refilcplusgold',
                      //   price: 4.99,
                      //   borderRadius: const BorderRadius.vertical(
                      //       top: Radius.circular(8.0),
                      //       bottom: Radius.circular(16.0)),
                      //   features: const [
                      //     ['👥', 'Korlátlan fiók használata egyszerre'],
                      //     ['🖋️', 'ink_cap_tier_benefits'],
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 18.0,
                      // ),
                      // const GithubLoginButton(),
                      // lifetime plan toggle
                      const SizedBox(
                        height: 18.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: AppColors.of(context).text.withOpacity(0.2),
                          ),
                        ),
                        child: SwitchListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 15.0, right: 10.0),
                          value: showLifetime,
                          onChanged: (value) {
                            setState(() {
                              showLifetime = !showLifetime;
                            });
                          },
                          title: Text('show_lifetime'.i18n),
                        ),
                      ),
                      // reactivate plus
                      const SizedBox(
                        height: 18.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: AppColors.of(context).text.withOpacity(0.2),
                          ),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 15.0, right: 10.0),
                          onTap: () async {
                            final result = await context
                                .read<PlusProvider>()
                                .auth
                                .refreshAuth(reactivate: true);

                            if (mounted) {
                              if (result) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                    "Sikeres aktiválás!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.green,
                                ));

                                Future.delayed(const Duration(seconds: 2),
                                    () => Navigator.of(context).pop());
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                    "Sikertelen aktiválás. Kérlek próbáld újra később!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.red,
                                ));
                              }
                            }
                          },
                          title: Text('reactivate'.i18n),
                        ),
                      ),
                      // faq section
                      const SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'faq'.i18n,
                          style: TextStyle(
                            color: const Color(0xFF011234).withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Card(
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.0),
                            bottom: Radius.circular(8.0),
                          ),
                        ),
                        shadowColor: Colors.transparent,
                        surfaceTintColor: const Color(0xffFFFFFF),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 18.0,
                            bottom: 16.0,
                            left: 22.0,
                            right: 18.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'money'.i18n,
                                style: const TextStyle(
                                  fontSize: 16.6,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 14.0,
                              ),
                              Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    color: const Color(0xFF011234)
                                        .withOpacity(0.6),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'm_1'.i18n,
                                    ),
                                    WidgetSpan(
                                      child: Transform.translate(
                                        offset: const Offset(1.0, -3.6),
                                        child: Text(
                                          '3',
                                          style: TextStyle(
                                            color: const Color(0xFF011234)
                                                .withOpacity(0.5),
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'm_2'.i18n,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Card(
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8.0),
                            bottom: Radius.circular(16.0),
                          ),
                        ),
                        shadowColor: Colors.transparent,
                        surfaceTintColor: const Color(0xffFFFFFF),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 18.0,
                            bottom: 16.0,
                            left: 22.0,
                            right: 18.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'open'.i18n,
                                style: const TextStyle(
                                  fontSize: 16.6,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 14.0,
                              ),
                              Text(
                                'o_1'.i18n,
                                style: TextStyle(
                                  color:
                                      const Color(0xFF011234).withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'desc'.i18n,
                          style: TextStyle(
                            color: const Color(0xFF011234).withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Card(
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8.0),
                            bottom: Radius.circular(16.0),
                          ),
                        ),
                        shadowColor: Colors.transparent,
                        surfaceTintColor: const Color(0xffFFFFFF),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 18.0,
                            bottom: 16.0,
                            left: 22.0,
                            right: 18.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff011234),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 2.5,
                                    ),
                                    child: const Text(
                                      '1',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 14.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'cheaper'.i18n,
                                      maxLines: 5,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.4,
                                        height: 1.3,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 14.0,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff011234),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.8,
                                      vertical: 2.5,
                                    ),
                                    child: const Text(
                                      '2',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 14.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'qwit'.i18n,
                                      maxLines: 5,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.4,
                                        height: 1.3,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 14.0,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff011234),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.6,
                                      vertical: 2.5,
                                    ),
                                    child: const Text(
                                      '3',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 14.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'apple'.i18n,
                                      maxLines: 5,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.4,
                                        height: 1.3,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 14.0,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff011234),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7.9,
                                      vertical: 2.5,
                                    ),
                                    child: const Text(
                                      '4',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 14.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'eur'.i18n,
                                      maxLines: 5,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.4,
                                        height: 1.3,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 14.0,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff011234),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7.9,
                                      vertical: 2.5,
                                    ),
                                    child: const Text(
                                      '5',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 14.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'faq_dc'.i18n,
                                      maxLines: 5,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.4,
                                        height: 1.3,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
