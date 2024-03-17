import 'package:refilc/icons/filc_icons.dart';
import 'package:refilc_mobile_ui/premium/plus_screen.dart';
import 'package:refilc_plus/models/premium_scopes.dart';
import 'package:refilc_plus/providers/premium_provider.dart';
import 'package:refilc_plus/ui/mobile/premium/upsell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ActiveSponsorCard extends StatelessWidget {
  const ActiveSponsorCard({super.key});

  static PremiumFeatureLevel? estimateLevel(List<String> scopes) {
    if (scopes.contains(PremiumScopes.all) ||
        scopes.contains(PremiumScopes.tierSponge)) {
      return PremiumFeatureLevel.sponge;
    }
    if (scopes.contains(PremiumScopes.tierInk)) {
      return PremiumFeatureLevel.ink;
    }
    if (scopes.contains(PremiumScopes.tierCap)) {
      return PremiumFeatureLevel.cap;
    }
    return PremiumFeatureLevel.old;
  }

  IconData? _levelIcon(PremiumFeatureLevel level) {
    switch (level) {
      case PremiumFeatureLevel.cap:
        return FilcIcons.kupak;
      case PremiumFeatureLevel.ink:
        return FilcIcons.tinta;
      case PremiumFeatureLevel.sponge:
        return FilcIcons.kupak;
      case PremiumFeatureLevel.old:
        return FilcIcons.kupak;
      case PremiumFeatureLevel.basic:
        return FilcIcons.kupak;

      case PremiumFeatureLevel.gold:
        return FilcIcons.kupak;
    }
  }

  @override
  Widget build(BuildContext context) {
    final premium = Provider.of<PremiumProvider>(context, listen: false);
    final level = estimateLevel(premium.scopes);

    if (level == null) {
      return const SizedBox();
    }

    Color? glow = Colors.white; //TODO: only temp fix kima (idk what but die)

    switch (level) {
      case PremiumFeatureLevel.cap:
        glow = Colors.lightGreen;
        break;
      case PremiumFeatureLevel.ink:
        glow = Colors.purple;
        break;
      case PremiumFeatureLevel.sponge:
        glow = Colors.red;
        break;
      case PremiumFeatureLevel.old:
        glow = Colors.red;
        break;
      case PremiumFeatureLevel.basic:
        glow = Colors.red;
        break;
      case PremiumFeatureLevel.gold:
        glow = Colors.red;
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        child: InkWell(
          borderRadius: BorderRadius.circular(14.0),
          splashColor: glow.withOpacity(.2),
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
              return const PlusScreen();
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
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        backgroundImage: NetworkImage(
                            "https://github.com/${premium.login}.png?size=128"),
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
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white),
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
