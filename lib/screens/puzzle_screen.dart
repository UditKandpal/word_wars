import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/puzzle.dart';
import '../services/stage_service.dart';
import '../state/game_state.dart';
import '../widgets/crossword_grid.dart';
import '../widgets/letter_wheel.dart';

/// The siege screen: clear all crossword stages to conquer the city.
/// Pops with `true` when the city is conquered.
class PuzzleScreen extends StatefulWidget {
  final String city;

  const PuzzleScreen({super.key, required this.city});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  late List<PuzzleStage> _stages;
  int _stageIndex = 0;
  final Set<String> _solved = {};
  final Set<String> _bonus = {};
  String _currentWord = '';

  PuzzleStage get _stage => _stages[_stageIndex];

  Set<String> get _answers => _stage.placements.map((p) => p.word).toSet();

  @override
  void initState() {
    super.initState();
    _stages = context.read<StageService>().stagesFor(widget.city);
    if (_stages.isEmpty) {
      // No level data authored for this city: auto-conquer as a fallback.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context, true);
      });
    }
  }

  void _flash(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        duration: const Duration(milliseconds: 900),
      ));
  }

  void _onSubmit(String word) {
    if (word.length < 2) return;
    final game = context.read<GameState>();
    if (_answers.contains(word)) {
      if (_solved.contains(word)) {
        _flash('Already found!');
        return;
      }
      setState(() => _solved.add(word));
      game.addScore(word.length * 15);
      if (_solved.length == _answers.length) _onStageCleared();
    } else if (word.length >= 3 &&
        game.isDictionaryWord(word) &&
        !_bonus.contains(word)) {
      setState(() => _bonus.add(word));
      game.addScore(word.length * 5);
      _flash('Bonus word! +${word.length * 5}');
    } else {
      _flash('"${word.toUpperCase()}" repelled by the defenders!');
    }
  }

  void _onStageCleared() {
    final last = _stageIndex == _stages.length - 1;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        title: Text(
            last ? '${widget.city} has fallen!' : 'Stage ${_stageIndex + 1} cleared!'),
        content: Text(last
            ? 'The city is yours, Commander.'
            : 'The defenses weaken. Push on!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              if (last) {
                Navigator.pop(context, true);
              } else {
                setState(() {
                  _stageIndex++;
                  _solved.clear();
                });
              }
            },
            child: Text(last ? 'CLAIM CITY' : 'NEXT STAGE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_stages.isEmpty) {
      return const Scaffold(body: SizedBox.shrink());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'SIEGE: ${widget.city}  (${_stageIndex + 1}/${_stages.length})'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('Bonus: ${_bonus.length}',
                  style: const TextStyle(color: Colors.amber)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: CrosswordGrid(stage: _stage, solvedWords: _solved),
              ),
            ),
            SizedBox(
              height: 34,
              child: Text(
                _currentWord.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Colors.amber,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              child: LetterWheel(
                key: ValueKey(_stageIndex),
                letters: _stage.letters,
                onChanged: (w) => setState(() => _currentWord = w),
                onSubmit: _onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
