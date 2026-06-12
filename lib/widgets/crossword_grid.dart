import 'dart:math';
import 'package:flutter/material.dart';
import '../models/puzzle.dart';

/// Renders the crossword grid for a stage. Cells of solved words
/// reveal their letters with a springy pop animation.
class CrosswordGrid extends StatelessWidget {
  final PuzzleStage stage;
  final Set<String> solvedWords;

  const CrosswordGrid({
    super.key,
    required this.stage,
    required this.solvedWords,
  });

  @override
  Widget build(BuildContext context) {
    final cells = <(int, int), String>{};
    final revealed = <(int, int)>{};
    var maxR = 0;
    var maxC = 0;
    for (final p in stage.placements) {
      for (var i = 0; i < p.word.length; i++) {
        final r = p.across ? p.row : p.row + i;
        final c = p.across ? p.col + i : p.col;
        cells[(r, c)] = p.word[i];
        if (solvedWords.contains(p.word)) revealed.add((r, c));
        maxR = max(maxR, r);
        maxC = max(maxC, c);
      }
    }
    final rows = maxR + 1;
    final cols = maxC + 1;
    return LayoutBuilder(builder: (context, box) {
      final cell = min(min(box.maxWidth / cols, box.maxHeight / rows), 44.0);
      return Center(
        child: SizedBox(
          width: cols * cell,
          height: rows * cell,
          child: Stack(
            children: cells.entries.map((e) {
              final isRevealed = revealed.contains(e.key);
              return Positioned(
                left: e.key.$2 * cell,
                top: e.key.$1 * cell,
                width: cell,
                height: cell,
                child: Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isRevealed
                          ? Colors.amber.shade700
                          : const Color(0xFF26313A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: isRevealed
                        ? TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.elasticOut,
                            builder: (context, t, child) =>
                                Transform.scale(scale: t, child: child),
                            child: Text(
                              e.value.toUpperCase(),
                              style: TextStyle(
                                fontSize: cell * 0.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
  }
}
