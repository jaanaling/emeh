import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/src/core/utils/log.dart';
import 'package:test_app/src/feature/news/bloc/news_bloc.dart';
import 'package:test_app/src/feature/news/models/news_model.dart';
import 'package:test_app/src/feature/news/theme/theme.dart';
import 'package:test_app/src/ui_kit/custom_snack_bar/custom_snack_bar.dart';

class NewsDetailedScreen extends StatefulWidget {
  final News news;
  final bool isFavorite;

  const NewsDetailedScreen({
    super.key,
    required this.news,
    required this.isFavorite,
  });

  @override
  State<NewsDetailedScreen> createState() => _NewsDetailedScreenState();
}

class _NewsDetailedScreenState extends State<NewsDetailedScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 160),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                color: NewsTheme.color.icon,
                iconSize: 28,
              ),
              IconButton(
                onPressed: () => setState(() {
                  logger.d(widget.news.title);
                  _isFavorite
                      ? context
                          .read<NewsBloc>()
                          .add(RemoveFromFavorites(widget.news))
                      : context
                          .read<NewsBloc>()
                          .add(AddToFavorites(widget.news));
                  _isFavorite
                      ? showCustomSnackBar(
                          context,
                          'News removed from favorites',
                        )
                      : showCustomSnackBar(
                          context,
                          'News added to favorites',
                        );
                  _isFavorite = !_isFavorite;
                }),
                icon: Icon(
                  _isFavorite ? Icons.star : Icons.star_border,
                  color: NewsTheme.color.icon,
                ),
                iconSize: 43,
              ),
            ],
          ),
          Column(
            children: [
              Text(widget.news.title, style: NewsTheme.text.detailedTitle),
              const Gap(4),
              Text(
                widget.news.description,
                style: NewsTheme.text.detailedSubtitle,
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.news.source,
                      style: NewsTheme.text.detailedDate,
                    ),
                  ),
                  Text(
                    widget.news.publishedAt,
                    style: NewsTheme.text.detailedDate,
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(27),
                child: Image.network(
                  widget.news.urlToImage,
                  fit: BoxFit.cover,
                ),
              ),
              const Gap(18),
              Text(
                widget.news.content,
                style: NewsTheme.text.detailedDescription,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
