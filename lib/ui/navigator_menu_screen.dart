import 'package:flutter/material.dart';

import '../data/card.dart';
import '../services/audio_service.dart';
import 'navigation_logic.dart';
import 'search/search_screen.dart';
import '../data/category_types.dart';

class NavigatorMenuScreen extends StatelessWidget {
  final List<Flashcard> cards;
  final AudioService audio;
  final String languageCode;
  final bool autoAudio;

  const NavigatorMenuScreen({
    super.key,
    required this.cards,
    required this.audio,
    required this.languageCode,
    required this.autoAudio,
  });

  @override
  Widget build(BuildContext context) {
    final words =
        getCategoriesForFlavour(NavigationLogic.flavour);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 40),
          children: [
            // ------------------------------------------------------------
            // BACK
            // ------------------------------------------------------------
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 26),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 12),

            // ------------------------------------------------------------
            // SEARCH
            // ------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchScreen(
                        cards: cards,
                        audio: audio,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, size: 20, color: Color(0xFF8E8E93)),
                      SizedBox(width: 10),
                      Text(
                        'Search',
                        style: TextStyle(
                          fontFamily: 'SourceSans3',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ------------------------------------------------------------
            // WORDS HEADER
            // ------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'WORDS',
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 22,
                      letterSpacing: 0.06,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Common food and drink related words and phrases.',
                    style: TextStyle(
                      fontFamily: 'SourceSans3',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6F6F6F),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ------------------------------------------------------------
            // WORD CATEGORIES
            // ------------------------------------------------------------
            ...words
                .where((c) => _hasAnyCards(c))
                .map(
                  (cat) => ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    title: Text(
                      _displayLabel(cat),
                      style: const TextStyle(
                        fontFamily: 'SourceSans3',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      NavigationLogic.openCategory(
                        context: context,
                        cards: cards,
                        audio: audio,
                        autoAudio: autoAudio,
                        categoryName: cat,
                        isLocalFlavours: false,
                      );
                    },
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // LABEL TWEAKS
  // ------------------------------------------------------------
  String _displayLabel(String key) {
    if (key == 'Basics') return 'Larder Basics';
    return key;
  }

  // ------------------------------------------------------------
  // CATEGORY DETECTION (ROBUST)
  // ------------------------------------------------------------
  bool _hasAnyCards(String categoryName) {
    final selectedLower = categoryName.trim().toLowerCase();

    return cards.any((c) {
      return c.types.any((t) {
        final type = t.trim().toLowerCase();

        return type == selectedLower ||
            type == "${selectedLower}s" ||
            "${type}s" == selectedLower;
      });
    });
  }
}