// lib/data/repository.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../data/card.dart';

// 👉 NEW: import flavour config for jsonPath()
import '../config/flavour.dart'; // 👉 Added

class Repository {
  // 🔄 REPLACED: old hard-coded path
  // static const _assetPath = 'assets/data/cards.json';

  // 👉 NEW: dynamic JSON path helper (no fallback for JSON)
  String get _assetPath => jsonPath('data.json'); // 👉 Added

  Future<List<Flashcard>> load() async {
    // 🔄 REPLACED: now uses flavour-aware jsonPath
    final raw = await rootBundle.loadString(_assetPath); // 👉 updated

    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();

    // 1) Remap incoming JSON to the legacy keys the model/UI expects.
    final mapped = list.map(_mapKoreanEnglishToLegacyKeys).toList();

    // 👉 Ensure tags pass through (no remapping, no filtering)
    // NOTE: _mapKoreanEnglishToLegacyKeys does not modify unknown keys,
    // so "tags" remains untouched. No action needed. // 👉

    // 2) Sort by type...
    mapped.sort(_typeAwareMapComparator);

    // 3) Parse into model objects in sorted order.
    return mapped.map((j) => Flashcard.fromJson(j)).toList(growable: false);
  }
}

/// Remap your Thai/English JSON to the legacy keys expected by Flashcard.fromJson.
Map<String, dynamic> _mapKoreanEnglishToLegacyKeys(Map<String, dynamic> src) {
  final m = Map<String, dynamic>.from(src);

  // Display/text fields
  m['scottish'] = m['thai'];                        // 🔄 display Thai instead of Korean
  m['phonetic'] = m['phonetic'] ?? m['koreanPhonetic'];
  m['meaning']  = m['english'];

  // Audio aliases
  m['audioScottish']        = m['audioThai'];
  m['audioScottishSlow']    = m['audioThai'];
  m['audioScottishContext'] = m['audioEnglish'];

  // 👉 IMPORTANT: tags pass through untouched if present in src
  // No need to add or modify 'tags' – preserved by Map.from() // 👉

  return m;
}

/// Comparator unchanged
int _typeAwareMapComparator(Map<String, dynamic> a, Map<String, dynamic> b) {
  final ta = (a['type'] ?? '').toString().toLowerCase();
  final tb = (b['type'] ?? '').toString().toLowerCase();

  final byType = ta.compareTo(tb);
  if (byType != 0) return byType;

  if (ta == 'numbers') {
    final va = _asInt(a['numeral']);
    final vb = _asInt(b['numeral']);
    return va.compareTo(vb);
  }

  final ea = (a['english'] ?? a['meaning'] ?? '').toString().toLowerCase().trim();
  final eb = (b['english'] ?? b['meaning'] ?? '').toString().toLowerCase().trim();
  return ea.compareTo(eb);
}

int _asInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v?.toString() ?? '') ?? 0;
}
