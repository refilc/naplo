import 'package:refilc/theme/colors/colors.dart';
// import 'package:refilc_plus/models/premium_scopes.dart';
// import 'package:refilc_plus/providers/premium_provider.dart';
// import 'package:refilc_plus/ui/mobile/plus/upsell.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:refilc_mobile_ui/pages/grades/grades_page.i18n.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:provider/provider.dart';

final Map<int, String> avgDropItems = {
  0: "annual_average",
  90: "3_months_average",
  30: "30_days_average",
  14: "14_days_average",
  7: "7_days_average",
};

class AverageSelector extends StatefulWidget {
  const AverageSelector({super.key, this.onChanged, required this.value});

  final Function(int?)? onChanged;
  final int value;

  @override
  AverageSelectorState createState() => AverageSelectorState();
}

class AverageSelectorState extends State<AverageSelector> {
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
        // if (Provider.of<PremiumProvider>(context, listen: false)
        //     .hasScope(PremiumScopes.gradeStats)) {
        if (widget.onChanged != null) {
          setState(() {
            widget.onChanged!(value);
          });
        }
        // } else {
        //   PlusLockedFeaturePopup.show(
        //       context: context, feature: PremiumFeature.gradestats);
        // }
      },
      value: widget.value,
      iconStyleData: IconStyleData(
        iconSize: 14,
        iconEnabledColor: AppColors.of(context).text,
        iconDisabledColor: AppColors.of(context).text,
      ),
      underline: const SizedBox(),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
        padding: EdgeInsets.only(left: 14, right: 14),
      ),
      buttonStyleData: ButtonStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        width: 200,
        padding: null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 8,
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: MaterialStateProperty.all<double>(6.0),
          trackVisibility: MaterialStateProperty.all<bool>(true),
          thumbVisibility: MaterialStateProperty.all<bool>(true),
        ),
        offset: const Offset(-10, -10),
      ),
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
