import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:test_app/src/core/utils/network_helper.dart';
import 'package:test_app/src/feature/news/bloc/news_bloc.dart';
import 'package:test_app/src/feature/news/models/category_model.dart';
import 'package:test_app/src/feature/news/presentation/widgets/category_tile.dart';
import 'package:test_app/src/feature/news/presentation/widgets/news_tile.dart';
import 'package:test_app/src/feature/news/theme/theme.dart';
import 'package:test_app/src/feature/news/utils/news_helper.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onTap(int index, BuildContext context) {
    setState(() {
      if (NewsHelper.selectedIndex == index) {
        NewsHelper.selectedIndex = -1;
      } else {
        NewsHelper.selectedIndex = index;
      }
    });

    _scrollToSelectedIndex(index);

    context.read<NewsBloc>().add(
          FetchNews(
            category: NewsHelper.selectedIndex == -1
                ? ''
                : Category.categories[index].name,
          ),
        );
    NewsHelper.controller.clear();

    // Прокручиваем список до выбранного элемента
  }

  void _scrollToSelectedIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const itemWidth = 100.0;
      final offset = index * (itemWidth + 7.0);

      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (NewsHelper.selectedIndex != null && NewsHelper.selectedIndex != -1) {
      _scrollToSelectedIndex(NewsHelper.selectedIndex!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          child: CupertinoTextField(
            style: NewsTheme.text.detailedDate,
            decoration: BoxDecoration(
              color: NewsTheme.color.cardColor,
              borderRadius: BorderRadius.circular(13),
            ),
            controller: NewsHelper.controller,
            keyboardType: TextInputType.text,
            placeholder: 'Search',
            textInputAction: TextInputAction.search,
            clearButtonMode: OverlayVisibilityMode.editing,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            prefix: IconButton(
              onPressed: () => context.read<NewsBloc>().add(
                    SearchNews(query: NewsHelper.controller.text.trim()),
                  ),
              icon: const Icon(Icons.search, size: 32),
              iconSize: 32,
              color: NewsTheme.color.icon,
            ),
            onChanged: (value) {
              context.read<NewsBloc>().add(
                    SearchNews(query: value),
                  );
            },
          ),
        ),
        const Gap(34),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.055,
          child: ListView.separated(
            itemCount: Category.categories.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 19),
            controller: _scrollController,
            separatorBuilder: (BuildContext context, int index) => const Gap(7),
            itemBuilder: (BuildContext context, int index) => CategoryTile(
              category: Category.categories[index].name,
              isSelected: NewsHelper.selectedIndex == index,
              onTap: onTap,
              index: index,
            ),
          ),
        ),
        const Gap(22),
        ValueListenableBuilder(
          valueListenable: NetworkHelper.isConnected,
          builder: (context, value, child) {
            return StreamBuilder<bool>(
                stream: NetworkHelper.connected().asStream(),
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
                    return Center(
                      child: Column(
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
                              style: NewsTheme.text.detailedTitle
                                  .copyWith(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return BlocBuilder<NewsBloc, NewsState>(
                      builder: (context, state) {
                        return state is NewsLoaded
                            ? Expanded(
                                child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                    bottom: 160,
                                    left: 19,
                                    right: 19,
                                  ),
                                  itemCount: state.newsList.length,
                                  shrinkWrap: true,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Gap(16),
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          NewsTile(
                                    news: state.newsList[index],
                                    isFavorite: state.favorites
                                        .contains(state.newsList[index]),
                                  ),
                                ),
                              )
                            : const Center(child: CircularProgressIndicator());
                      },
                    );
                  }
                });
          },
        )
      ],
    );
  }
}
