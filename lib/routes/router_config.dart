import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/routes/root_screen.dart';
import 'package:test_app/routes/route_value.dart';
import 'package:test_app/src/core/utils/log.dart';
import 'package:test_app/src/feature/news/models/news_model.dart';
import 'package:test_app/src/feature/news/presentation/screens/news_detailed_screen.dart';
import 'package:test_app/src/feature/news/presentation/screens/news_favorites.dart';
import 'package:test_app/src/feature/news/presentation/screens/news_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _newsNavigatorKey = GlobalKey<NavigatorState>();
final _favoritesNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteValue.news.path,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) {
          return NoTransitionPage(
            child: RootScreen(
              navigationShell: navigationShell,
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _newsNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: RouteValue.news.path, // Top-level route starts with '/'
                builder: (context, state) => NewsScreen(key: UniqueKey()),
                routes: [
                  GoRoute(
                    path: RouteValue.detailed.path, // Sub-route without '/'
                    name: RouteValue.detailed.name,
                    builder: (context, state) {
                      final extra = state.extra! as Map<String, dynamic>;
                      final isFavorite = extra['isFavorite'] as bool;
                      final news = extra['news'] as News;

                      logger.d(news.title);
                      logger.d(isFavorite);

                      return NewsDetailedScreen(
                        key: UniqueKey(),
                        news: news,
                        isFavorite: isFavorite,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _favoritesNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: RouteValue
                    .favorites.path, // Top-level route starts with '/'
                builder: (context, state) => NewsFavorites(key: UniqueKey()),
                routes: [
                  GoRoute(
                    path: RouteValue.detailed.path, // Sub-route without '/'
                    builder: (context, state) {
                      final extra = state.extra! as Map<String, dynamic>;
                      final isFavorite = extra['isFavorite'] as bool;
                      final news = extra['news'] as News;

                      logger.d(news.title);
                      logger.d(isFavorite);

                      return NewsDetailedScreen(
                        key: UniqueKey(),
                        news: news,
                        isFavorite: isFavorite,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
