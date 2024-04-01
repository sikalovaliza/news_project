import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'internal/Provider.dart';
import 'presentation/screens/Home.dart';

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  NewsAppState createState() => NewsAppState();
}

class NewsAppState extends State<NewsApp> {
  bool isDarkMode = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  List<Map<String?, dynamic>> articles = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const apiKey = 'a592096d6ab14973ab15f4937ce4ffde';
    const url =
        'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        articles = List<Map<String?, dynamic>>.from(
            json.decode(response.body)['articles']);
      });
    } else {
      print('Failed to retrieve news data!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GlobalData>(
      create: (context) => GlobalData(),
      child: Consumer<GlobalData>(
        builder: (context, globalData, child) {
          return MaterialApp(
              navigatorKey: navigatorKey,
              theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
              home: Home(
                context,
                articles,
                toggleTheme,
                navigatorKey,
              ));
        },
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalData(),
      child: const NewsApp(),
    ),
  );
}
