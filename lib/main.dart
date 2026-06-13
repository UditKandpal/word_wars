import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:word_wars/screens/home_screen.dart';
import 'services/dictionary_service.dart';
import 'services/stage_service.dart';
import 'state/game_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  final dictionary = await DictionaryService.load();
  final stages = await StageService.load();
  runApp(WordWarsApp(dictionary: dictionary, stages: stages));
}

class WordWarsApp extends StatelessWidget {
  final DictionaryService dictionary;
  final StageService stages;

  const WordWarsApp({
    super.key,
    required this.dictionary,
    required this.stages,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState(dictionary)),
        Provider<StageService>.value(value: stages),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Word Wars',
        theme: _buildThemeData(context),
        home: const HomeScreen(),
      ),
    );
  }

  ThemeData _buildThemeData(BuildContext context) {
    const primaryColor = Color(0xFFF2B400);
    const secondaryColor = Color(0xFF232D3F);
    const backgroundColor = Color(0xFFFEF8E5);

    final baseTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme).apply(
        bodyColor: secondaryColor,
        displayColor: secondaryColor,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        brightness: Brightness.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: secondaryColor, width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondaryColor,
          side: const BorderSide(color: secondaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );

    return baseTheme;
  }
}
