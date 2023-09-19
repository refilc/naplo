import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_premium/providers/premium_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ActivationDashboard extends StatefulWidget {
  const ActivationDashboard({super.key});

  @override
  State<ActivationDashboard> createState() => _ActivationDashboardState();
}

class _ActivationDashboardState extends State<ActivationDashboard> {
  bool manualActivationLoading = false;

  Future<void> onManualActivation() async {
    final data = await Clipboard.getData("text/plain");
    if (data == null || data.text == null || data.text == "") {
      return;
    }
    setState(() {
      manualActivationLoading = true;
    });
    final result =
        await context.read<PremiumProvider>().auth.finishAuth(data.text!);
    setState(() {
      manualActivationLoading = false;
    });

    if (!result && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Sikertelen aktiválás. Kérlek próbáld újra később!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Center(
            child: SvgPicture.asset(
              "assets/images/github.svg",
              height: 64.0,
            ),
          ),
          const SizedBox(height: 32.0),
          const Text(
            "Jelentkezz be a GitHub felületén és adj hozzáférést a Filcnek, hogy aktiváld a Premiumot.",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
          ),
          const SizedBox(height: 12.0),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(FeatherIcons.alertTriangle,
                          size: 20.0, color: Colors.orange),
                      SizedBox(width: 12.0),
                      Text(
                        "Figyelem!",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    "Csak akkor érzékeli a Filc a támogatói státuszod, ha nem állítod privátra!",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(FeatherIcons.alertTriangle,
                          size: 20.0, color: Colors.orange),
                      SizedBox(width: 12.0),
                      Text(
                        "Figyelem!",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    "Ha friss támogató vagy, 5-10 percbe telhet az aktiválás. Kérlek gyere vissza később, és próbáld újra!",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ha bejelentkezés után nem lép vissza az alkalmazásba automatikusan, aktiváld a támogatásod manuálisan",
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6.0),
                  Center(
                    child: TextButton.icon(
                      onPressed: onManualActivation,
                      style: ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.secondary),
                        overlayColor: MaterialStatePropertyAll(Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(.1)),
                      ),
                      icon: manualActivationLoading
                          ? const SizedBox(
                              child: CircularProgressIndicator(),
                              height: 16.0,
                              width: 16.0,
                            )
                          : const Icon(FeatherIcons.key, size: 20.0),
                      label: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Aktiválás tokennel",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStatePropertyAll(AppColors.of(context).text),
                  overlayColor: MaterialStatePropertyAll(
                      AppColors.of(context).text.withOpacity(.1)),
                ),
                icon: const Icon(FeatherIcons.arrowLeft, size: 20.0),
                label: const Text(
                  "Vissza",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
