import 'package:flutter/material.dart';
import '../widgets/TopAppBarWidget.dart';
import 'ArticleDetailScreen.dart';
import '../widgets/ArticleWidget.dart';
import '../widgets/BottomAppBarWidget.dart';

Widget Home(BuildContext context, List<Map<String?, dynamic>> articles,
    void Function() toggleTheme, final GlobalKey<NavigatorState> navigatorKey) {
  return Scaffold(
    appBar: TopAppBarWidget(context),
    body: Center(
      child: (articles.isEmpty)
          ? const CircularProgressIndicator()
          : ListView.builder(
              primary: false,
              itemCount: articles.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArticleDetailScreen(article: articles[index]),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 400,
                    height: 400,
                    child: ArticleWidget(
                      article: articles[index],
                      isLiked: false,
                    ),
                  ),
                );
              }),
    ),
    bottomNavigationBar:
        buildBottomNavigationBar(context, toggleTheme, navigatorKey),
  );
}
