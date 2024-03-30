import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsApp extends StatefulWidget {
  @override
  NewsAppState createState() => NewsAppState();
}

class NewsAppState extends State<NewsApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  
  List<Map<String?, dynamic>> articles = [];
  bool isLightOn = false;
  int number = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const apiKey = 'a592096d6ab14973ab15f4937ce4ffde';
    const url = 'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        articles = List<Map<String?, dynamic>>.from(json.decode(response.body)['articles']);
      });
    } else {
      print('Failed to retrieve news data!');
    }
  }
  
    List<Map<String?, dynamic>> likedArticles = [];

  void toggleLike(Map<String?, dynamic> article, bool isLiked) {
    setState(() {
      if (isLiked) {
        likedArticles.add(article);
      } else {
        if (likedArticles.contains(article)) {
          likedArticles.remove(article);
        }
      }
      print(likedArticles);
    });
  }

 final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: isLightOn ? Colors.white : Colors.black,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Моя лента',
                  style: TextStyle(
                    color: isLightOn ? const Color.fromARGB(255, 81, 190, 79) : const Color.fromARGB(255, 247, 247, 247),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomIconButton(
                  icon: CupertinoIcons.clock_solid, 
                  text: null,
                  isLightOn: isLightOn,
                  activeColor: const Color.fromARGB(255, 81, 190, 79),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
        body: Center(
          child: (articles.isEmpty)
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: articles.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isLiked = likedArticles.contains(articles[index]);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailScreen(article: articles[index], isLightOn: isLightOn),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 400,
                      height: 400,
                      child: ArticleWidget(
                        article: articles[index], 
                        isLightOn: isLightOn, 
                        isLiked: isLiked, 
                        onLikePressed: toggleLike
                      ),
                    ),
                  );
                }
              ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: isLightOn ? Colors.white : Colors.black,
          child: SizedBox(
            height: 70.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomIconButton(
                  icon: CupertinoIcons.person_solid,
                  text: 'Домой',
                  isLightOn: isLightOn,
                  activeColor: const Color.fromARGB(255, 81, 190, 79),
                  onPressed: () {},
                ),
                CustomIconButton(
                  icon: CupertinoIcons.book_solid,
                  text: 'История',
                  isLightOn: isLightOn,
                  activeColor: const Color.fromARGB(255, 81, 190, 79),
                  onPressed: () {
                    navigatorKey.currentState!.push(MaterialPageRoute(
                      builder: (context) => LikedNewsPage(likedArticles: likedArticles),
                    ));
                  },
                ),
                CustomIconButton(
                  icon: CupertinoIcons.book_solid,
                  text: 'Тема',
                  isLightOn: isLightOn,
                  activeColor: const Color.fromARGB(255, 81, 190, 79),
                  onPressed: toggleTheme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LikedNewsPage extends StatelessWidget {
  final List<Map<String?, dynamic>> likedArticles;

  LikedNewsPage({Key? key, required this.likedArticles}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: likedArticles.length,
        itemBuilder: (BuildContext context, index) {
          child: SizedBox (
            width: 400,
            height: 400,
           child: Text(
            likedArticles[index]['title'],
           ),
            /*child: ArticleWidget(
              article: widget.likedArticles[index],
              isLightOn: true,
              isLiked: true,
              onLikePressed: toggleLike,
            ),*/
          );
        },
      ),
    );
  }

  //@override
  //_LikedNewsPageState createState() => _LikedNewsPageState();
}

/*class _LikedNewsPageState extends State<LikedNewsPage> {
  void toggleLike(Map<String?, dynamic> article, bool isLiked) {
    if (isLiked) {
      widget.likedArticles.add(article);
    } else {
      if (widget.likedArticles.contains(article)) {
        widget.likedArticles.remove(article);
      }
    }
    setState(() {}); // Перерисовываем виджет после обновления списка likedArticles
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.likedArticles.length,
        itemBuilder: (BuildContext context, index) {
          child: SizedBox (
            width: 400,
            height: 400,
           child: Text(
            widget.likedArticles[index]['title'],
           ),
            /*child: ArticleWidget(
              article: widget.likedArticles[index],
              isLightOn: true,
              isLiked: true,
              onLikePressed: toggleLike,
            ),*/
          );
        },
      ),
    );
  }
}*/


