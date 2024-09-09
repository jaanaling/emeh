import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/src/feature/news/models/news_model.dart';

class SharedPrefsHelper {
  static const String _favoritesKey = 'favorites';

  Future<void> saveToFavorites(News news) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    if (!favorites.contains(jsonEncode(news.toJson()))) {
      favorites.add(jsonEncode(news.toJson()));
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  Future<void> removeFromFavorites(News news) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    favorites.removeWhere((item) => item == jsonEncode(news.toJson()));
    await prefs.setStringList(_favoritesKey, favorites);
  }

  Future<List<News>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];

    return favorites
        .map((item) => News.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }
}
