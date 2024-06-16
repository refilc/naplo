import 'dart:math';

class Uwuifier {
  final Map<String, double> _spacesModifier;
  final double _wordsModifier;

  final List<String> faces = [
    "OwO",
    "UwU",
    ">w<",
    "^w^",
    "^-^",
    ":3",
  ];

  final List<List<String>> uwuMap = [
    ['(?:r|l)', 'w'],
    ['(?:R|L)', 'W'],
    ['na', 'nya'],
    ['ne', 'nye'],
    ['NA', 'NYA'],
    ['NE', 'NYE'],
    ['Na', 'Nya'],
    ['Ne', 'Nye'],
    ['no', 'nyo'],
    ['NO', 'NYO'],
    ['No', 'Nyo'],
    ['nO', 'NYo'],
    ['ove', 'uv'],
    ['no', 'nwo'], 
  ];

  final Map<String, String> _uwuCache = {};

  Uwuifier({
    Map<String, double>? spaces,
    double? words,
  })  : _spacesModifier = spaces ?? {
          'faces': 0.05,
          'actions': 0.0,
          'stutters': 0.1,
        },
        _wordsModifier = words ?? 1.0;

  String uwuifyWords(String sentence) {
    final words = sentence.split(' ');

    final uwuifiedSentence = words.map((word) {
      if (isAt(word) || isUri(word)) return word;

      var seed = Random().nextDouble();
      for (final uwuMapEntry in uwuMap) {
        final oldWord = RegExp(uwuMapEntry[0], caseSensitive: false);
        final newWord = uwuMapEntry[1];
        if (seed > _wordsModifier) continue;
        word = word.replaceAll(oldWord, newWord);
      }

      return word;
    }).join(' ');

    return uwuifiedSentence;
  }

  String uwuifySpaces(String sentence) {
    final words = sentence.split(' ');

    final faceThreshold = _spacesModifier['faces']!;
    final actionThreshold = _spacesModifier['actions']! + faceThreshold;
    final stutterThreshold = _spacesModifier['stutters']! + actionThreshold;

    final uwuifiedSentence = words.map((word) {
      final seed = Random().nextDouble();
      final firstCharacter = word[0];

      if (seed <= faceThreshold && faces.isNotEmpty) {
        word += ' ${faces[Random().nextInt(faces.length)]}';
      } else if (seed <= actionThreshold) {
        // Skip actions
      } else if (seed <= stutterThreshold && !isUri(word)) {
        if (Random().nextInt(10) == 0) {
          final stutter = Random().nextInt(3);
          return '${firstCharacter * (stutter + 1)}-$word';
        }
      }

      return word;
    }).join(' ');

    return uwuifiedSentence;
  }

  String uwuifySentence(String sentence) {
    if (_uwuCache.containsKey(sentence)) {
      return _uwuCache[sentence]!;
    }

    var uwuifiedSentence = uwuifyWords(sentence);
    uwuifiedSentence = uwuifySpaces(uwuifiedSentence);

    _uwuCache[sentence] = uwuifiedSentence;
    return uwuifiedSentence;
  }

  bool isAt(String value) {
    return value.startsWith('@');
  }

  bool isUri(String? value) {
    if (value == null) return false;
    final split = RegExp(
            r'''(?:([^:/?#]+):)?(?:\/\/([^/?#]*))?([^?#]*)(?:\?([^#]*))?(?:#(.*))?''')
        .firstMatch(value);
    if (split == null) return false;
    final scheme = split.group(1);
    final authority = split.group(2);
    final path = split.group(3);
    if (!(scheme?.isNotEmpty == true && path?.isNotEmpty == true)) return false;
    if (authority != null && authority.isNotEmpty) {
      if (!(path?.isEmpty == true || path!.startsWith('/'))) return false;
    } else if (path?.startsWith('//') == true) {
      return false;
    }
    if (!RegExp(r'''^[a-z][a-z0-9+\-\.]*$''', caseSensitive: false)
        .hasMatch(scheme!.toLowerCase())) {
      return false;
    }
    return true;
  }
}
