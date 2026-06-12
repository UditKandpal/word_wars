import 'dart:math';
import 'package:flutter/foundation.dart';
import '../data/world_graph.dart';
import '../models/territory.dart';
import '../services/ai_service.dart';
import '../services/dictionary_service.dart';

/// Central game state, exposed to the UI via Provider.
class GameState extends ChangeNotifier {
  final DictionaryService dictionary;
  final Random _rng = Random();
  late final AiService _ai = AiService(_rng);

  GameState(this.dictionary);

  Map<String, TerritoryNode> nodes = WorldGraph.createNodes();
  int playerScore = 0;
  String warLog = 'Select a highlighted territory to attack.';
  String? gameOverTitle;

  bool isAttackable(TerritoryNode n) {
    if (n.owner == Owner.player) return false;
    return WorldGraph.neighborsOf(n.name)
        .any((m) => nodes[m]!.owner == Owner.player);
  }

  bool isDictionaryWord(String word) => dictionary.isValid(word);

  void addScore(int points) {
    playerScore += points;
    notifyListeners();
  }

  /// Called when the player clears all puzzle stages of a city.
  void conquerCity(String name) {
    final node = nodes[name];
    if (node == null) return;
    node.owner = Owner.player;
    node.defense = 10;
    playerScore += 100;
    warLog = '$name CONQUERED! +100 points.';
    _runEnemyTurn();
    _checkEndGame();
    notifyListeners();
  }

  /// Called when the player retreats from or abandons a siege.
  void abandonSiege(String name) {
    warLog = 'Siege of $name abandoned. The enemy advances...';
    _runEnemyTurn();
    _checkEndGame();
    notifyListeners();
  }

  void _runEnemyTurn() {
    final msg = _ai.takeTurn(nodes);
    if (msg != null) warLog += '\n$msg';
  }

  void _checkEndGame() {
    final playerCount =
        nodes.values.where((n) => n.owner == Owner.player).length;
    final enemyCount = nodes.values.where((n) => n.owner == Owner.enemy).length;
    if (playerCount == nodes.length) {
      gameOverTitle = 'WORLD CONQUERED!';
    } else if (playerCount == 0 || enemyCount == nodes.length) {
      gameOverTitle = 'DEFEAT. The world has fallen.';
    }
  }

  void resetGame() {
    nodes = WorldGraph.createNodes();
    playerScore = 0;
    gameOverTitle = null;
    warLog = 'New campaign started. Select a highlighted territory.';
    notifyListeners();
  }
}
