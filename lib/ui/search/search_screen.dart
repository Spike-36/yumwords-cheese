import 'package:flutter/material.dart';
import '../../data/card.dart';
import '../featured_food_detail_screen.dart'; // 🔄 CHANGED
import '../../services/audio_service.dart';

class SearchScreen extends StatefulWidget {
  final List<Flashcard> cards;
  final AudioService audio;

  const SearchScreen({
    super.key,
    required this.cards,
    required this.audio,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  String query = '';

  // ------------------------------------------------------------
  // FILTER STATE
  // ------------------------------------------------------------
  Set<String> selectedTypes = {};
  Set<String> selectedMilk = {};
  Set<String> selectedStrength = {};
  String? selectedCountry;

  // ------------------------------------------------------------
  // OPTIONS
  // ------------------------------------------------------------
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

  final List<String> countryOptions = [
    'france',
    'italy',
    'spain',
    'uk',
  ];

  // ------------------------------------------------------------
  // FILTER LOGIC
  // ------------------------------------------------------------
  List<Flashcard> get filteredResults {
    final q = query.toLowerCase().trim();

    bool matchesText(Flashcard card) {
      if (q.isEmpty) return true;

      return card.headword.toLowerCase().contains(q) ||
          card.phonetic.toLowerCase().contains(q) ||
          card.infoShortDescription.toLowerCase().contains(q);
    }

    bool matchesFilter(String value, Set<String> selected) {
      if (selected.isEmpty) return true;
      return selected.contains(value.toLowerCase());
    }

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
        (selected) => expandedTypes.contains(selected),
      );
    }

    final results = widget.cards.where((card) {
      return matchesText(card) &&
          matchesTypes(card) &&
          matchesFilter(card.milk, selectedMilk) &&
          matchesFilter(card.strength, selectedStrength) &&
          (selectedCountry == null ||
              card.country.toLowerCase() == selectedCountry);
    }).toList();

    // 👉 SORT ALPHABETICALLY
    results.sort((a, b) =>
        a.headword.toLowerCase().compareTo(b.headword.toLowerCase()));

    return results;
  }

  // ------------------------------------------------------------
  // CHIP BUILDER
  // ------------------------------------------------------------
  Widget buildChipGroup(
    String title,
    List<String> options,
    Set<String> selectedSet,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: options.map((option) {
              final value = option.toLowerCase();
              final selected = selectedSet.contains(value);

              return FilterChip(
                label: Text(option),
                selected: selected,
                onSelected: (_) {
                  setState(() {
                    if (selected) {
                      selectedSet.remove(value);
                    } else {
                      selectedSet.add(value);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            // TOP FILTER AREA
            SizedBox(
              height: 420,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 8),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 26),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  query = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Browse by category',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  buildChipGroup('Type', typeOptions, selectedTypes),
                  buildChipGroup('Milk', milkOptions, selectedMilk),
                  buildChipGroup(
                      'Strength', strengthOptions, selectedStrength),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Select country'),
                      value: selectedCountry,
                      items: countryOptions.map((country) {
                        return DropdownMenuItem(
                          value: country,
                          child: Text(country),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCountry = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // RESULTS GRID
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // GRID RESULTS
  // ------------------------------------------------------------
  Widget _buildResults() {
    if (filteredResults.isEmpty) {
      return const Center(child: Text('No results'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: filteredResults.length,
      itemBuilder: (context, index) {
        final card = filteredResults[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FeaturedFoodDetailScreen(
                  cards: filteredResults, // 👉 FIXED
                  index: index,           // 👉 FIXED
                  audio: widget.audio,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/cheese/images/words/${card.image}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // NAME
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
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}