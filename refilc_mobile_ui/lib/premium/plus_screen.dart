import 'package:refilc_mobile_ui/premium/components/plan_card.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc_plus/providers/premium_provider.dart';
import 'package:refilc_plus/ui/mobile/premium/upsell.dart';

import 'components/active_sponsor_card.dart';
import 'components/github_button.dart';

class PlusScreen extends StatelessWidget {
  const PlusScreen({super.key});

  Uri parseTierUri({required String tierId}) {
    return Uri.parse(
        'https://github.com/sponsors/refilc/sponsorships?tier_id=$tierId&preview=true');
  }

  @override
  Widget build(BuildContext context) {
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
                const Color(0xffF4F9FF).withOpacity(0.1),
                const Color(0xffF4F9FF).withOpacity(0.15),
                const Color(0xffF4F9FF).withOpacity(0.25),
                const Color(0xffF4F9FF).withOpacity(0.4),
                const Color(0xffF4F9FF).withOpacity(0.5),
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
                      const Color(0xffF4F9FF).withOpacity(0.4),
                      const Color(0xffF4F9FF).withOpacity(0.6),
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
                            text:
                                'Még több reFilc, olcsóbban,\nmint bármi más!',
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
                              const TextSpan(text: 'Támogasd a QwIT'),
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
                              const TextSpan(
                                text:
                                    ' csapatát, és szerezz cserébe pár kényelmes jutalmat!',
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
                                context.watch<PremiumProvider>().scopes) ==
                            PremiumFeatureLevel.cap,
                        iconPath: 'assets/images/plus_tier_cap.png',
                        title: 'Kupak',
                        description:
                            'Több személyre szabás, több fiók, egyszerű feladatfeljegyzés.',
                        color: const Color(0xFF47BB00),
                        url: parseTierUri(tierId: '371828'),
                        price: 0.99,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16.0),
                            bottom: Radius.circular(8.0)),
                        features: const [
                          ['✨', 'Előzetes hozzáférés új verziókhoz'],
                          ['👥', '2 fiók használata egyszerre'],
                          ['👋', 'Egyedi üdvözlő üzenet'],
                          [
                            '📓',
                            'Korlátlan saját jegyzet és feladat a füzet oldalon'
                          ],
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      PlusPlanCard(
                        active: ActiveSponsorCard.estimateLevel(
                                context.watch<PremiumProvider>().scopes) ==
                            PremiumFeatureLevel.ink,
                        iconPath: 'assets/images/plus_tier_ink.png',
                        title: 'Tinta',
                        description:
                            'Férj hozzá még több funkcióhoz, használj még több profilt és tedd egyszerűbbé mindennapjaid.',
                        color: const Color(0xFF0061BB),
                        url: parseTierUri(tierId: '371944'),
                        price: 2.99,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8.0),
                            bottom: Radius.circular(8.0)),
                        features: const [
                          ['🕑', 'Órarend jegyzetek'],
                          ['👥', '5 fiók használata egyszerre'],
                          ['🎓', 'Összesített átlagszámoló'],
                          ['🟦', 'Live Activity szín'],
                          ['🖋️', 'cap_tier_benefits'],
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      PlusPlanCard(
                        active: ActiveSponsorCard.estimateLevel(
                                context.watch<PremiumProvider>().scopes) ==
                            PremiumFeatureLevel.sponge,
                        iconPath: 'assets/images/plus_tier_sponge.png',
                        title: 'Szivacs',
                        description:
                            'Férj hozzá még több funkcióhoz, használj még több profilt és tedd egyszerűbbé mindennapjaid.',
                        color: const Color(0xFFFFC700),
                        url: parseTierUri(tierId: '371945'),
                        price: 4.99,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8.0),
                            bottom: Radius.circular(16.0)),
                        features: const [
                          ['📱', 'Alkalmazás ikonjának megváltoztatása'],
                          ['👥', 'Korlátlan fiók használata egyszerre'],
                          ['📒', 'Fejlettebb cél kitűzés'],
                          ['🔤', 'Egyedi betütípusok'],
                          ['🖋️', 'ink_cap_tier_benefits'],
                        ],
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      const GithubLoginButton(),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Gyakori kérdések',
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
                              const Text(
                                'Mire költitek a pénzt?',
                                style: TextStyle(
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
                                    const TextSpan(
                                      text:
                                          'A támogatásokból kapott pénz elsősorban az Apple',
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
                                    const TextSpan(
                                      text:
                                          ' Developer Program évi \$100-os díját, valamint az API mögött álló szerverek és a reFilc domain címek árát fedezi, a maradékot egyéb fejlesztésekre, fejlesztői fagyizásra fordítjuk.',
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
                              const Text(
                                'Még mindig nyílt a forráskód?',
                                style: TextStyle(
                                  fontSize: 16.6,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(
                                height: 14.0,
                              ),
                              Text(
                                'Igen, a reFilc teljesen nyílt forráskódú, és ez így is fog maradni. A reFilc+ funkcióinak forráskódjához bármely támogatónk hozzáférhet, ha ezt Discord-on kérelmezi.',
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
                          'Magyarázatok',
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
                                  const Expanded(
                                    child: Text(
                                      'A szolgáltatás legalacsonyabb szintje olcsóbb a legtöbb ismert előfizetésnél, viszont előfordulhatnak kivételek.',
                                      maxLines: 5,
                                      style: TextStyle(
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
                                  const Expanded(
                                    child: Text(
                                      'A "QwIT" a "QwIT Development" rövid neve, ez a fejlesztői csapat neve, mely a reFilc és egyéb projektek mögött áll.',
                                      maxLines: 5,
                                      style: TextStyle(
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
                                  const Expanded(
                                    child: Text(
                                      'Az "Apple" az Apple Inc. védjegye.',
                                      maxLines: 5,
                                      style: TextStyle(
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
                                  const Expanded(
                                    child: Text(
                                      'Az árak jelképes összegek és csak körülbelül egyeznek a valós, Github-on látható, USA-dollárban feltűntetett árakkal.',
                                      maxLines: 5,
                                      style: TextStyle(
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
