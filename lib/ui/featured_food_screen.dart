// lib/ui/featured_food_screen.dart

import 'package:flutter/material.dart';

import '../data/card.dart';
import '../services/audio_service.dart';
import '../config/flavour.dart';
import '../data/featured/featured_registry.dart';
import 'featured_food_detail_screen.dart';
import 'navigator_menu_screen.dart';

// ------------------------------------------------------------
// 🔒 LOCKED layout rules (do not auto-adjust)
// Order corresponds to section order in featured_* files
// ------------------------------------------------------------
const List<({int heroCount, int gridCount})> _layoutRules = [
  (heroCount: 4, gridCount: 12), // Section 0
  (heroCount: 1, gridCount: 10), // Section 1
  (heroCount: 2, gridCount: 4),  // Section 2
  (heroCount: 1, gridCount: 6),  // Section 3
  (heroCount: 1, gridCount: 6),  // Section 4
  (heroCount: 1, gridCount: 8),  // Section 5
  (heroCount: 1, gridCount: 999) // Section 6
];

class FeaturedFoodScreen extends StatelessWidget {
  final List<Flashcard> cards;
  final AudioService audio;
  final String languageCode;
  final bool autoAudio;

  const FeaturedFoodScreen({
    super.key,
    required this.cards,
    required this.audio,
    this.languageCode = 'en',
    this.autoAudio = false,
  });

  // ------------------------------------------------------------
  // Build featured sections from registry
  // ------------------------------------------------------------
  Map<String, List<Flashcard>> _buildFeaturedSections() {
    final cardMap = {for (final c in cards) c.id: c};
    final sections = getFeaturedSections(country);

    return sections.map(
      (section, ids) => MapEntry(
        section,
        ids
            .map((id) => cardMap[id])
            .whereType<Flashcard>()
            .toList(),
      ),
    );
  }

  void _openNavigatorMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NavigatorMenuScreen(
          cards: cards,
          audio: audio,
          languageCode: languageCode,
          autoAudio: autoAudio,
        ),
      ),
    );
  }

  void _openCard(BuildContext context, Flashcard card) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeaturedFoodDetailScreen(
          card: card,
          audio: audio,
          cards: cards,
          languageCode: languageCode,
          autoAudio: autoAudio,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final sections = _buildFeaturedSections();
    final sectionList = sections.entries.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          appTitle(),
          style: const TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: 28,
            letterSpacing: 0.08,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black54),
            onPressed: () => _openNavigatorMenu(context),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: sectionList.asMap().entries.map((entry) {
          final index = entry.key;
          final section = entry.value.key;
          final sectionCards = entry.value.value;

          if (sectionCards.isEmpty) {
            return const SizedBox.shrink();
          }

          // Safety check in case a flavour adds more sections
          final rule =
              index < _layoutRules.length ? _layoutRules[index] : _layoutRules.last;

          final heroCards = sectionCards.take(rule.heroCount).toList();
          final gridCards = sectionCards
              .skip(rule.heroCount)
              .take(rule.gridCount)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------------------
              // SECTION HEADER
              // ------------------------------------------------------------
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  section.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 26,
                    letterSpacing: 0.06,
                  ),
                ),
              ),

              // ------------------------------------------------------------
              // HERO CARDS
              // ------------------------------------------------------------
              ...heroCards.map((card) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: GestureDetector(
                    onTap: () => _openCard(context, card),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(
                          imageCountryPath(card.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // ------------------------------------------------------------
              // GRID CARDS
              // ------------------------------------------------------------
              if (gridCards.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: gridCards.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final card = gridCards[index];
                      return GestureDetector(
                        onTap: () => _openCard(context, card),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            imageCountryPath(card.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 32),
            ],
          );
        }).toList(),
      ),
    );
  }
}