import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/map_screen.dart';
import 'services/dictionary_service.dart';
import 'services/stage_service.dart';
import 'state/game_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize(); // Uncomment once google_mobile_ads is added
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
        title: 'Word Wars 1914',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFB71C1C),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF101418),
        ),
        home: const MapScreen(),
      ),
    );
  }
}
