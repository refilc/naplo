import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo_mobile_ui/common/personality_card/personality_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalityBody extends StatefulWidget {
  const PersonalityBody({Key? key}) : super(key: key);

  @override
  _PersonalityBodyState createState() => _PersonalityBodyState();
}

class _PersonalityBodyState extends State<PersonalityBody> {
  late UserProvider user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 60),
          PersonalityCard(
            user: user,
          ),
          const SizedBox(height: 60),
        ]);
  }
}
