import 'package:flutter/material.dart';
import '../widgets/top_app_bar_widget.dart';
import '../screens/article_detail_screen.dart';
import '../widgets/article_widget.dart';
import '../widgets/recent_article_widget.dart';
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

Widget listArticles(BuildContext context, List<Map<String?, dynamic>> recentArticles, int index, double height, bool isList) {
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
          height: height,
          child: isList ? ArticleWidget(
            article: recentArticles[index],
            isLiked: false,
          ) : RecentArticleWidget(
            article: recentArticles[index], 
            isLiked: false),
        ),
      )),
  );
}