import 'package:flutter/services.dart' show rootBundle;

/// Word validation backed by a bundled word-list asset.
class DictionaryService {
  final Set<String> _words;

  DictionaryService(this._words);

  static Future<DictionaryService> load() async {
    final raw = await rootBundle.loadString('assets/data/dictionary.txt');
    final words = raw
        .split('\n')
        .map((w) => w.trim().toLowerCase())
        .where((w) => w.isNotEmpty)
        .toSet();
    return DictionaryService(words);
  }

  bool isValid(String word) => _words.contains(word);
}
