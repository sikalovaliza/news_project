import 'package:flutter/material.dart';
import '../widgets/article_widget.dart';
import 'package:provider/provider.dart';
import 'article_detail_screen.dart';
import '../../internal/main_provider.dart';

class LikedNewsPage extends StatefulWidget {
  final Function() toggleTheme;
  final GlobalKey<NavigatorState> navigatorKey;

  const LikedNewsPage(
      {super.key, required this.toggleTheme, required this.navigatorKey});

  @override
  // ignore: library_private_types_in_public_api
  _LikedNewsPageState createState() => _LikedNewsPageState();
}

class _LikedNewsPageState extends State<LikedNewsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalData>(
      builder: (context, globalData, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                widget.navigatorKey.currentState!.pop();
              },
            ),
          ),
          body: ListView.builder(
            primary: false,
            itemCount: globalData.likedArticles.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(
                          article: globalData.likedArticles[index]),
                    ),
                  );
                },
                child: SizedBox(
                  width: 300,
                  height: 150,
                  child: ArticleWidget(
                    article: globalData.likedArticles[index],
                    isLiked: true,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
