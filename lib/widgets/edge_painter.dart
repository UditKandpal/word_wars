import 'package:flutter/material.dart';
import '../models/territory.dart';

/// Draws the supply-line web between territory nodes.
class EdgePainter extends CustomPainter {
  final Map<String, TerritoryNode> nodes;
  final List<List<String>> edges;

  EdgePainter(this.nodes, this.edges);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 1.5;
    for (final e in edges) {
      final a = nodes[e[0]]!.pos;
      final b = nodes[e[1]]!.pos;
      canvas.drawLine(
        Offset(a.dx * size.width, a.dy * size.height),
        Offset(b.dx * size.width, b.dy * size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant EdgePainter old) => true;
}
