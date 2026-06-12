import 'package:flutter/material.dart';
import '../models/territory.dart';

/// Static definition of the world map graph: nodes and edges.
class WorldGraph {
  WorldGraph._();

  /// Creates a fresh set of territory nodes in their starting state.
  static Map<String, TerritoryNode> createNodes() => {
        'New York': TerritoryNode('New York', const Offset(0.16, 0.32), Owner.player, 0),
        'Rio': TerritoryNode('Rio', const Offset(0.27, 0.72), Owner.neutral, 12),
        'London': TerritoryNode('London', const Offset(0.44, 0.20), Owner.neutral, 14),
        'Paris': TerritoryNode('Paris', const Offset(0.47, 0.34), Owner.neutral, 14),
        'Berlin': TerritoryNode('Berlin', const Offset(0.55, 0.22), Owner.neutral, 16),
        'Cairo': TerritoryNode('Cairo', const Offset(0.56, 0.50), Owner.neutral, 14),
        'Cape Town': TerritoryNode('Cape Town', const Offset(0.55, 0.82), Owner.neutral, 12),
        'Moscow': TerritoryNode('Moscow', const Offset(0.66, 0.14), Owner.enemy, 22),
        'Delhi': TerritoryNode('Delhi', const Offset(0.71, 0.44), Owner.neutral, 16),
        'Beijing': TerritoryNode('Beijing', const Offset(0.81, 0.28), Owner.neutral, 18),
        'Tokyo': TerritoryNode('Tokyo', const Offset(0.91, 0.34), Owner.enemy, 22),
        'Sydney': TerritoryNode('Sydney', const Offset(0.88, 0.78), Owner.neutral, 12),
      };

  /// Adjacency list: the connected web of supply routes.
  static const List<List<String>> edges = [
    ['New York', 'London'],
    ['New York', 'Rio'],
    ['New York', 'Paris'],
    ['Rio', 'Cape Town'],
    ['London', 'Paris'],
    ['London', 'Berlin'],
    ['Paris', 'Berlin'],
    ['Paris', 'Cairo'],
    ['Berlin', 'Moscow'],
    ['Cairo', 'Cape Town'],
    ['Cairo', 'Delhi'],
    ['Moscow', 'Delhi'],
    ['Moscow', 'Beijing'],
    ['Delhi', 'Beijing'],
    ['Beijing', 'Tokyo'],
    ['Tokyo', 'Sydney'],
    ['Delhi', 'Sydney'],
  ];

  static Set<String> neighborsOf(String name) {
    final result = <String>{};
    for (final e in edges) {
      if (e[0] == name) result.add(e[1]);
      if (e[1] == name) result.add(e[0]);
    }
    return result;
  }
}
