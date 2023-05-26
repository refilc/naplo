import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:filcnaplo/models/supporter.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_mobile_ui/premium/components/supporter_group_card.dart';
import 'package:filcnaplo_mobile_ui/premium/styles/gradients.dart';
import 'package:flutter/material.dart';

class SupportersScreen extends StatelessWidget {
  const SupportersScreen({Key? key, required this.supporters}) : super(key: key);

  final Future<Supporters?> supporters;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Supporters?>(
        future: supporters,
        builder: (context, snapshot) {
          final highlightedSupporters =
              snapshot.data?.github.where((e) => e.type == DonationType.monthly && e.price >= 5 && e.comment != "").toList() ?? [];
          final tintaSupporters =
              snapshot.data?.github.where((e) => e.type == DonationType.monthly && e.price >= 5 && e.comment == "").toList() ?? [];
          final kupakSupporters = snapshot.data?.github.where((e) => e.type == DonationType.monthly && e.price == 2).toList() ?? [];
          final onetimeSupporters = snapshot.data?.github.where((e) => e.type == DonationType.once && e.price >= 5).toList() ?? [];
          final patreonSupporters = snapshot.data?.patreon ?? [];

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  title: const Text(
                    "Támogatók",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                if (snapshot.hasData)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).add(const EdgeInsets.only(bottom: 24.0)),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        snapshot.data!.description,
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0, color: AppColors.of(context).text.withOpacity(.7)),
                      ),
                    ),
                  ),
                if (!snapshot.hasData)
                  const SliverPadding(
                    padding: EdgeInsets.all(12.0),
                    sliver: SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (highlightedSupporters.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(12.0),
                    sliver: SliverToBoxAdapter(
                      child: SupporterGroupCard(
                        title: const Text("Kiemelt támogatók"),
                        expanded: true,
                        supporters: highlightedSupporters,
                      ),
                    ),
                  ),
                if (tintaSupporters.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(12.0),
                    sliver: SliverToBoxAdapter(
                      child: SupporterGroupCard(
                        icon: const Icon(FilcIcons.tinta),
                        title: Text(
                          "Tinta",
                          style: TextStyle(
                            foreground: GradientStyles.tintaPaint,
                          ),
                        ),
                        glow: Colors.purple,
                        supporters: tintaSupporters,
                      ),
                    ),
                  ),
                if (kupakSupporters.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(12.0),
                    sliver: SliverToBoxAdapter(
                      child: SupporterGroupCard(
                        icon: const Icon(FilcIcons.kupak),
                        title: Text(
                          "Kupak",
                          style: TextStyle(foreground: GradientStyles.kupakPaint),
                        ),
                        glow: Colors.lightGreen,
                        supporters: kupakSupporters,
                      ),
                    ),
                  ),
                if (onetimeSupporters.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(12.0),
                    sliver: SliverToBoxAdapter(
                      child: SupporterGroupCard(
                        title: const Text("Egyszeri támogatók"),
                        supporters: onetimeSupporters,
                      ),
                    ),
                  ),
                if (patreonSupporters.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.all(12.0),
                    sliver: SliverToBoxAdapter(
                      child: SupporterGroupCard(
                        title: const Text("Régebbi támogatóink"),
                        supporters: patreonSupporters,
                      ),
                    ),
                  ),
              ],
            ),
          );
        });
  }
}
