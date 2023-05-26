import 'package:filcnaplo_kreta_api/models/school.dart';
import 'package:flutter/material.dart';

class SchoolInputTile extends StatelessWidget {
  const SchoolInputTile({Key? key, required this.school, this.onTap}) : super(key: key);

  final School school;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onPanDown: (e) {
          onTap!();
        },
        child: InkWell(
          onTapDown: (e) {},
          borderRadius: BorderRadius.circular(6.0),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // School name
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    school.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Row(
                  children: [
                    // School id
                    Expanded(
                      child: Text(
                        school.instituteCode,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // School city
                    Expanded(
                      child: Text(
                        school.city,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
