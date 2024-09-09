part of 'news_bloc.dart';

abstract class NewsEvent {}

class FetchNews extends NewsEvent {
  final String category;

  FetchNews({required this.category});
}

class AddToFavorites extends NewsEvent {
  final News news;

  AddToFavorites(this.news);
}

class RemoveFromFavorites extends NewsEvent {
  final News news;

  RemoveFromFavorites(this.news);
}

class SearchNews extends NewsEvent {
  final String query;

  SearchNews({required this.query});
}
