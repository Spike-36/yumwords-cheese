import 'package:flutter/material.dart';
import '../../data/card.dart';
import '../featured_food_detail_screen.dart';
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
  final TextEditingController _controller =
      TextEditingController();

  String query = '';

  // ------------------------------------------------------------
  // FILTER STATE
  // ------------------------------------------------------------
  Set<String> selectedTypes = {};
  Set<String> selectedMilk = {};
  Set<String> selectedStrength = {};
  Set<String> selectedRegions = {};

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

  // ------------------------------------------------------------
  // FILTER LOGIC
  // ------------------------------------------------------------
  List<Flashcard> get filteredResults {
    final q = query.toLowerCase().trim();

    bool matchesText(Flashcard card) {
      if (q.isEmpty) return true;

      return card.headword
              .toLowerCase()
              .contains(q) ||
          card.phonetic
              .toLowerCase()
              .contains(q) ||
          card.infoShortDescription
              .toLowerCase()
              .contains(q);
    }

    bool matchesTypes(Flashcard card) {
      if (selectedTypes.isEmpty) {
        return true;
      }

      final cardTypes = card.types
          .map((e) => e.toLowerCase())
          .toList();

      final expandedTypes = [...cardTypes];

      if (cardTypes.contains('fresh')) {
        expandedTypes.add('soft');
      }

      if (cardTypes.contains(
          'semi-soft / semi-hard')) {
        expandedTypes.add('semi-soft');
        expandedTypes.add('semi-hard');
      }

      return selectedTypes.any(
        (selected) => expandedTypes
            .contains(selected.toLowerCase()),
      );
    }

    bool matchesMilk(Flashcard card) {
      if (selectedMilk.isEmpty) {
        return true;
      }

      return selectedMilk.contains(
        card.milk,
      );
    }

    bool matchesStrength(Flashcard card) {
      if (selectedStrength.isEmpty) {
        return true;
      }

      return selectedStrength.contains(
        card.strength,
      );
    }

    bool matchesRegion(Flashcard card) {
      if (selectedRegions.isEmpty) {
        return true;
      }

      return selectedRegions.contains(
        card.region,
      );
    }

    final results =
        widget.cards.where((card) {
      return matchesText(card) &&
          matchesTypes(card) &&
          matchesMilk(card) &&
          matchesStrength(card) &&
          matchesRegion(card);
    }).toList();

    results.sort(
      (a, b) => a.headword
          .toLowerCase()
          .compareTo(
            b.headword.toLowerCase(),
          ),
    );

    return results;
  }

  // ------------------------------------------------------------
  // CHIP GROUP
  // ------------------------------------------------------------
  Widget buildChipGroup({
    required String title,
    required List<String> options,
    required Set<String> selectedSet,
    required VoidCallback refreshModal,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected =
                  selectedSet.contains(option);

              return FilterChip(
                label: Text(option),

                selected: isSelected,

                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedSet.add(option);
                    } else {
                      selectedSet.remove(option);
                    }
                  });

                  refreshModal();
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // CLEAR FILTERS
  // ------------------------------------------------------------
  void _clearAllFilters() {
    setState(() {
      selectedTypes.clear();
      selectedMilk.clear();
      selectedStrength.clear();
      selectedRegions.clear();
      query = '';
      _controller.clear();
    });
  }

  // ------------------------------------------------------------
  // FILTER MODAL
  // ------------------------------------------------------------
  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, modalSetState) {
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 12,
                  bottom: 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .grey
                                .shade400,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                          height: 20),

                      Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            const Text(
                              'Filters',
                              style:
                                  TextStyle(
                                fontSize:
                                    20,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                _clearAllFilters();
                                modalSetState(
                                    () {});
                              },
                              child: const Text(
                                'Clear',
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height: 12),

                      buildChipGroup(
                        title: 'Type',
                        options:
                            typeOptions,
                        selectedSet:
                            selectedTypes,
                        refreshModal: () {
                          modalSetState(
                              () {});
                        },
                      ),

                      buildChipGroup(
                        title: 'Milk',
                        options:
                            milkOptions,
                        selectedSet:
                            selectedMilk,
                        refreshModal: () {
                          modalSetState(
                              () {});
                        },
                      ),

                      buildChipGroup(
                        title: 'Strength',
                        options:
                            strengthOptions,
                        selectedSet:
                            selectedStrength,
                        refreshModal: () {
                          modalSetState(
                              () {});
                        },
                      ),

                      buildChipGroup(
                        title: 'Region',
                        options:
                            regionOptions,
                        selectedSet:
                            selectedRegions,
                        refreshModal: () {
                          modalSetState(
                              () {});
                        },
                      ),

                      const SizedBox(
                          height: 24),

                      Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 16,
                        ),
                        child: SizedBox(
                          width:
                              double.infinity,
                          child:
                              ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                  context);
                            },
                            child: const Text(
                              'Done',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
            Padding(
              padding:
                  const EdgeInsets.only(
                left: 4,
                top: 8,
              ),
              child: Align(
                alignment:
                    Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 26,
                  ),
                  onPressed: () =>
                      Navigator.pop(
                    context,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                8,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      const Color(0xFFF2F2F2),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 20,
                    ),

                    const SizedBox(
                        width: 10),

                    Expanded(
                      child: TextField(
                        controller:
                            _controller,
                        decoration:
                            const InputDecoration(
                          hintText:
                              'Search cheeses',
                          border:
                              InputBorder.none,
                        ),
                        onChanged:
                            (value) {
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

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Align(
                alignment:
                    Alignment.centerLeft,
                child:
                    OutlinedButton.icon(
                  onPressed:
                      _showFilters,
                  icon: const Icon(
                    Icons.tune,
                  ),
                  label:
                      const Text(
                    'Filters',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            Expanded(
              child: _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // RESULTS GRID
  // ------------------------------------------------------------
  Widget _buildResults() {
    if (filteredResults.isEmpty) {
      return const Center(
        child: Text('No results'),
      );
    }

    return GridView.builder(
      padding:
          const EdgeInsets.all(12),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount:
          filteredResults.length,
      itemBuilder:
          (context, index) {
        final card =
            filteredResults[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    FeaturedFoodDetailScreen(
                  cards:
                      filteredResults,
                  index: index,
                  audio:
                      widget.audio,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius
                          .circular(
                    12,
                  ),
                  child: Image.asset(
                    'assets/cheese/images/words/${card.image}',
                    width: double
                        .infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        color: Colors
                            .grey
                            .shade200,
                        child:
                            const Center(
                          child: Icon(
                            Icons
                                .image_not_supported,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                card.headword,
                maxLines: 2,
                overflow:
                    TextOverflow
                        .ellipsis,
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight
                          .w600,
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