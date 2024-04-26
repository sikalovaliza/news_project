import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GlobalData extends ChangeNotifier {
  List<Map<String?, dynamic>> likedArticles = [];
  List<Map<String, dynamic>> filteredArticles = [];

  GlobalData() {
    loadLikedArticles();
  }

  void addItem(Map<String?, dynamic> item) {
    if (!likedArticles.contains(item)) {
      likedArticles.add(item);
    }
    notifyListeners();
  }

  void removeItem(Map<String?, dynamic> item) {
    likedArticles.remove(item);
    notifyListeners();
  }

  void toggleLike(Map<String?, dynamic> article, bool isLiked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> likedArticles = prefs.getStringList('likedArticles') ?? [];
    if (!isLiked && likedArticles.contains(json.encode(article))) {
      likedArticles.remove(json.encode(article));
      notifyListeners();
    } else if (!likedArticles.contains(json.encode(article))) {
      likedArticles.add(json.encode(article));
      notifyListeners();
    }
    prefs.setStringList('likedArticles', likedArticles);
    notifyListeners();

    if (isLiked) {
      addItem(article);
    } else {
      removeItem(article);
    }
    //print(likedArticles);
  }

  void loadLikedArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? likedArticlesJson = prefs.getStringList('likedArticles');
    List<Map<String?, dynamic>> updatedLikedArticles = [];

    if (likedArticlesJson != null) {
      for (String articleJson in likedArticlesJson) {
        Map<String?, dynamic> article = json.decode(articleJson);
        updatedLikedArticles.add(article);
      }
    }
    likedArticles = updatedLikedArticles;
  }

  void toggleSearch(Map<String?, dynamic> articles, bool isSearch, value) {
    if (isSearch) {
      filteredArticles = articles.entries
          .where((news) =>
              news.value['title'].toLowerCase().contains(value.toLowerCase()))
          .cast<Map<String, dynamic>>()
          .toList();
    } else {
      filteredArticles.clear();
    }
  }
}
