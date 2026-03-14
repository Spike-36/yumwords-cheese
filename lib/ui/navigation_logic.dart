// lib/ui/navigation_logic.dart

import 'package:flutter/material.dart';

import '../config/flavour.dart' as cfg;   // ← uses COUNTRY from dart-define
import '../data/card.dart';
import '../services/audio_service.dart';
import 'category_overview_screen.dart';
import 'deck_screen.dart';
import 'flashcard_detail_screen.dart';

class NavigationLogic {

  // ----------------------------------------------------------------------
  // FLAVOUR — sourced from config/flavour.dart
  // ----------------------------------------------------------------------

  static String get flavour => cfg.country;

  // ----------------------------------------------------------------------
  // PUBLIC ENTRY POINT
  // ----------------------------------------------------------------------

  static void openCategory({
    required BuildContext context,
    required List<Flashcard> cards,
    required AudioService audio,
    required bool autoAudio,
    required String categoryName,
    bool isLocalFlavours = false,
  }) {
    _openCategory(
      context,
      cards,
      audio,
      autoAudio,
      categoryName,
      isLocalFlavours: isLocalFlavours,
    );
  }

  // ----------------------------------------------------------------------

  static void startCategoryFlow({
    required BuildContext context,
    required List<Flashcard> cards,
    required AudioService audio,
    required bool autoAudio,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryOverviewScreen(
          flavour: flavour,
          onCategorySelected: (selectedCategory) {
            _openCategory(context, cards, audio, autoAudio, selectedCategory);
          },
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // OPEN CATEGORY
  // ----------------------------------------------------------------------

  static void _openCategory(
    BuildContext context,
    List<Flashcard> cards,
    AudioService audio,
    bool autoAudio,
    String selectedCategory, {
    bool isLocalFlavours = false,
  }) {

    final selectedLower = selectedCategory.trim().toLowerCase();

    List<Flashcard> filtered;

    if (isLocalFlavours) {

      filtered = cards.where((c) {

        final typeMatch = c.types
            .map((t) => t.trim().toLowerCase())
            .contains(selectedLower);

        final tagMatch = c.tags
            .map((t) => t.trim().toLowerCase())
            .contains('local');

        return typeMatch && tagMatch;

      }).toList();

    } else {

      filtered = cards.where((c) {

        return c.types
            .map((t) => t.trim().toLowerCase())
            .contains(selectedLower);

      }).toList();
    }

    // ------------------------------------------------------------

    if (selectedLower == "numbers") {

      filtered.sort((a, b) =>
          (a.value ?? 0).compareTo(b.value ?? 0));

    } else {

      filtered.sort((a, b) =>
          a.meaning.trim().toLowerCase()
              .compareTo(b.meaning.trim().toLowerCase()));
    }

    // ------------------------------------------------------------

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeckScreen(
          cards: filtered,
          audio: audio,
          categoryLabel: selectedCategory,
          languageCode: 'en',
          onCardTapped: (tapped, flatList) {
            _openDetail(
              context,
              tapped,
              flatList,
              audio,
              autoAudio,
              selectedCategory,
            );
          },
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // DETAIL SCREEN
  // ----------------------------------------------------------------------

  static void _openDetail(
    BuildContext context,
    Flashcard tapped,
    List<Flashcard> flatList,
    AudioService audio,
    bool autoAudio,
    String selectedCategory,
  ) {

    final startIndex = flatList.indexWhere((c) => c.id == tapped.id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _DetailRoute(
          cards: flatList,
          startIndex: startIndex,
          audio: audio,
          autoAudio: autoAudio,
        ),
      ),
    );
  }
}

// ============================================================================
// DETAIL ROUTE
// ============================================================================

class _DetailRoute extends StatefulWidget {

  final List<Flashcard> cards;
  final int startIndex;
  final AudioService audio;
  final bool autoAudio;

  const _DetailRoute({
    required this.cards,
    required this.startIndex,
    required this.audio,
    required this.autoAudio,
  });

  @override
  State<_DetailRoute> createState() => _DetailRouteState();
}

class _DetailRouteState extends State<_DetailRoute> {

  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.startIndex;
  }

  @override
  Widget build(BuildContext context) {

    return FlashcardDetailScreen(
      cards: widget.cards,
      index: currentIndex,
      audio: widget.audio,
      autoAudio: widget.autoAudio,
      languageCode: 'en',
      onIndexChange: (i) => setState(() => currentIndex = i),
    );
  }
}