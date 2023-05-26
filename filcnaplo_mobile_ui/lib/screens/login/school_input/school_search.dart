import 'package:filcnaplo_kreta_api/models/school.dart';
import 'package:filcnaplo/utils/format.dart';

List<School> searchSchools(List<School> all, String pattern) {
  pattern = pattern.toLowerCase().specialChars();
  if (pattern == "") return all;

  List<School> results = [];

  for (var item in all) {
    int contains = 0;

    pattern.split(" ").forEach((variation) {
      if (item.name.toLowerCase().specialChars().contains(variation)) {
        contains++;
      }
    });

    if (contains == pattern.split(" ").length) results.add(item);
  }

  results.sort((a, b) => a.name.compareTo(b.name));

  return results;
}
