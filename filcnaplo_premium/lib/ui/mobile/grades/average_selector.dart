import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_premium/models/premium_scopes.dart';
import 'package:filcnaplo_premium/providers/premium_provider.dart';
import 'package:filcnaplo_premium/ui/mobile/premium/upsell.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/grades_page.i18n.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

final Map<int, String> avgDropItems = {
  0: "annual_average".i18n,
  90: "3_months_average".i18n,
  30: "30_days_average".i18n,
  14: "14_days_average".i18n,
  7: "7_days_average".i18n,
};

class PremiumAverageSelector extends StatelessWidget {
  const PremiumAverageSelector({Key? key, this.onChanged, required this.value}) : super(key: key);

  final Function(int?)? onChanged;
  final int value;

  @override
  Widget build(BuildContext context) {
    return DropdownButton2<int>(
      items: avgDropItems.keys
          .map((item) => DropdownMenuItem<int>(
                value: item,
                child: Text(
                  avgDropItems[item] ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.of(context).text,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      onChanged: (int? value) {
        if (Provider.of<PremiumProvider>(context, listen: false).hasScope(PremiumScopes.gradeStats)) {
          if (onChanged != null) onChanged!(value);
        } else {
          PremiumLockedFeatureUpsell.show(context: context, feature: PremiumFeature.gradestats);
        }
      },
      value: value,
      iconSize: 14,
      iconEnabledColor: AppColors.of(context).text,
      iconDisabledColor: AppColors.of(context).text,
      underline: const SizedBox(),
      itemHeight: 40,
      itemPadding: const EdgeInsets.only(left: 14, right: 14),
      dropdownWidth: 200,
      dropdownPadding: null,
      buttonDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
      ),
      dropdownElevation: 8,
      scrollbarRadius: const Radius.circular(40),
      scrollbarThickness: 6,
      scrollbarAlwaysShow: true,
      offset: const Offset(-10, -10),
      buttonSplashColor: Colors.transparent,
      customButton: SizedBox(
        height: 30,
        child: Row(
          children: [
            Text(avgDropItems[value] ?? "",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w600, color: AppColors.of(context).text.withOpacity(0.65))),
            const SizedBox(
              width: 4,
            ),
            Icon(
              FeatherIcons.chevronDown,
              size: 16,
              color: AppColors.of(context).text,
            ),
          ],
        ),
      ),
    );
  }
}
