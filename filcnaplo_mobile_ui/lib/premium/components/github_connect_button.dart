import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:filcnaplo_premium/ui/mobile/premium/activation_view/activation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class GithubConnectButton extends StatelessWidget {
  const GithubConnectButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final premium = Provider.of<PremiumProvider>(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: const Color(0xff2B2B2B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.0),
        onTap: () {
          if (premium.hasPremium) {
            premium.auth.refreshAuth(removePremium: true);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Prémium deaktiválva.",
                style: TextStyle(color: AppColors.of(context).text, fontWeight: FontWeight.bold, fontSize: 18.0),
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
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      "assets/images/github.svg",
                      height: 32.0,
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
                        child: Transform.translate(
                          offset: const Offset(2.0, 2.0),
                          child: Icon(
                            premium.hasPremium ? FeatherIcons.minusCircle : FeatherIcons.plusCircle,
                            color: Colors.white,
                            size: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                premium.hasPremium ? "GitHub szétkapcsolása" : "GitHub csatlakoztatása",
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
