// lib/utils/tag_icon_mapper.dart
// 👉 New file: maps tag strings to icon, colour, and label visuals.

import 'package:flutter/material.dart';

/// 👉 Visual representation of a tag.
/// This keeps icon + colour + label bundled as a single object.
class TagVisual {
  final IconData icon;
  final Color color;
  final String label;

  const TagVisual({
    required this.icon,
    required this.color,
    required this.label,
  });
}

/// 👉 Central mapper for converting tag strings to UI visuals.
/// Currently supports only "local" — safe, minimal, and extendable.
class TagIconMapper {
  // 👉 Primary star colour — Warm Amber (#FFA726)
  static const Color _localColour = Color(0xFFFFA726);

  // 👉 Internal lookup table for known tags
  static const Map<String, TagVisual> _map = {
    'local': TagVisual(
      icon: Icons.star,               // ⭐ identifies local speciality
      color: _localColour,            // AMBER colour
      label: 'Local Speciality',
    ),
  };

  /// 👉 Get full TagVisual for a given tag.
  /// Returns null if the tag is unknown (important for future extensibility).
  static TagVisual? forTag(String tag) {
    return _map[tag];
  }

  /// 👉 Convenience: map a list of tag strings into visuals.
  /// Filters out unknown tags.
  static List<TagVisual> visualsFor(List<String> tags) {
    return tags
        .map((t) => forTag(t))
        .where((v) => v != null)
        .map((v) => v!)
        .toList(growable: false);
  }

  /// 👉 Optional: check if tag is recognised.
  static bool isKnownTag(String tag) => _map.containsKey(tag);
}
