import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/src/core/get_it.dart';
import 'package:test_app/src/feature/news/models/news_model.dart';
import 'package:test_app/src/feature/news/repository/repository.dart';
import 'package:test_app/src/core/utils/log.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository newsRepository = getIt<NewsRepository>();
  List<News> allNews = []; // Полный список новостей для поиска

  NewsBloc() : super(NewsInitial()) {
    on<FetchNews>(_onFetchNews);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<SearchNews>(_onSearchNews);
  }

  Future<void> _onFetchNews(FetchNews event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final newsList = await newsRepository.getNewsByCategory(event.category);
      final favorites = await newsRepository.getFavoriteNews();
      allNews = newsList; // Сохраняем полный список новостей
      emit(NewsLoaded(newsList: newsList, favorites: favorites));
    } catch (e) {
      logger.e(e.toString());
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<NewsState> emit,
  ) async {
    try {
      await newsRepository.addNewsToFavorites(event.news);
      final favorites = await newsRepository.getFavoriteNews();
      if (state is NewsLoaded) {
        emit(
          NewsLoaded(
            newsList: (state as NewsLoaded).newsList,
            favorites: favorites,
          ),
        );
      }
    } catch (e) {
      logger.e(e.toString());
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<NewsState> emit,
  ) async {
    try {
      await newsRepository.removeNewsFromFavorites(event.news);
      final favorites = await newsRepository.getFavoriteNews();
      if (state is NewsLoaded) {
        emit(
          NewsLoaded(
            newsList: (state as NewsLoaded).newsList,
            favorites: favorites,
          ),
        );
      }
    } catch (e) {
      logger.e(e.toString());
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _onSearchNews(SearchNews event, Emitter<NewsState> emit) async {
    if (state is NewsLoaded) {
      final filteredNews = allNews
          .where(
            (news) =>
                news.title.toLowerCase().contains(event.query.toLowerCase()),
          )
          .toList();

      emit(
        NewsLoaded(
          newsList: filteredNews,
          favorites: (state as NewsLoaded).favorites,
        ),
      );
    }
  }
}
