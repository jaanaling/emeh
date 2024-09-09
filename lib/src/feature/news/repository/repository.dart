import 'package:dio/dio.dart';
import 'package:test_app/src/core/constants/app_constants.dart';
import 'package:test_app/src/feature/news/models/news_model.dart';
import 'package:test_app/src/core/utils/log.dart';
import 'package:test_app/src/core/utils/shared_prefs_helper.dart';

class NewsRepository {
  final Dio _dio = Dio();
  final SharedPrefsHelper _prefsHelper = SharedPrefsHelper();

  Future<List<News>> getNewsByCategory(String category) async {
    final response = await _dio.get(
      '${Constants.baseUrl}/top-headlines',
      queryParameters: {
        'category': category,
        'apiKey': Constants.apiKey, 
         'country': 'us',
      },
    );

    if (response.statusCode == 200) {
      final data = response.data['articles'] as List;
      return data
          .map((article) => News.fromJson(article as Map<String, dynamic>))
          .toList();
    } else {
      logger.e('Failed to load news');
      throw Exception('Failed to load news');
    }
  }

  Future<void> addNewsToFavorites(News news) async {
    try {
      await _prefsHelper.saveToFavorites(news);
      logger.i('News added to favorites');
    } on Exception catch (e) {
      logger.e(e.toString());
      throw Exception('Failed to add news to favorites');
    }
  }

  Future<void> removeNewsFromFavorites(News news) async {
    try {
      await _prefsHelper.removeFromFavorites(news);
      logger.i('News removed from favorites');
    } on Exception catch (e) {
      logger.e(e.toString());
      throw Exception('Failed to remove news from favorites');
    }
  }

  Future<List<News>> getFavoriteNews() async {
    try {
      return await _prefsHelper.getFavorites();
    } on Exception catch (e) {
      logger.e(e.toString());
      throw Exception('Failed to get favorite news');
    }
  }
}
