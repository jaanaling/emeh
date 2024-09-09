import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/routes/route_value.dart';
import 'package:test_app/src/feature/news/bloc/news_bloc.dart';
import 'package:test_app/src/feature/news/models/news_model.dart';
import 'package:test_app/src/feature/news/theme/theme.dart';
import 'package:test_app/src/ui_kit/custom_snack_bar/custom_snack_bar.dart';

class NewsTile extends StatelessWidget {
  final News news;
  final bool isFavorite;
  final bool isFavoriteScreen;

  const NewsTile({
    super.key,
    required this.news,
    required this.isFavorite,
    this.isFavoriteScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        RouteValue.detailed.name,
        extra: {'news': news, 'isFavorite': isFavorite},
      ),
      child: Card(
        elevation: 2,
        color: NewsTheme.color.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.146,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13),
                  bottomLeft: Radius.circular(13),
                ),
                child: Image.network(
                  news.urlToImage,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.34,
                  height: MediaQuery.of(context).size.height * 0.146,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.34,
                      height: MediaQuery.of(context).size.height * 0.146,
                      decoration: BoxDecoration(
                        color: NewsTheme.color.unselectedFilter,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(13),
                          bottomLeft: Radius.circular(13),
                        ),
                      ),
                      child: const CupertinoActivityIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.34,
                      height: MediaQuery.of(context).size.height * 0.146,
                      decoration: BoxDecoration(
                        color: NewsTheme.color.unselectedFilter,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(13),
                          bottomLeft: Radius.circular(13),
                        ),
                      ),
                      child: const Icon(Icons.error, color: Colors.red),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              news.title,
                              style: NewsTheme.text.cardTitle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isFavoriteScreen)
                            IconButton(
                              icon: const Icon(Icons.star, size: 32),
                              onPressed: () {
                                context
                                    .read<NewsBloc>()
                                    .add(RemoveFromFavorites(news));
                                showCustomSnackBar(
                                  context,
                                  'News removed from favorites',
                                );
                              },
                              color: NewsTheme.color.icon,
                            ),
                        ],
                      ),
                      Text(
                        news.description,
                        maxLines: 2,
                        style: NewsTheme.text.cardSubtitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          news.publishedAt,
                          style: NewsTheme.text.detailedDate,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
