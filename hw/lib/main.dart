import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hw/presentation/screens/main_page.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'internal/main_provider.dart';
import 'package:intl/intl.dart';

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  NewsAppState createState() => NewsAppState();
}

class NewsAppState extends State<NewsApp> {
  bool isDarkMode = false;
  bool isSearch = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void toggleSearch() {
    setState(() {
      isSearch = !isSearch;
    });
  }

  List<Map<String?, dynamic>> articles = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<Map<String, dynamic>> recentArticles = [];
  List<Map<String, dynamic>> fetchedArticles = [];
  List<Map<String, dynamic>> filteredArticles = [];

  Future<void> fetchData() async {
    const apiKey = 'a592096d6ab14973ab15f4937ce4ffde';
    const url =
        'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        fetchedArticles = List<Map<String, dynamic>>.from(
            json.decode(response.body)['articles']);
      });
      DateTime now = DateTime.now();
      DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

      for (Map<String, dynamic> article in fetchedArticles) {
        DateTime publishedAt = dateFormat.parse(article['publishedAt']);
        if (now.difference(publishedAt).inDays <= 5) {
          recentArticles.add(article);
        } else {
          articles.add(article);
        }
      }
    }
  }

  void searchByTitle(String searchText) async {
    const apiKey = 'a592096d6ab14973ab15f4937ce4ffde';
    const url =
        'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        fetchedArticles = List<Map<String, dynamic>>.from(
            json.decode(response.body)['articles']);
        filteredArticles.clear();
        filteredArticles = fetchedArticles
            .where((article) => article['title']
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
      });
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
              home: home(
                context,
                articles,
                recentArticles,
                filteredArticles,
                toggleTheme,
                toggleSearch,
                searchByTitle,
                isSearch,
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
