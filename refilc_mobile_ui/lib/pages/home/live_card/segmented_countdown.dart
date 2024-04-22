import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'live_card.i18n.dart';

class SegmentedCountdown extends StatefulWidget {
  const SegmentedCountdown({super.key, required this.date});

  final DateTime date;

  @override
  SegmentedCountdownState createState() => SegmentedCountdownState();
}

class SegmentedCountdownState extends State<SegmentedCountdown> {
  @override
  Widget build(BuildContext context) {
    Duration diffDate = widget.date.difference(DateTime.now());

    String diffHours = (diffDate.inHours % 24).toString();
    String diffMins = (diffDate.inMinutes % 60).toString();
    String diffSecs = (diffDate.inSeconds % 60).toString();

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          width: 20.0,
          alignment: Alignment.center,
          child: Text(
            diffHours,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          width: 7.0,
        ),
        Text(
          'h'.i18n,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: AppColors.of(context).text.withOpacity(0.6),
          ),
        ),
        const SizedBox(
          width: 7.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          width: 20.0,
          alignment: Alignment.center,
          child: Text(
            diffMins[0],
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (diffMins.length == 2)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            margin: const EdgeInsets.only(left: 4.0),
            width: 20.0,
            alignment: Alignment.center,
            child: Text(
              diffMins[1],
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        const SizedBox(
          width: 7.0,
        ),
        Text(
          'm'.i18n,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: AppColors.of(context).text.withOpacity(0.6),
          ),
        ),
        const SizedBox(
          width: 7.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          width: 20.0,
          alignment: Alignment.center,
          child: Text(
            diffSecs[0],
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (diffSecs.length == 2)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            margin: const EdgeInsets.only(left: 4.0),
            width: 20.0,
            alignment: Alignment.center,
            child: Text(
              diffSecs[1],
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        const SizedBox(
          width: 7.0,
        ),
        Text(
          's'.i18n,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: AppColors.of(context).text.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
