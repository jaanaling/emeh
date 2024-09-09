part of 'news_bloc.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<News> newsList;
  final List<News> favorites;

  NewsLoaded({required this.newsList, required this.favorites});
}

class NewsError extends NewsState {
  final String error;

  NewsError(this.error);
}

class FavoritesError extends NewsState {
  final String error;

  FavoritesError(this.error);
}
