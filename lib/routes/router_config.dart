import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/routes/root_screen.dart';
import 'package:test_app/routes/route_value.dart';
import 'package:test_app/src/core/theme/a_colors.dart';
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
          return slideTransition(
            context: context,
            state: state,
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
                path: RouteValue.news.path,
                pageBuilder: (context, state) => slideTransition(
                  context: context,
                  state: state,
                  child: NewsScreen(key: UniqueKey()),
                ),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _newsNavigatorKey,
                    path: RouteValue.detailed.path,
                    name: RouteValue.detailed.name,
                    pageBuilder: (context, state) {
                      final extra = state.extra! as Map<String, dynamic>;
                      final isFavorite = extra['isFavorite'] as bool;
                      final news = extra['news'] as News;

                      logger.d(news.title);
                      logger.d(isFavorite);

                      return slideTransition(
                        context: context,
                        state: state,
                        child: NewsDetailedScreen(
                          key: UniqueKey(),
                          news: news,
                          isFavorite: isFavorite,
                        ),
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
                pageBuilder: (context, state) => slideTransition(
                  context: context,
                  state: state,
                  child: NewsFavorites(key: UniqueKey()),
                ),
                routes: [
                  GoRoute(
                    parentNavigatorKey: _favoritesNavigatorKey,
                    path: RouteValue.detailed.path, // Sub-route without '/'
                    pageBuilder: (context, state) {
                      final extra = state.extra! as Map<String, dynamic>;
                      final isFavorite = extra['isFavorite'] as bool;
                      final news = extra['news'] as News;

                      logger.d(news.title);
                      logger.d(isFavorite);

                      return slideTransition(
                        context: context,
                        state: state,
                        child: NewsDetailedScreen(
                          key: UniqueKey(),
                          news: news,
                          isFavorite: isFavorite,
                        ),
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

Page slideTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    child: child,
    key: state.pageKey,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return Stack(
        
        children: [
           Positioned.fill(
            child: ColoredBox(
              color: CupertinoColors.lightBackgroundGray,
              child:  child,
            ),

          ),
         
        ],
      );
    },
    transitionDuration: const Duration(
      milliseconds: 500,
    ),
  );
}
