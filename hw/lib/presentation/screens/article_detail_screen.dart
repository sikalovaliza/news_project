import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Image getArticleImage(String? urlToImage, Map<String?, dynamic> article) {
  try {
    return Image.network(
      article['urlToImage'] ??
          'https://img.freepik.com/free-photo/hot-news-announcement-broadcast-article-concept_53876-120611.jpg?t=st=1709834263~exp=1709837863~hmac=36eaeec1162b6b79e146c8ff91a27b228713fd91e115556ba7ef5eecb5e7cb8b&w=1380',
      width: double.infinity,
      fit: BoxFit.cover,
    );
  } catch (e) {
    if (e.toString() == '[object ProgressEvent]') {
      return Image.asset('../../pic/apple.jpg',
          width: double.infinity, fit: BoxFit.cover);
    } else {
      return Image.asset('../../pic/apple.jpg',
          width: double.infinity, fit: BoxFit.cover);
    }
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final Map<String?, dynamic> article;

  void _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    }
  }

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: const Color.fromARGB(211, 38, 64, 179),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.zero,
                  child: Hero(
                    tag: '${article['title']}',
                    child: getArticleImage(article['urlToImage'], article),
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  article['title'] ?? 'Новость',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 247, 247, 247),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  article['description'] ?? '',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 247, 247, 247),
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  article['content'] ?? '',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 247, 247, 247),
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 247, 247, 247)),
                  ),
                  onPressed: () {
                    _launchURL(article['url']);
                  },
                  child: const Text('Перейти к статье'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
