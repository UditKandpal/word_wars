import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:word_wars/screens/map_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'WORD WARS',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(onPressed: () {}, child: const Text('How to Play')),
          TextButton(onPressed: () {}, child: const Text('Campaigns')),
          TextButton(onPressed: () {}, child: const Text('Ranks')),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
            },
            child: const Text('Play Free'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE5E5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'NEW CAMPAIGN UNLOCKED',
                    style: GoogleFonts.nunito(
                      color: const Color(0xFFD9534F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'WORD WARS',
                  style: GoogleFonts.bangers(fontSize: 80, letterSpacing: 4),
                ),
                const SizedBox(height: 24),
                Text(
                  'Crossword puzzles meet territory conquest. Solve clues to\n'
                  'weaken a city\'s defenses, finish the grid first, and plant\n'
                  'your flag. Every word you complete is ground you control.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapScreen()),
                    );
                  },
                  child: const Text('Start Conquering'),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('See How It Works'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