class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final String? text;
  final bool isLightOn;
  final Color activeColor;
  final Function()? onPressed;
  final Key? key;


  const CustomIconButton({
    required this.icon,
    required this.text,
    required this.isLightOn,
    required this.activeColor,
    this.onPressed,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Column(
        children: <Widget>[
          Icon(
            isLightOn ? icon : icon, 
            size: 23, 
            color: activeColor,
          ),
          Text(
            text ?? "",
            style: TextStyle(
              color: activeColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}




Image getArticleImage(String? urlToImage, Map<String?, dynamic> article) {
  try {
    return Image.network(
      article['urlToImage'] ?? 'https://img.freepik.com/free-photo/hot-news-announcement-broadcast-article-concept_53876-120611.jpg?t=st=1709834263~exp=1709837863~hmac=36eaeec1162b6b79e146c8ff91a27b228713fd91e115556ba7ef5eecb5e7cb8b&w=1380',
      width: double.infinity,
      fit: BoxFit.cover,
    );
  } catch (e) {
    if (e.toString() == '[object ProgressEvent]') {
      return Image.asset('../../pic/apple.jpg', width: double.infinity, fit: BoxFit.cover);
    } else {
      return Image.asset('../../pic/apple.jpg', width: double.infinity, fit: BoxFit.cover);
    }
  }
}


typedef void OnLikeCallback(Map<String?, dynamic> article, bool isLiked);

class ArticleWidget extends StatelessWidget {

  final Map<String?, dynamic> article;
  final bool isLightOn;
  bool isLiked;
  final OnLikeCallback onLikePressed;


  ArticleWidget({
    Key? key, 
    required this.article, 
    required this.isLightOn, 
    required this.isLiked,
     required this.onLikePressed
  }) : super(key: key);

    @override
  Widget build(BuildContext context) {
    return Card(
      color: isLightOn ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: isLightOn ? const Color.fromARGB(255, 172, 241, 170).withOpacity(0.3) : const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
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
              child: getArticleImage(article['urlToImage'], article),
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
                        article['title'] ?? '',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: CustomIconButton(
                        icon: isLiked ? CupertinoIcons.create_solid : CupertinoIcons.create,
                        text: "",
                        isLightOn: isLightOn,
                        activeColor: const Color.fromARGB(255, 81, 190, 79),
                        onPressed: () {
                          onLikePressed(article, !isLiked);
                        }
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




@immutable
class ArticleDetailScreen extends StatelessWidget {
  final Map<String?, dynamic> article;
  final bool isLightOn;

  void _launchURL(String url) async {
      if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Не удается открыть URL: $url';
    }

  }

  ArticleDetailScreen({required this.article, required this.isLightOn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: isLightOn ? const Color.fromARGB(255, 81, 190, 79) : Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: isLightOn ? Colors.white : const Color.fromARGB(255, 0, 0, 0),
      ),
      backgroundColor: isLightOn ? Colors.white : const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: SingleChildScrollView(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.zero,
                child: getArticleImage(article['urlToImage'], article),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  article['title'] ?? 'Новость',
                  style: TextStyle(
                    color: isLightOn ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 247, 247, 247), // устанавливаем цвет текста
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  article['description'] ?? '',
                  style: TextStyle(
                    color: isLightOn ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 247, 247, 247),
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  article['content'] ?? '',
                  style: TextStyle(
                    color: isLightOn ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 247, 247, 247),
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(isLightOn ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 247, 247, 247)),
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


void main() {
  runApp(NewsApp());
}
