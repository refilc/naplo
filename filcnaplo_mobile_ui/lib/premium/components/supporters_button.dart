import 'dart:math';

import 'package:filcnaplo/models/supporter.dart';
import 'package:filcnaplo_mobile_ui/premium/components/avatar_stack.dart';
import 'package:filcnaplo_mobile_ui/premium/supporters_screen.dart';
import 'package:flutter/material.dart';

class SupportersButton extends StatelessWidget {
  const SupportersButton({Key? key, required this.supporters}) : super(key: key);

  final Future<Supporters?> supporters;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const StadiumBorder(),
      margin: EdgeInsets.zero,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => SupportersScreen(supporters: supporters)),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  "Köszönjük, támogatók!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
              ),
              FutureBuilder<Supporters?>(
                  future: supporters,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }
                    final sponsors = snapshot.data!.github.where((e) => e.type == DonationType.monthly).toList();
                    sponsors.shuffle(Random((DateTime.now().millisecondsSinceEpoch / 1000 / 60 / 60 / 24).floor()));
                    return AvatarStack(
                      children: [
                        // ignore: prefer_is_empty
                        if (sponsors.length > 0 && sponsors[0].avatar != "")
                          CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            backgroundImage: NetworkImage(sponsors[0].avatar),
                          ),
                        if (sponsors.length > 1 && sponsors[1].avatar != "")
                          CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            backgroundImage: NetworkImage(sponsors[1].avatar),
                          ),
                        if (sponsors.length > 2 && sponsors[2].avatar != "")
                          CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            backgroundImage: NetworkImage(sponsors[2].avatar),
                          ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
