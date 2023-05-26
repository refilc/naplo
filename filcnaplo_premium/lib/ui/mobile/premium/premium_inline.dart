import 'package:filcnaplo_premium/ui/mobile/premium/upsell.dart';
import 'package:flutter/material.dart';

enum PremiumInlineFeature { nickname, theme, widget, goal, stats }

const Map<PremiumInlineFeature, String> _featureAssets = {
  PremiumInlineFeature.nickname: "assets/images/premium_nickname_inline_showcase.png",
  PremiumInlineFeature.theme: "assets/images/premium_theme_inline_showcase.png",
  PremiumInlineFeature.widget: "assets/images/premium_widget_inline_showcase.png",
  PremiumInlineFeature.goal: "assets/images/premium_goal_inline_showcase.png",
  PremiumInlineFeature.stats: "assets/images/premium_stats_inline_showcase.png",
};

const Map<PremiumInlineFeature, PremiumFeature> _featuresInline = {
  PremiumInlineFeature.nickname: PremiumFeature.profile,
  PremiumInlineFeature.theme: PremiumFeature.customcolors,
  PremiumInlineFeature.widget: PremiumFeature.widget,
  PremiumInlineFeature.goal: PremiumFeature.goalplanner,
  PremiumInlineFeature.stats: PremiumFeature.gradestats,
};

class PremiumInline extends StatelessWidget {
  const PremiumInline({super.key, required this.features});

  final List<PremiumInlineFeature> features;

  String _getAsset() {
    for (int i = 0; i < features.length; i++) {
      if (DateTime.now().day % features.length == i) {
        return _featureAssets[features[i]]!;
      }
    }

    return _featureAssets[features[0]]!;
  }

  PremiumFeature _getFeature() {
    for (int i = 0; i < features.length; i++) {
      if (DateTime.now().day % features.length == i) {
        return _featuresInline[features[i]]!;
      }
    }

    return _featuresInline[features[0]]!;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(_getAsset()),
        Positioned.fill(
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: () {
                PremiumLockedFeatureUpsell.show(context: context, feature: _getFeature());
              },
            ),
          ),
        ),
      ],
    );
  }
}
