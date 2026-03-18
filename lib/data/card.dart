// lib/data/card.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class Flashcard {

  // ============================================================
  // CORE CATEGORISATION
  // ============================================================

  final List<String> types;
  final List<String> tags;

  // ============================================================
  // IDENTITY + DISPLAY
  // ============================================================

  final String id;
  final String headword;
  final String phonetic;
  final String meaning;
  final String context;
  final String grammarType;
  final String image;

  final String? audio;

  final int? value;

  // ============================================================
  // CATEGORY HELPERS (NORMALISED)
  // ============================================================

  final String drinksType;

  final String hasTypes;

  final String proteinTypes;

  final String sspType;

  final String ipa;
  final String showIndex;

  // ============================================================
  // FOOD INFO (v2.x)
  // ============================================================

  final String infoShortDescription;

  final List<String> whereYouWillSeeIt;
  final List<String> whenItsEaten;
  final List<String> howPeopleUsuallyEatIt;
  final List<String> whyItsPopular;
  final List<String> firstImpressions;
  final List<String> goodToKnow;

  final List<String> infoSpiceLevel;
  final List<String> infoIngredients;
  final String infoPreparation;

  // ============================================================
  // NEW CHEESE DATA FIELDS
  // ============================================================

  final List<String> regionalOrigin;
  final List<String> pairings;
  final List<String> ripeness;

  // ✅ FIXED: PROSE FIELD
  final String production;

  final List<String> storageAndServing;

  /// Raw access if needed
  final Map<String, dynamic>? extra;

  const Flashcard({
    required this.id,
    required this.types,
    this.tags = const [],

    this.headword = '',
    this.phonetic = '',
    this.meaning = '',
    this.context = '',
    this.grammarType = '',
    this.image = '',
    this.audio,

    this.value,

    this.drinksType = '',
    this.hasTypes = '',
    this.proteinTypes = '',
    this.sspType = '',

    this.ipa = '',
    this.showIndex = '',

    this.infoShortDescription = '',

    this.whereYouWillSeeIt = const [],
    this.whenItsEaten = const [],
    this.howPeopleUsuallyEatIt = const [],
    this.whyItsPopular = const [],
    this.firstImpressions = const [],
    this.goodToKnow = const [],

    this.infoSpiceLevel = const [],
    this.infoIngredients = const [],
    this.infoPreparation = '',

    this.regionalOrigin = const [],
    this.pairings = const [],
    this.ripeness = const [],

    // ✅ FIXED DEFAULT
    this.production = '',

    this.storageAndServing = const [],

    this.extra,
  });

  // ============================================================
  // PARSERS
  // ============================================================

  static List<String> _parseTypes(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw.map((e) => e.toString().trim()).toList();
    }
    if (raw is String) {
      final s = raw.trim();
      if (s.startsWith('[') && s.endsWith(']')) {
        try {
          final decoded = jsonDecode(s);
          if (decoded is List) {
            return decoded.map((e) => e.toString().trim()).toList();
          }
        } catch (_) {}
      }
      return s.isNotEmpty ? [s] : [];
    }
    return [];

  }

  static List<String> _parseTags(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    if (raw is String && raw.trim().isNotEmpty) return [raw.trim()];
    return [];
  }

  static List<String> _parseStringList(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw.map((e) => e.toString().trim()).toList();
    }
    return [];
  }

  static List<String> _parseIngredients(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw.map((e) => e.toString().trim()).toList();
    }
    if (raw is String && raw.trim().isNotEmpty) {
      return [raw.trim()];
    }
    return [];
  }

  static int? _asOptInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  // ============================================================
  // FROM JSON (AUTHORITATIVE)
  // ============================================================

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id']?.toString() ?? '',
      types: _parseTypes(json['type']),
      tags: _parseTags(json['tags']),

      headword: json['headword']?.toString()
          ?? json['thai']?.toString()
          ?? json['scottish']?.toString()
          ?? '',

      phonetic: json['phonetic']?.toString() ?? '',
      meaning: json['english']?.toString()
          ?? json['meaning']?.toString()
          ?? '',
      context: json['context']?.toString() ?? '',
      grammarType: json['grammarType']?.toString() ?? '',
      image: json['image']?.toString() ?? '',

      audio: json['audio'] as String?
          ?? json['audioThai'] as String?
          ?? json['audioScottish'] as String?,

      value: _asOptInt(json['value'] ?? json['numeral']),

      drinksType: json['drinksType']?.toString() ?? '',

      hasTypes:
          json['hasTypes']?.toString()
          ?? json['herbsSpicesTypes']?.toString()
          ?? json['aromaticsPastesTypes']?.toString()
          ?? '',

      proteinTypes: json['proteinTypes']?.toString() ?? '',

      sspType:
          json['sspType']?.toString()
          ?? json['condimentsType']?.toString()
          ?? '',

      ipa: json['ipa']?.toString() ?? '',
      showIndex: json['showIndex']?.toString() ?? '',

      infoShortDescription:
          json['short_description']?.toString()
          ?? json['description']?.toString()
          ?? json['infoShortDescription']?.toString()
          ?? '',

      whereYouWillSeeIt:
          _parseStringList(json['where_you_will_see_it']),

      whenItsEaten:
          _parseStringList(json['when_its_eaten']),

      howPeopleUsuallyEatIt:
          _parseStringList(json['how_people_usually_eat_it']),

      firstImpressions:
          _parseStringList(json['first_impressions']),

      goodToKnow:
          _parseStringList(json['good_to_know']),

      infoSpiceLevel:
          _parseStringList(json['infoSpiceLevel']),

      infoIngredients:
          _parseIngredients(json['ingredients']
              ?? json['infoIngredients']),

      infoPreparation:
          json['preparation']?.toString()
          ?? json['infoPreparation']?.toString()
          ?? '',

      regionalOrigin:
          _parseStringList(json['regional_origin']),

      pairings:
          _parseStringList(json['pairings']),

      ripeness:
          _parseStringList(json['ripeness']),

      // ✅ FIXED PARSING
      production: json['production'] is List
          ? (json['production'] as List).join('\n\n')
          : json['production']?.toString() ?? '',

      storageAndServing:
          _parseStringList(json['storage_and_serving']),

      extra: json,
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  String meaningFor(String lang) => meaning;
}