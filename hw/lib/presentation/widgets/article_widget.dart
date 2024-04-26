import 'package:flutter/material.dart';
import 'button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../internal/main_provider.dart';
import '../../data/api_articles.dart';

class ArticleWidget extends StatefulWidget {
  final Map<String?, dynamic> article;
  final bool isLiked;

  const ArticleWidget({
    super.key,
    required this.article,
    required this.isLiked,
  });

  @override
  State<StatefulWidget> createState() => ArticleWidgetState();
}

class ArticleWidgetState extends State<ArticleWidget> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalData>(
      builder: (context, globalData, child) {
        return TweenAnimationBuilder(
          tween: ColorTween(
            begin: isLiked
                ? const Color.fromARGB(255, 255, 255, 255)
                : const Color.fromARGB(255, 251, 162, 94),
            end: isLiked
                ? const Color.fromARGB(255, 251, 162, 94)
                : const Color.fromARGB(255, 255, 255, 255),
          ),
          duration: const Duration(seconds: 1),
          builder: (context, color, child) {
            return Card(
              color: color,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: SizedBox(
                width: 300,
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              20),
                          child: Hero(
                            tag: '${widget.article['title']}',
                            child: getArticleImage(
                                widget.article['urlToImage'] ?? '',
                                widget.article),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Text(
                                widget.article['title'] ?? '',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 13, 13, 13),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: CustomIconButton(
                                    icon: isLiked
                                        ? CupertinoIcons.add_circled_solid
                                        : CupertinoIcons.add_circled,
                                    text: "",
                                    activeColor:
                                        const Color.fromARGB(255, 0, 47, 255),
                                    onPressed: () {
                                      setState(() {
                                        isLiked = !isLiked;
                                        globalData.toggleLike(
                                            widget.article, isLiked);
                                      });
                                    })),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
