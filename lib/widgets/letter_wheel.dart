import 'dart:math';
import 'package:flutter/material.dart';

/// Circular letter wheel with drag-to-connect word building,
/// drawing live connection lines between selected letters.
class LetterWheel extends StatefulWidget {
  final String letters;
  final ValueChanged<String> onSubmit;
  final ValueChanged<String>? onChanged;
  final double size;

  const LetterWheel({
    super.key,
    required this.letters,
    required this.onSubmit,
    this.onChanged,
    this.size = 250,
  });

  @override
  State<LetterWheel> createState() => _LetterWheelState();
}

class _LetterWheelState extends State<LetterWheel> {
  static const double _tileRadius = 23;

  late List<String> _letters;
  final List<int> _selected = [];
  Offset? _finger;

  @override
  void initState() {
    super.initState();
    _letters = widget.letters.split('');
  }

  List<Offset> get _centers {
    final n = _letters.length;
    final c = widget.size / 2;
    final r = c - _tileRadius - 6;
    return List.generate(n, (i) {
      final angle = -pi / 2 + 2 * pi * i / n;
      return Offset(c + r * cos(angle), c + r * sin(angle));
    });
  }

  String get _word => _selected.map((i) => _letters[i]).join();

  void _handle(Offset pos) {
    final centers = _centers;
    var changed = false;
    for (var i = 0; i < centers.length; i++) {
      if (_selected.contains(i)) continue;
      if ((pos - centers[i]).distance <= _tileRadius + 5) {
        _selected.add(i);
        changed = true;
        break;
      }
    }
    setState(() => _finger = pos);
    if (changed) widget.onChanged?.call(_word);
  }

  void _end() {
    final word = _word;
    setState(() {
      _selected.clear();
      _finger = null;
    });
    widget.onChanged?.call('');
    if (word.isNotEmpty) widget.onSubmit(word);
  }

  void _shuffle() {
    setState(() {
      _letters.shuffle();
      _selected.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final centers = _centers;
    return GestureDetector(
      onPanStart: (d) {
        _selected.clear();
        _handle(d.localPosition);
      },
      onPanUpdate: (d) => _handle(d.localPosition),
      onPanEnd: (_) => _end(),
      onPanCancel: _end,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: Colors.white12),
              ),
            ),
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _ConnectionPainter(
                points: _selected.map((i) => centers[i]).toList(),
                finger: _finger,
              ),
            ),
            for (var i = 0; i < _letters.length; i++)
              Positioned(
                left: centers[i].dx - _tileRadius,
                top: centers[i].dy - _tileRadius,
                child: Container(
                  width: _tileRadius * 2,
                  height: _tileRadius * 2,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selected.contains(i)
                        ? Colors.amber
                        : const Color(0xFF31404D),
                  ),
                  child: Text(
                    _letters[i].toUpperCase(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color:
                          _selected.contains(i) ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            Center(
              child: IconButton(
                icon: const Icon(Icons.shuffle, color: Colors.white38),
                onPressed: _shuffle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints the amber line connecting selected letters and the live
/// segment from the last letter to the current finger position.
class _ConnectionPainter extends CustomPainter {
  final List<Offset> points;
  final Offset? finger;

  _ConnectionPainter({required this.points, this.finger});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    if (finger != null) {
      path.lineTo(finger!.dx, finger!.dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ConnectionPainter old) => true;
}
