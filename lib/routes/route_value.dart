enum RouteValue {
  splash(
    path: '/',
    screenName: 'SplashScreen',
  ),
  news(
    path: '/news',
    screenName: 'NewsScreen',
  ),
  favorites(
    path: '/favorites',
    screenName: 'NewsFavoritesScreen',
  ),
  detailed(
    path: 'detailed',
    screenName: 'NewsDetailedScreen',
  ),

  unknown(
    path: '',
    screenName: 'Unknown',
  );

  final String path;
  final String screenName;

  const RouteValue({
    required this.path,
    required this.screenName,
  });
}
