import 'package:flutter/material.dart';
import 'ButtonWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../internal/Provider.dart';
import '../../data/ApiArticles.dart';
import 'package:flutter_test/flutter_test.dart';

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
        return Card(
          color: const Color.fromARGB(255, 0, 0, 0),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                  offset: const Offset(0, 5),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: getArticleImage(
                      widget.article['urlToImage'] ?? '', widget.article),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Text(
                            widget.article['title'] ?? '',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
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
                                    const Color.fromARGB(255, 81, 190, 79),
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
  }
}
