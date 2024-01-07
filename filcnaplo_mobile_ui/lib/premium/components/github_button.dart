import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:refilc_plus/providers/premium_provider.dart';
import 'package:refilc_plus/ui/mobile/premium/activation_view/activation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class GithubLoginButton extends StatelessWidget {
  const GithubLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final premium = Provider.of<PremiumProvider>(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: const Color(0xFFC1CBDF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.0),
        onTap: () {
          if (premium.hasPremium) {
            premium.auth.refreshAuth(removePremium: true);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "reFilc+ támogatás deaktiválva!",
                style: TextStyle(
                    color: AppColors.of(context).text,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ));
            return;
          }

          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const PremiumActivationView();
          }));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    "assets/images/btn_github.svg",
                    height: 28.0,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Transform.translate(
                        offset: const Offset(3.5, 4.6),
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFC1CBDF),
                            // color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const SizedBox(
                            height: 10.0,
                            width: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Transform.translate(
                        offset: const Offset(2.0, 2.0),
                        child: Icon(
                          premium.hasPremium
                              ? FeatherIcons.minusCircle
                              : FeatherIcons.plusCircle,
                          color: const Color(0xFF243F76),
                          size: 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 18.0,
              ),
              Text(
                premium.hasPremium
                    ? "Github szétkapcsolása"
                    : "Fiók összekötése Github-al",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color(0xFF243F76),
                ),
              ),
              const SizedBox(
                width: 4.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
