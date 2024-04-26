import 'package:flutter/material.dart';
import '../widgets/top_app_bar_widget.dart';
import 'article_detail_screen.dart';
import '../widgets/article_widget.dart';
import '../widgets/recent_article_widget.dart';
import '../widgets/bottom_app_bar_widget.dart';

Route _createRoute({required WidgetBuilder builder}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset(0.0, 0.0);
      const curve = Curves.decelerate;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

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
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    _createRoute(
                      builder: (context) =>
                          ArticleDetailScreen(article: filteredArticles[index]),
                    ),
                  );
                },
                child: SizedBox(
                  width: 300,
                  height: 150,
                  child: ArticleWidget(
                    article: filteredArticles[index],
                    isLiked: false,
                  ),
                ),
              );
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        _createRoute(
                          builder: (context) => ArticleDetailScreen(
                              article: recentArticles[index]),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        width: 300,
                        height: 250,
                        child: RecentArticleWidget(
                          article: recentArticles[index],
                          isLiked: false,
                        ),
                      ),
                    )),
              );
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
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    _createRoute(
                      builder: (context) =>
                          ArticleDetailScreen(article: articles[index]),
                    ),
                  );
                },
                child: SizedBox(
                  width: 300,
                  height: 150,
                  child: ArticleWidget(
                    article: articles[index],
                    isLiked: false,
                  ),
                ),
              );
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
