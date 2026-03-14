import 'package:flutter/material.dart';

import 'config/flavour.dart';
import 'i18n/i18n.dart';
import 'ui/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await I18n.load(); // Load i18n JSONs from assets before app runs
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        fontFamily: _defaultFontForCountry(),
      ),
      home: const MainScreen(),
    );
  }
}

/// ------------------------------------------------------------
/// FONT SELECTION BY FLAVOUR
/// ------------------------------------------------------------
/// Keep this conservative:
/// - Thai → Sarabun
/// - Others → SourceSans3 (Latin-safe, Vietnamese-safe)
String _defaultFontForCountry() {
  switch (country) {
    case 'thailand':
      return 'Sarabun';
    default:
      return 'SourceSans3';
  }
}