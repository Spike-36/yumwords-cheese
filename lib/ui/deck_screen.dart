// lib/ui/deck_screen.dart
// DeckScreen — FIXED to match Flashcard model + JSON

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../data/card.dart';
import '../services/audio_service.dart';
import 'flashcard_tile.dart';

class DeckScreen extends StatefulWidget {
  final List<Flashcard> cards;
  final AudioService audio;
  final String languageCode;
  final void Function(int)? onCardSelected;
  final void Function(Flashcard, List<Flashcard>)? onCardTapped;
  final int resetTicker;
  final String categoryLabel;

  const DeckScreen({
    super.key,
    required this.cards,
    required this.audio,
    required this.categoryLabel,
    this.languageCode = 'en',
    this.onCardSelected,
    this.onCardTapped,
    this.resetTicker = 0,
  });

  @override
  State<DeckScreen> createState() => _DeckScreenState();
}

class _Row {
  final String? header;
  final Flashcard? card;

  const _Row.header(this.header) : card = null;
  const _Row.item(this.card) : header = null;

  bool get isHeader => header != null;
}

class _DeckScreenState extends State<DeckScreen> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  List<_Row> _rows = const [];
  List<Flashcard> _flatCards = const [];

  bool _showTapTip = false;

  @override
  void initState() {
    super.initState();
    _rebuildRows();
    _loadTapTipPreference();
  }

  Future<void> _loadTapTipPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final hideTip = prefs.getBool('hideDeckTapTip') ?? false;
    if (!hideTip && mounted) setState(() => _showTapTip = true);
  }

  Future<void> _dismissTapTip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hideDeckTapTip', true);
    if (mounted) setState(() => _showTapTip = false);
  }

  // ============================================================
  // BUILD ROWS — MODEL-ALIGNED
  // ============================================================
  void _rebuildRows() {
    final rows = <_Row>[];
    final cards = widget.cards;

    final label = widget.categoryLabel.trim();
    final lower = label.toLowerCase();

    bool isCat(String s) => lower == s.toLowerCase();

    final isEssentialDrinks = label == "Essential Drinks";
    final isDrinks = isCat("Drinks") && !isEssentialDrinks;
    final isProteins = isCat("Proteins");
    final isSnacks = isCat("Snacks");
    final isHerbsSpices = isCat("Herbs & Spices");
    final isAromaticsPastes = isCat("Aromatics & Pastes");
    final isCondiments = isCat("Condiments");

    rows.add(_Row.header(label));

    const drinksOrder = [
      "Soft Drinks",
      "Coffee",
      "Tea",
      "Other Hot Drinks",
      "Alcoholic Drinks",
    ];

    const proteinOrder = [
      "Meat",
      "Seafood",
      "Other Proteins",
    ];

    const snacksOrder = [
      "Savoury Snacks",
      "Sweet Snacks",
    ];

    const herbsSpicesOrder = [
      "Herbs",
      "Spices",
    ];

    const aromaticsPastesOrder = [
      "Aromatics",
      "Pastes",
    ];

    const condimentsOrder = [
      "Sauces",
      "Table Seasonings",
      "Pickles & Relishes",
      "Accompaniments",
    ];

    // Flat categories
    if (isEssentialDrinks ||
        (!isDrinks &&
            !isProteins &&
            !isSnacks &&
            !isHerbsSpices &&
            !isAromaticsPastes &&
            !isCondiments)) {
      for (final c in cards) {
        rows.add(_Row.item(c));
      }
      _commit(rows);
      return;
    }

    final Map<String, List<Flashcard>> groups = {};

    for (final c in cards) {
      String? sub;

      if (isDrinks) sub = c.drinksType;
      if (isProteins) sub = c.proteinTypes;
      if (isSnacks) sub = c.extra?['snackTypes']?.toString();
      if (isHerbsSpices || isAromaticsPastes) sub = c.hasTypes;
      if (isCondiments) sub = c.sspType;

      sub = (sub ?? "").trim();
      if (sub.isEmpty) continue;

      groups.putIfAbsent(sub, () => []);
      groups[sub]!.add(c);
    }

    final order = isDrinks
        ? drinksOrder
        : isProteins
            ? proteinOrder
            : isSnacks
                ? snacksOrder
                : isHerbsSpices
                    ? herbsSpicesOrder
                    : isAromaticsPastes
                        ? aromaticsPastesOrder
                        : condimentsOrder;

    for (final sub in order) {
      if (!groups.containsKey(sub)) continue;
      rows.add(_Row.header(sub));
      for (final c in groups[sub]!) {
        rows.add(_Row.item(c));
      }
    }

    _commit(rows);
  }

  void _commit(List<_Row> rows) {
    final flat =
        rows.where((r) => r.card != null).map((r) => r.card!).toList();

    setState(() {
      _rows = rows;
      _flatCards = flat;
    });
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 26),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemCount: _rows.length,
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
                itemBuilder: (context, i) {
                  final row = _rows[i];

                  if (row.isHeader) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Text(
                        row.header!.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'BebasNeue',
                          fontSize: 18,
                        ),
                      ),
                    );
                  }

                  final card = row.card!;
                  final idx =
                      _flatCards.indexWhere((c) => c.id == card.id);

                  return FlashcardTile(
                    cards: _flatCards,
                    index: idx,
                    audio: widget.audio,
                    languageCode: widget.languageCode,
                    onCardSelected: (i) {
                      widget.onCardSelected?.call(i);
                      widget.onCardTapped?.call(
                          _flatCards[i], _flatCards);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
