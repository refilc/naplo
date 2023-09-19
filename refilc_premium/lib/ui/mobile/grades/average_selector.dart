import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_premium/models/premium_scopes.dart';
import 'package:refilc_premium/providers/premium_provider.dart';
import 'package:refilc_premium/ui/mobile/premium/upsell.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:refilc_mobile_ui/pages/grades/grades_page.i18n.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

final Map<int, String> avgDropItems = {
  0: "annual_average",
  90: "3_months_average",
  30: "30_days_average",
  14: "14_days_average",
  7: "7_days_average",
};

class PremiumAverageSelector extends StatefulWidget {
  const PremiumAverageSelector({Key? key, this.onChanged, required this.value})
      : super(key: key);

  final Function(int?)? onChanged;
  final int value;

  @override
  _PremiumAverageSelectorState createState() => _PremiumAverageSelectorState();
}

class _PremiumAverageSelectorState extends State<PremiumAverageSelector> {
  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<int>> dropdownItems = avgDropItems.keys.map((item) {
      return DropdownMenuItem<int>(
        value: item,
        child: Text(
          avgDropItems[item]!.i18n,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.of(context).text,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();

    return DropdownButton2<int>(
      items: dropdownItems,
      onChanged: (int? value) {
        if (Provider.of<PremiumProvider>(context, listen: false)
            .hasScope(PremiumScopes.gradeStats)) {
          if (widget.onChanged != null) {
            setState(() {
              widget.onChanged!(value);
            });
          }
        } else {
          PremiumLockedFeatureUpsell.show(
              context: context, feature: PremiumFeature.gradestats);
        }
      },
      value: widget.value,
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
            Text(
              avgDropItems[widget.value]!.i18n,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.of(context).text.withOpacity(0.65)),
            ),
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
