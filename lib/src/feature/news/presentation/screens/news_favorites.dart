import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:test_app/src/core/utils/network_helper.dart';
import 'package:test_app/src/feature/news/bloc/news_bloc.dart';
import 'package:test_app/src/feature/news/presentation/widgets/news_tile.dart';
import 'package:test_app/src/feature/news/theme/theme.dart';

class NewsFavorites extends StatefulWidget {
  const NewsFavorites({super.key});

  @override
  State<NewsFavorites> createState() => _NewsFavoritesState();
}

class _NewsFavoritesState extends State<NewsFavorites> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: NetworkHelper.isConnected().asStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                color: NewsTheme.color.unselectedFilter,
                borderRadius: BorderRadius.circular(27),
              ),
              child: const CupertinoActivityIndicator(),
            ),
          );
        }
        if (snapshot.data == false) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No internet connection',
                style: NewsTheme.text.detailedTitle,
              ),
              TextButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text(
                  'Try again',
                  style:
                      NewsTheme.text.detailedTitle.copyWith(color: Colors.blue),
                ),
              ),
            ],
          );
        } else {
          return BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              return state is NewsLoaded
                  ? state.favorites.isEmpty
                      ? Center(
                          child: Text(
                            'No favorites',
                            style: NewsTheme.text.detailedTitle,
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(19, 35, 19, 195),
                          itemCount: state.favorites.length,
                          shrinkWrap: true,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Gap(16),
                          itemBuilder: (BuildContext context, int index) =>
                              NewsTile(
                            news: state.favorites[index],
                            isFavorite: true,
                            isFavoriteScreen: true,
                          ),
                        )
                  : const Center(child: CircularProgressIndicator());
            },
          );
        }
      },
    );
  }
}
