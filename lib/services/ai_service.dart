import 'dart:math';
import '../data/world_graph.dart';
import '../models/territory.dart';

/// Simple client-side enemy AI.
/// NOTE: Phase 5 expands this into multiple clans with aggression heuristics.
class AiService {
  final Random rng;

  AiService(this.rng);

  /// Runs one enemy turn. Returns a war-log message if the AI acted.
  String? takeTurn(Map<String, TerritoryNode> nodes) {
    if (rng.nextDouble() > 0.6) return null; // 60% chance to act
    final targets = <TerritoryNode>[];
    for (final n in nodes.values.where((n) => n.owner == Owner.enemy)) {
      for (final m in WorldGraph.neighborsOf(n.name)) {
        final t = nodes[m]!;
        if (t.owner == Owner.neutral) targets.add(t);
        if (t.owner == Owner.player && rng.nextDouble() < 0.35) targets.add(t);
      }
    }
    if (targets.isEmpty) return null;
    final captured = targets[rng.nextInt(targets.length)];
    captured.owner = Owner.enemy;
    captured.defense = 20;
    return 'ENEMY captured ${captured.name}!';
  }
}
