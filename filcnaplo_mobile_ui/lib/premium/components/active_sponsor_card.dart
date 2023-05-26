import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:filcnaplo_mobile_ui/premium/premium_screen.dart';
import 'package:filcnaplo_premium/models/premium_scopes.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:filcnaplo_premium/ui/mobile/premium/upsell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ActiveSponsorCard extends StatelessWidget {
  const ActiveSponsorCard({super.key});

  static PremiumFeatureLevel? estimateLevel(List<String> scopes) {
    if (scopes.contains(PremiumScopes.all)) {
      return PremiumFeatureLevel.tinta;
    }
    if (scopes.contains(PremiumScopes.timetableWidget) || scopes.contains(PremiumScopes.goalPlanner)) {
      return PremiumFeatureLevel.tinta;
    }
    if (scopes.contains(PremiumScopes.customColors) || scopes.contains(PremiumScopes.nickname)) {
      return PremiumFeatureLevel.kupak;
    }
    return null;
  }

  IconData _levelIcon(PremiumFeatureLevel level) {
    switch (level) {
      case PremiumFeatureLevel.kupak:
        return FilcIcons.kupak;
      case PremiumFeatureLevel.tinta:
        return FilcIcons.tinta;
    }
  }

  @override
  Widget build(BuildContext context) {
    final premium = Provider.of<PremiumProvider>(context, listen: false);
    final level = estimateLevel(premium.scopes);

    if (level == null) {
      return const SizedBox();
    }

    Color glow;

    switch (level) {
      case PremiumFeatureLevel.kupak:
        glow = Colors.lightGreen;
        break;
      case PremiumFeatureLevel.tinta:
        glow = Colors.purple;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: glow.withOpacity(.4),
            blurRadius: 42.0,
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: const Color(0xff2B2B2B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        child: InkWell(
          borderRadius: BorderRadius.circular(14.0),
          splashColor: glow.withOpacity(.2),
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) {
              return const PremiumScreen();
            }));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        backgroundImage: NetworkImage("https://github.com/${premium.login}.png?size=128"),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Transform.translate(
                            offset: const Offset(3.0, 4.0),
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: const BoxDecoration(
                                color: Color(0xff2B2B2B),
                                shape: BoxShape.circle,
                              ),
                              child: const SizedBox(
                                height: 14.0,
                                width: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: SvgPicture.asset(
                            "assets/images/github.svg",
                            height: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    premium.login,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    _levelIcon(level),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
