// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:refilc/models/user.dart';
import 'package:refilc_mobile_ui/common/bottom_card.dart';
import 'package:refilc_mobile_ui/common/detail.dart';
import 'package:refilc_mobile_ui/common/profile_image/profile_image.dart';
import 'package:refilc_mobile_ui/screens/settings/accounts/account_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'account_view.i18n.dart';

class AccountView extends StatelessWidget {
  const AccountView(this.user, {super.key});

  final User user;

  static void show(User user, {required BuildContext context}) =>
      showBottomCard(context: context, child: AccountView(user));

  @override
  Widget build(BuildContext context) {
    List<String> _nameParts = user.name.split(" ");
    String _firstName = _nameParts.length > 1 ? _nameParts[1] : _nameParts[0];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountTile(
            profileImage: ProfileImage(
              name: _firstName,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              role: user.role,
            ),
            name: SelectableText(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.w500),
              maxLines: 2,
              minLines: 1,
            ),
            username: SelectableText(user.username),
          ),

          // User details
          Detail(
              title: "birthdate".i18n,
              description:
                  DateFormat("yyyy. MM. dd.").format(user.student.birth)),
          Detail(title: "school".i18n, description: user.student.school.name),
          if (user.student.className != null)
            Detail(title: "class".i18n, description: user.student.className!),
          if (user.student.address != null)
            Detail(title: "address".i18n, description: user.student.address!),
          if (user.student.parents.isNotEmpty)
            Detail(
                title: "parents".plural(user.student.parents.length),
                description: user.student.parents.join(", ")),
          if (user.student.gradeDelay > 0)
            Detail(
              title: "grade_delay".i18n,
              description: "hrs".i18n.fill([user.student.gradeDelay]),
            ),
          // if ((user.student.bankAccount ?? "").isNotEmpty)
          //   Detail(
          //     title: "bank_account".i18n,
          //     description: (user.student.bankAccount ?? "not_provided".i18n),
          //   ),
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
