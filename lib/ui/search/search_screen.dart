import 'package:flutter/material.dart';
import '../../data/card.dart';
import '../flashcard_detail_screen.dart';
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

  List<Flashcard> get filteredResults {
    if (query.trim().isEmpty) return const [];

    final q = query.toLowerCase();

    bool matches(String value) {
      if (value.isEmpty) return false;
      return value.toLowerCase().contains(q);
    }

    return widget.cards.where((card) {
      return matches(card.meaning) ||
          matches(card.headword) ||
          matches(card.phonetic) ||
          matches(card.infoShortDescription);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------------------
            // BACK BUTTON (MATCHES NAV MENU)
            // ------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 8),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 26),
                color: Colors.black87,
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 12),

            // ------------------------------------------------------------
            // SEARCH FIELD (MATCHES NAVIGATOR SEARCH STUB HEIGHT)
            // ------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                        style: const TextStyle(height: 1.2),
                        decoration: const InputDecoration(
                          hintText: 'Search',
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

            // ------------------------------------------------------------
            // RESULTS / EMPTY STATES
            // ------------------------------------------------------------
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    // Empty query → show nothing
    if (query.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    // No results
    if (filteredResults.isEmpty) {
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

    // Results list
    return ListView.builder(
      itemCount: filteredResults.length,
      itemBuilder: (context, index) {
        final card = filteredResults[index];
        final originalIndex = widget.cards.indexOf(card);

        return ListTile(
          title: Text(card.headword),
          subtitle: Text(card.meaning),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: 'from-search'),
                builder: (_) => FlashcardDetailScreen(
                  cards: widget.cards,
                  index: originalIndex,
                  audio: widget.audio,
                ),
              ),
            );
          },
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
