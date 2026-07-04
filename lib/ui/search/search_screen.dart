import 'package:flutter/material.dart';

import '../../data/card.dart';
import '../../services/audio_service.dart';
import '../featured_food_detail_screen.dart';

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

  List<Flashcard> get filteredResults {
    final q = query.toLowerCase().trim();

    if (q.isEmpty) {
      return const [];
    }

    bool matches(String value) {
      return value.toLowerCase().contains(q);
    }

    final results = widget.cards.where((card) {
      return matches(card.headword) ||
          matches(card.phonetic) ||
          matches(card.infoShortDescription) ||
          matches(card.region) ||
          matches(card.milk) ||
          matches(card.strength) ||
          card.types.any(matches);
    }).toList();

    results.sort(
      (a, b) => a.headword.toLowerCase().compareTo(
            b.headword.toLowerCase(),
          ),
    );

    return results;
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredResults;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 4,
                top: 8,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 26,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                8,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 20,
                      color: Color(0xFF8E8E93),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        maxLines: 1,
                        style: const TextStyle(
                          height: 1.2,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search cheeses',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
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
            const SizedBox(height: 8),
            Expanded(
              child: _buildResults(results),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(List<Flashcard> results) {
    if (query.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    if (results.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No results found',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: results.length,
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/cheese/images/words/${card.image}',
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
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}