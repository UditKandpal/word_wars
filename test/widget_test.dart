
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:word_wars/main.dart';
import 'package:word_wars/services/dictionary_service.dart';
import 'package:word_wars/services/stage_service.dart';

void main() {
  testWidgets('App starts smoke test', (WidgetTester tester) async {
    // Ensure the binding is initialized before loading assets.
    WidgetsFlutterBinding.ensureInitialized();

    // Load the real services, just like in main.dart
    final dictionary = await DictionaryService.load();
    final stages = await StageService.load();

    // Build our app and trigger a frame.
    await tester.pumpWidget(WordWarsApp(dictionary: dictionary, stages: stages));

    // Verify that the app starts.
    expect(find.byType(WordWarsApp), findsOneWidget);
  });
}
