import 'package:flutter/material.dart';

import '../../config/flavour.dart';
import '../../data/card.dart';
import '../../services/audio_service.dart';
import '../featured_food_detail_screen.dart';
import '../widgets/favorite_heart_button.dart';

class ExploreScreen extends StatefulWidget {
  final List<Flashcard> cards;
  final AudioService audio;
  final String languageCode;
  final bool autoAudio;

  const ExploreScreen({
    super.key,
    required this.cards,
    required this.audio,
    this.languageCode = 'en',
    this.autoAudio = false,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final Set<String> selectedTypes = {};
  final Set<String> selectedMilk = {};
  final Set<String> selectedStrength = {};
  final Set<String> selectedRegions = {};

  final Set<String> openSections = {
    'Type',
  };

  final List<String> typeOptions = [
    'Soft',
    'Semi-Soft / Semi-Hard',
    'Hard',
    'Blue',
  ];

  final List<String> milkOptions = [
    'cow',
    'goat',
    'sheep',
  ];

  final List<String> strengthOptions = [
    'very mild',
    'mild',
    'medium',
    'strong',
    'very strong',
  ];

  final List<String> regionOptions = [
    'Normandy & Channel Coast',
    'Paris Basin & Northern Heartland',
    'Burgundy, Jura & Eastern France',
    'Alps & Savoie',
    'Auvergne & Central Mountains',
    'Loire Valley & Western France',
    'Southwest & Pyrenees',
    'Mediterranean South & Corsica',
  ];

  List<Flashcard> get filteredResults {
    bool matchesTypes(Flashcard card) {
      if (selectedTypes.isEmpty) return true;

      final cardTypes = card.types.map((e) => e.toLowerCase()).toList();
      final expandedTypes = [...cardTypes];

      if (cardTypes.contains('fresh')) {
        expandedTypes.add('soft');
      }

      if (cardTypes.contains('semi-soft / semi-hard')) {
        expandedTypes.add('semi-soft');
        expandedTypes.add('semi-hard');
      }

      return selectedTypes.any(
        (selected) => expandedTypes.contains(selected.toLowerCase()),
      );
    }

    bool matchesMilk(Flashcard card) {
      if (selectedMilk.isEmpty) return true;
      return selectedMilk.contains(card.milk);
    }

    bool matchesStrength(Flashcard card) {
      if (selectedStrength.isEmpty) return true;
      return selectedStrength.contains(card.strength);
    }

    bool matchesRegion(Flashcard card) {
      if (selectedRegions.isEmpty) return true;
      return selectedRegions.contains(card.region);
    }

    final results = widget.cards.where((card) {
      return matchesTypes(card) &&
          matchesMilk(card) &&
          matchesStrength(card) &&
          matchesRegion(card);
    }).toList();

    results.sort(
      (a, b) => a.headword.toLowerCase().compareTo(
            b.headword.toLowerCase(),
          ),
    );

    return results;
  }

  bool get hasActiveFilters {
    return selectedTypes.isNotEmpty ||
        selectedMilk.isNotEmpty ||
        selectedStrength.isNotEmpty ||
        selectedRegions.isNotEmpty;
  }

  void _clearAllFilters() {
    setState(() {
      selectedTypes.clear();
      selectedMilk.clear();
      selectedStrength.clear();
      selectedRegions.clear();
    });
  }

  void _toggleSection(String title) {
    setState(() {
      if (openSections.contains(title)) {
        openSections.remove(title);
      } else {
        openSections.add(title);
      }
    });
  }

  void _toggleOption(Set<String> selectedSet, String option, bool selected) {
    setState(() {
      if (selected) {
        selectedSet.add(option);
      } else {
        selectedSet.remove(option);
      }
    });
  }

  void _openCard(
    BuildContext context,
    List<Flashcard> list,
    int index,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeaturedFoodDetailScreen(
          cards: list,
          index: index,
          allCards: widget.cards,
          audio: widget.audio,
          languageCode: widget.languageCode,
          autoAudio: widget.autoAudio,
        ),
      ),
    );
  }

  Widget _buildAccordionSection({
    required String title,
    required List<String> options,
    required Set<String> selectedSet,
  }) {
    final isOpen = openSections.contains(title);
    final selectedCount = selectedSet.length;

    return Column(
      children: [
        InkWell(
          onTap: () => _toggleSection(title),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedCount == 0 ? title : '$title ($selectedCount)',
                    style: const TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 22,
                      letterSpacing: 0.06,
                    ),
                  ),
                ),
                Icon(
                  isOpen ? Icons.expand_less : Icons.expand_more,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
        if (isOpen)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: options.map((option) {
                  final isSelected = selectedSet.contains(option);

                  return FilterChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) {
                      _toggleOption(
                        selectedSet,
                        option,
                        selected,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredResults;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        key: const PageStorageKey<String>('explore_screen_scroll'),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'BROWSE CHEESES',
                    style: TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 26,
                      letterSpacing: 0.06,
                    ),
                  ),
                ),
                if (hasActiveFilters)
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: const Text('Clear'),
                  ),
              ],
            ),
          ),

          _buildAccordionSection(
            title: 'Type',
            options: typeOptions,
            selectedSet: selectedTypes,
          ),
          _buildAccordionSection(
            title: 'Milk',
            options: milkOptions,
            selectedSet: selectedMilk,
          ),
          _buildAccordionSection(
            title: 'Strength',
            options: strengthOptions,
            selectedSet: selectedStrength,
          ),
          _buildAccordionSection(
            title: 'Region',
            options: regionOptions,
            selectedSet: selectedRegions,
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: Text(
              '${results.length} cheeses',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          if (results.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text('No cheeses match these filters'),
              ),
            )
          else
            GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final card = results[index];

                return GestureDetector(
                  onTap: () => _openCard(
                    context,
                    results,
                    index,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                imageCountryPath(card.image),
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return Container(
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: FavoriteHeartButton(
                                card: card,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        card.headword,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}