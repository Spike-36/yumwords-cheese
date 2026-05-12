import 'package:flutter/material.dart';

import '../data/card.dart';
import '../services/audio_service.dart';
import '../config/flavour.dart';
import '../data/featured/featured_registry.dart';
import 'featured_food_detail_screen.dart';

// 👉 CHANGED
import 'search/search_screen.dart';

// ------------------------------------------------------------
// 🔒 LOCKED layout rules (do not auto-adjust)
// ------------------------------------------------------------
const List<({int heroCount, int gridCount})> _layoutRules = [
  (heroCount: 4, gridCount: 12),
  (heroCount: 1, gridCount: 10),
  (heroCount: 2, gridCount: 4),
  (heroCount: 1, gridCount: 6),
  (heroCount: 1, gridCount: 6),
  (heroCount: 1, gridCount: 8),
  (heroCount: 1, gridCount: 999),
];

class FeaturedFoodScreen extends StatefulWidget {
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

  @override
  State<FeaturedFoodScreen> createState() => _FeaturedFoodScreenState();
}

class _FeaturedFoodScreenState extends State<FeaturedFoodScreen> {
  String mode = 'type';

  Map<String, List<Flashcard>> _buildFeaturedSections() {
    final cardMap = {for (final c in widget.cards) c.id: c};

    final flavour =
        mode == 'type' ? 'cheese_type' : 'cheese_country';

    final sections = getFeaturedSections(flavour);

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

  // 👉 CHANGED: DIRECT SEARCH SCREEN
  void _openNavigatorMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(
          cards: widget.cards,
          audio: widget.audio,
        ),
      ),
    );
  }

  // 🔄 FIXED: now takes index + list
  void _openCard(
    BuildContext context,
    List<Flashcard> list,
    int index,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeaturedFoodDetailScreen(
          index: index,
          cards: list,
          audio: widget.audio,
          languageCode: widget.languageCode,
          autoAudio: widget.autoAudio,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = _buildFeaturedSections();
    final sectionList = sections.entries.toList();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,

        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 👉 top heading row with fixed centred title
            SizedBox(
              height: 36,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      appTitle(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 28,
                        letterSpacing: 0.08,
                      ),
                    ),
                  ),

                  Positioned(
                    right: -10,
                    top: -3,
                    child: IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black54,
                      ),
                      onPressed: () => _openNavigatorMenu(context),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 👉 segmented controls row
            Transform.translate(
              offset: const Offset(18, 8),
              child: SizedBox(
                width: 260,
                child: ToggleButtons(
                  constraints: const BoxConstraints(
                    minWidth: 110,
                    minHeight: 36,
                  ),
                  isSelected: [mode == 'country', mode == 'type'],
                  onPressed: (index) {
                    setState(() {
                      mode = index == 0 ? 'country' : 'type';
                    });
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Text(
                        'REGIONS',
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Text(
                        'TYPES',
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      body: ListView(
        children: sectionList.asMap().entries.map((entry) {
          final sectionIndex = entry.key;
          final section = entry.value.key;
          final sectionCards = entry.value.value;

          if (sectionCards.isEmpty) {
            return const SizedBox.shrink();
          }

          final rule = sectionIndex < _layoutRules.length
              ? _layoutRules[sectionIndex]
              : _layoutRules.last;

          final heroCards = sectionCards.take(rule.heroCount).toList();

          final gridCards = sectionCards
              .skip(rule.heroCount)
              .take(rule.gridCount)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
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

              // HERO
              ...heroCards.asMap().entries.map((entry) {
                final index = entry.key;
                final card = entry.value;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: GestureDetector(
                    onTap: () => _openCard(context, heroCards, index),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),

                          child: AspectRatio(
                            aspectRatio: 1,

                            child: Image.asset(
                              imageCountryPath(card.image),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          card.headword,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // GRID
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
                      childAspectRatio: 0.85,
                    ),

                    itemBuilder: (context, index) {
                      final card = gridCards[index];

                      return GestureDetector(
                        onTap: () =>
                            _openCard(context, gridCards, index),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),

                                child: Image.asset(
                                  imageCountryPath(card.image),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              card.headword,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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