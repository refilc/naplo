import 'package:filcnaplo/api/client.dart';
import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:filcnaplo/models/supporter.dart';
import 'package:filcnaplo_mobile_ui/premium/components/active_sponsor_card.dart';
import 'package:filcnaplo_mobile_ui/premium/components/github_card.dart';
import 'package:filcnaplo_mobile_ui/premium/components/github_connect_button.dart';
import 'package:filcnaplo_mobile_ui/premium/components/goal_card.dart';
import 'package:filcnaplo_mobile_ui/premium/components/plan_card.dart';
import 'package:filcnaplo_mobile_ui/premium/components/reward_card.dart';
import 'package:filcnaplo_mobile_ui/premium/components/supporters_button.dart';
import 'package:filcnaplo_mobile_ui/premium/styles/gradients.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:filcnaplo_premium/ui/mobile/premium/activation_view/activation_view.dart';
import 'package:filcnaplo_premium/ui/mobile/premium/upsell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final middleColor =
        Theme.of(context).brightness == Brightness.dark ? const Color.fromARGB(255, 20, 57, 46) : const Color.fromARGB(255, 10, 140, 123);

    final future = FilcAPI.getSupporters();

    return FutureBuilder<Supporters?>(
        future: future,
        builder: (context, snapshot) {
          return Scaffold(
            body: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xff124F3D),
                          middleColor,
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            middleColor,
                            Theme.of(context).scaffoldBackgroundColor,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 64.0),
                                  Image.asset("assets/images/logo.png"),
                                  const SizedBox(height: 12.0),
                                  const Text(
                                    "Még több filc.",
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25.0, color: Colors.white),
                                  ),
                                  const Text(
                                    "Filc Premium.",
                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 35.0, color: Colors.white),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Text(
                                    "Támogasd a filcet, és szerezz cserébe pár kényelmes jutalmat!",
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white.withOpacity(.8)),
                                  ),
                                  const SizedBox(height: 25.0),
                                  SupportersButton(supporters: future),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0).add(const EdgeInsets.only(bottom: 100)),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        PremiumPlanCard(
                          icon: const Icon(FilcIcons.kupak),
                          title: Text("Kupak", style: TextStyle(foreground: GradientStyles.kupakPaint)),
                          gradient: GradientStyles.kupak,
                          price: 2,
                          description: const Text("Szabd személyre a filcet és láss részletesebb statisztikákat."),
                          url: "https://github.com/sponsors/filc/sponsorships?tier_id=238453&preview=true",
                          active: ActiveSponsorCard.estimateLevel(context.watch<PremiumProvider>().scopes) == PremiumFeatureLevel.kupak,
                        ),
                        const SizedBox(height: 8.0),
                        PremiumPlanCard(
                          icon: const Icon(FilcIcons.tinta),
                          title: Text("Tinta", style: TextStyle(foreground: GradientStyles.tintaPaint)),
                          gradient: GradientStyles.tinta,
                          price: 5,
                          description: const Text("Kényelmesebb órarend, asztali alkalmazás és célok kitűzése."),
                          url: "https://github.com/sponsors/filc/sponsorships?tier_id=238454&preview=true",
                          active: ActiveSponsorCard.estimateLevel(context.watch<PremiumProvider>().scopes) == PremiumFeatureLevel.tinta,
                        ),
                        const SizedBox(height: 12.0),
                        PremiumGoalCard(progress: snapshot.data?.progress ?? 0, target: snapshot.data?.max ?? 1),
                        const SizedBox(height: 12.0),
                        const GithubConnectButton(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0).add(const EdgeInsets.only(top: 12.0)),
                          child: Row(
                            children: const [
                              Icon(FilcIcons.kupak),
                              SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  "Kupak jutalmak",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PremiumRewardCard(
                          imageKey: "premium_nickname_showcase",
                          icon: SvgPicture.asset("assets/images/nickname_icon.svg", color: Theme.of(context).iconTheme.color),
                          title: const Text("Profil személyre szabás"),
                          description: const Text("Állíts be egy saját becenevet és egy profilképet (akár animáltat is!)"),
                        ),
                        const SizedBox(height: 14.0),
                        PremiumRewardCard(
                          imageKey: "premium_theme_showcase",
                          icon: SvgPicture.asset("assets/images/theme_icon.svg", color: Theme.of(context).iconTheme.color),
                          title: const Text("Téma+"),
                          description: const Text("Válassz saját háttérszínt és kártyaszínt is, akár saját HEX-kóddal!"),
                        ),
                        const SizedBox(height: 14.0),
                        PremiumRewardCard(
                          imageKey: "premium_stats_showcase",
                          icon: SvgPicture.asset("assets/images/stats_icon.svg", color: Theme.of(context).iconTheme.color),
                          title: const Text("Részletes jegy statisztika"),
                          description: const Text("Válassz heti, havi és háromhavi időtartam közül, és pontosan lásd, mennyi jegyed van."),
                        ),
                        const SizedBox(height: 14.0),
                        const PremiumRewardCard(
                          title: Text("Még pár dolog..."),
                          description:
                              Text("🔣\tVálassz ikon témát\n✨\tPrémium rang és csevegő a discord szerverünkön\n📬\tElsőbbségi segítségnyújtás"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0).add(const EdgeInsets.only(top: 12.0)),
                          child: Row(
                            children: const [
                              Icon(FilcIcons.tinta),
                              SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  "Tinta jutalmak",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PremiumRewardCard(
                          imageKey: "premium_timetable_showcase",
                          icon: SvgPicture.asset("assets/images/timetable_icon.svg", color: Theme.of(context).iconTheme.color),
                          title: const Text("Heti órarend nézet"),
                          description:
                              const Text("Egy órarend, ami a teljes képernyődet kihasználja, csak nem olyan idegesítő, mint az eKRÉTA féle."),
                        ),
                        const SizedBox(height: 14.0),
                        PremiumRewardCard(
                          imageKey: "premium_widget_showcase",
                          icon: SvgPicture.asset("assets/images/widget_icon.svg", color: Theme.of(context).iconTheme.color),
                          title: const Text("Widget"),
                          description: const Text("Mindig lásd, milyen órád lesz, a kezdőképernyőd kényelméből."),
                        ),
                        const SizedBox(height: 14.0),
                        PremiumRewardCard(
                          soon: true,
                          imageKey: "premium_goal_showcase",
                          icon: SvgPicture.asset("assets/images/goal_icon.svg", color: Theme.of(context).iconTheme.color),
                          title: const Text("Cél követés"),
                          description: const Text("Add meg, mi a célod, és mi majd kiszámoljuk, hogyan juthatsz oda!"),
                        ),
                        const SizedBox(height: 14.0),
                        PremiumRewardCard(
                          soon: true,
                          imageKey: "premium_desktop_showcase",
                          icon: SvgPicture.asset("assets/images/desktop_icon.svg", color: Theme.of(context).iconTheme.color),
                          title: const Text("Asztali verzió"),
                          description: const Text("Érd el a Filc Napló-t a gépeden is, és menekülj meg a csúnya felhasználói felületektől!"),
                        ),
                        const SizedBox(height: 14.0),
                        const PremiumRewardCard(
                          title: Text("Még pár dolog..."),
                          description: Text("🖋️\tMinden kupak jutalom\n✨\tKorai hozzáférés új verziókhoz"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0).add(const EdgeInsets.only(top: 12.0)),
                          child: Row(
                            children: const [
                              SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  "Mire vársz még?",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GithubCard(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return const PremiumActivationView();
                            }));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0).add(const EdgeInsets.only(top: 12.0)),
                          child: Row(
                            children: const [
                              SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  "Gyakori kérdések",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PremiumRewardCard(
                          title: Text("Mire költitek a pénzt?"),
                          description: Text(
                              "A pénz elsősorban az appstore évi \$100-os díját fedezi, a maradék a szerver a weboldal és új funkciók fejlesztésére fordítjuk."),
                        ),
                        const SizedBox(height: 14.0),
                        const PremiumRewardCard(
                          title: Text("Még mindig nyílt a forráskód?"),
                          description: Text(
                              "Igen, a Filc napló teljesen nyílt forráskódú, és ez így is fog maradni. A prémium funkciók forráskódjához hozzáférnek a támogatók."),
                        ),
                        const SizedBox(height: 14.0),
                        const PremiumRewardCard(
                          title: Text("Hol tudok támogatni?"),
                          description: Text(
                              "A támogatáshoz szükséged van egy Github profilra, amit hozzá kell kötnöd a filc naplóhoz. A Github “Sponsors” funkciója segítségével kezeljük az támogatásod."),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
