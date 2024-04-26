import 'package:flutter/material.dart';
import '../widgets/top_app_bar_widget.dart';
import '../widgets/bottom_app_bar_widget.dart';
import '../widgets/list_of_news.dart';

Widget home(
    BuildContext context,
    List<Map<String?, dynamic>> articles,
    List<Map<String?, dynamic>> recentArticles,
    List<Map<String?, dynamic>> filteredArticles,
    void Function() toggleTheme,
    void Function() toggleSearch,
    void Function(String) searchByTitle,
    bool isSearch,
    final GlobalKey<NavigatorState> navigatorKey) {
  List<SliverPadding> actions = [];
  if (isSearch) {
    actions.add(
      SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return listArticles(context, filteredArticles, index, 150, true);
            },
            childCount: filteredArticles.length,
          ),
        ),
      ),
    );
  } else {
    actions.add(
      SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300.0,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            childAspectRatio: 0.75,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return listArticles(context, recentArticles, index, 250, false);
            },
            childCount: recentArticles.length,
          ),
        ),
      ),
    );
    actions.add(
      SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return listArticles(context, articles, index, 150, true);
            },
            childCount: articles.length,
          ),
        ),
      ),
    );
  }
  return Scaffold(
    appBar: TopAppBarWidget(context, isSearch, toggleSearch, searchByTitle),
    body: CustomScrollView(
      slivers: actions,
    ),
    bottomNavigationBar:
        buildBottomNavigationBar(context, toggleTheme, navigatorKey),
  );
}
