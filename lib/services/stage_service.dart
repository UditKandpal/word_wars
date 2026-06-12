import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/puzzle.dart';

/// Loads city stage campaigns from the bundled JSON asset.
class StageService {
  final Map<String, List<PuzzleStage>> _cityStages;

  StageService._(this._cityStages);

  static Future<StageService> load() async {
    final raw = await rootBundle.loadString('assets/data/stages.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final templates = <String, PuzzleStage>{};
    (json['templates'] as Map<String, dynamic>).forEach((id, value) {
      templates[id] = PuzzleStage.fromJson(value as Map<String, dynamic>);
    });
    final cityStages = <String, List<PuzzleStage>>{};
    (json['cities'] as Map<String, dynamic>).forEach((city, ids) {
      cityStages[city] =
          (ids as List).map((id) => templates[id as String]!).toList();
    });
    return StageService._(cityStages);
  }

  List<PuzzleStage> stagesFor(String city) => _cityStages[city] ?? const [];
}
