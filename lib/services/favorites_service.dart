import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService extends ChangeNotifier {
  static const String _storageKey = 'favorite_item_ids';

  final Set<String> _favoriteIds = <String>{};

  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  bool isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final storedIds = prefs.getStringList(_storageKey) ?? <String>[];

    _favoriteIds
      ..clear()
      ..addAll(storedIds);

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }

    notifyListeners();
    await _save();
  }

  Future<void> setFavorite(String id, bool value) async {
    if (value) {
      _favoriteIds.add(id);
    } else {
      _favoriteIds.remove(id);
    }

    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, _favoriteIds.toList()..sort());
  }
}