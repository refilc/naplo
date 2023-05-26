import 'package:animations/animations.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:filcnaplo_premium/ui/mobile/premium/activation_view/activation_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PremiumActivationView extends StatefulWidget {
  const PremiumActivationView({super.key});

  @override
  State<PremiumActivationView> createState() => _PremiumActivationViewState();
}

class _PremiumActivationViewState extends State<PremiumActivationView> with SingleTickerProviderStateMixin {
  late AnimationController animation;
  bool activated = false;

  @override
  void initState() {
    super.initState();
    context.read<PremiumProvider>().auth.initAuth();

    animation = AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final premium = context.watch<PremiumProvider>();

    if (premium.hasPremium && !activated) {
      activated = true;
      animation.forward();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future.delayed(const Duration(seconds: 2)).then((value) {
          if (mounted) Navigator.of(context).pop();
        });
      });
    }

    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) => SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          fillColor: Colors.transparent,
          child: child,
        ),
        child: premium.hasPremium
            ? Center(
                child: SizedBox(
                  width: 400,
                  child: Lottie.network("https://assets2.lottiefiles.com/packages/lf20_wkebwzpz.json", controller: animation),
                ),
              )
            : const SafeArea(child: ActivationDashboard()),
      ),
    );
  }
}
