import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/world_graph.dart';
import '../models/territory.dart';
import '../state/game_state.dart';
import '../widgets/ad_banner_placeholder.dart';
import '../widgets/edge_painter.dart';
import '../widgets/territory_node_widget.dart';
import 'puzzle_screen.dart';

/// The strategic world map: graph of territory nodes over a map background.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _dialogShowing = false;

  void _flash(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
      );
  }

  Future<void> _attack(GameState game, TerritoryNode n) async {
    final conquered = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PuzzleScreen(city: n.name)),
    );
    if (conquered != true) {
      game.abandonSiege(n.name);
    }
  }

  void _maybeShowGameOver(GameState game) {
    if (game.gameOverTitle == null || _dialogShowing) return;
    _dialogShowing = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text(game.gameOverTitle ?? ''),
          content: Text('Final score: ${game.playerScore}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _dialogShowing = false;
                game.resetGame();
              },
              child: const Text('NEW CAMPAIGN'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    _maybeShowGameOver(game);
    return Scaffold(
      appBar: AppBar(
        title: Text('WORD WARS 1914 - ${game.playerScore} pts'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: game.resetGame),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              game.warLog,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.amber, fontSize: 13),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  // Swap for a DecorationImage with assets/world_map.png later.
                  gradient: const LinearGradient(
                    colors: [Color(0xFF12222E), Color(0xFF1B3A2F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: LayoutBuilder(
                  builder: (context, box) {
                    final w = box.maxWidth;
                    final h = box.maxHeight;
                    return Stack(
                      children: [
                        CustomPaint(
                          size: Size(w, h),
                          painter: EdgePainter(game.nodes, WorldGraph.edges),
                        ),
                        ...game.nodes.values.map((n) {
                          final attackable = game.isAttackable(n);
                          return Positioned(
                            left: n.pos.dx * w - 34,
                            top: n.pos.dy * h - 22,
                            child: TerritoryNodeWidget(
                              node: n,
                              attackable: attackable,
                              onTap: () {
                                if (attackable) {
                                  _attack(game, n);
                                } else {
                                  _flash(n.owner == Owner.player
                                      ? '${n.name} is already yours.'
                                      : 'No supply route to ${n.name} yet!');
                                }
                              },
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const AdBannerPlaceholder(),
        ],
      ),
    );
  }
}
