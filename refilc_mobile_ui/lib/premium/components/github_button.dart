import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:refilc/api/client.dart';
// import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_plus/providers/premium_provider.dart';
import 'package:refilc_plus/ui/mobile/premium/activation_view/activation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

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
        onTap: () async {
          // if (premium.hasPremium) {
          //   premium.auth.refreshAuth(removePremium: true);
          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //     content: Text(
          //       "reFilc+ támogatás deaktiválva!",
          //       style: TextStyle(
          //           color: AppColors.of(context).text,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 18.0),
          //     ),
          //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          //   ));
          //   return;
          // }

          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const PremiumActivationView();
          }));
          // bool initFinished = await initPaymentSheet(context);
          // if (initFinished) {
          //   stripe.PaymentSheetPaymentOption? result =
          //       await stripe.Stripe.instance.presentPaymentSheet();

          //   print(result == null);

          //   print(result?.label ?? 'nem label');
          // }

          // launchUrl(
          //   Uri.parse(
          //       'https://api.refilc.hu/v3/payment/stripe-create-checkout?product=asdasd'),
          //   mode: LaunchMode.inAppBrowserView,
          // );
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

  Future<bool> initPaymentSheet(BuildContext context) async {
    try {
      // 1. create payment intent on the server
      final data = await _createPaymentSheet();

      if (data == null) {
        throw "API error, can't create payment sheet!";
      }

      // 2. initialize the payment sheet
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'reFilc',
          paymentIntentClientSecret: data['paymentIntent'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['customer'],
          // Extra options
          // applePay: const stripe.PaymentSheetApplePay(
          //   merchantCountryCode: 'HU',
          // ),
          googlePay: const stripe.PaymentSheetGooglePay(
            merchantCountryCode: 'HU',
            testEnv: true,
          ),
          style: ThemeMode.system,
        ),
      );
      return true;
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<Map?> _createPaymentSheet() async {
    Map? data = await FilcAPI.createPaymentSheet("refilcplus");
    return data;
  }
}
