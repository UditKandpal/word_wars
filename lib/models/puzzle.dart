/// A word placed on a crossword grid.
class WordPlacement {
  final String word;
  final int row;
  final int col;
  final bool across;

  const WordPlacement({
    required this.word,
    required this.row,
    required this.col,
    required this.across,
  });

  factory WordPlacement.fromJson(Map<String, dynamic> json) => WordPlacement(
        word: json['w'] as String,
        row: json['r'] as int,
        col: json['c'] as int,
        across: json['d'] == 'A',
      );
}

/// A single puzzle stage: wheel letters + crossword answer placements.
class PuzzleStage {
  final String letters;
  final List<WordPlacement> placements;

  const PuzzleStage({required this.letters, required this.placements});

  factory PuzzleStage.fromJson(Map<String, dynamic> json) => PuzzleStage(
        letters: json['letters'] as String,
        placements: (json['words'] as List)
            .map((w) => WordPlacement.fromJson(w as Map<String, dynamic>))
            .toList(),
      );
}
