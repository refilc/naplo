import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart';

Future<String> dirtyString() async {
  final file = await rootBundle.loadString('assets/other/dirtywords.xml');
  final document = XmlDocument.parse(file);

  // Extract words and their types
  final words = document.findAllElements('Word').map((element) {
    return {
      'word': element.innerText.trim(),
      'type': element.getAttribute('type')!,
    };
  }).toList();

  // Separate words by type
  final mWords = words.where((word) => word['type'] == 'm').toList();
  final fWords = words.where((word) => word['type'] == 'f').toList();

  // Shuffle words to randomize selection
  mWords.shuffle();
  fWords.shuffle();

  // Generate randomized string with alternating types
  String randomizedString = '';
  // final minWordsLength = min(mWords.length, fWords.length);
  var mNumber = Random().nextInt(193);
  var secondMnumber = Random().nextInt(193); //Amount of occurences of the types
  var fNumber = Random().nextInt(169);
  randomizedString =
      '${mWords[mNumber]['word']}, ${mWords[secondMnumber]['word']!.toLowerCase()} ${fWords[fNumber]['word']!.toLowerCase()}!';

  return randomizedString;
}
