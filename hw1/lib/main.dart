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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                IconButton(
                  icon: Icon(
                    isLightOn ? CupertinoIcons.clock_solid : CupertinoIcons.clock,
                    size: 30,
                    color: isLightOn ? const Color.fromARGB(255, 81, 190, 79) : Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: (articles.isEmpty)
            ? const CircularProgressIndicator()
            : GridView.custom(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                crossAxisSpacing: 15,
                mainAxisSpacing: 30,
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                (context, index) {
                  //maxCrossAxisExtent: (index % 5 == 0) ? 400 : 200;
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
                      width: (index % 5 == 0) ? 400 : 200,
                      child: ArticleWidget(article: articles[index], isLightOn: isLightOn),
                    ),
                  );
                },
                childCount: articles.length,
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: isLightOn ? Colors.white : Colors.black,
            child: SizedBox(
              height: 70.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Column(
                      children: <Widget>[
                        Icon(isLightOn ? CupertinoIcons.person_solid : CupertinoIcons.person, size: 23, color: isLightOn ? const Color.fromARGB(255, 81, 190, 79) : Colors.white),
                        Text(
                          'Домой',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isLightOn ? const Color.fromARGB(255, 81, 190, 79) : const Color.fromARGB(255, 247, 247, 247), 
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Column(
                      children: <Widget>[
                        Icon(isLightOn ? CupertinoIcons.book_solid : CupertinoIcons.book, size: 23, color: isLightOn ? const Color.fromARGB(255, 81, 190, 79) : Colors.white),
                        Text(
                          'История',
                          style: TextStyle(
                            color: isLightOn ? const Color.fromARGB(255, 81, 190, 79) : const Color.fromARGB(255, 247, 247, 247),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Column(
                      children: <Widget>[
                        Icon(isLightOn ? CupertinoIcons.clock_solid : CupertinoIcons.clock, size: 23, color: isLightOn ? const Color.fromARGB(255, 81, 190, 79) : Colors.white),
                        Text(
                          'Тема',
                          style: TextStyle(
                            color: isLightOn ? const Color.fromARGB(255, 81, 190, 79) : const Color.fromARGB(255, 247, 247, 247), // устанавливаем цвет текста
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        isLightOn = !isLightOn;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
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

@immutable
class ArticleWidget extends StatelessWidget {
  final Map<String?, dynamic> article;
  final bool isLightOn;

  ArticleWidget({required this.article, required this.isLightOn});
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      article['title'] ?? '',
                      style: TextStyle(
                        color: isLightOn ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
