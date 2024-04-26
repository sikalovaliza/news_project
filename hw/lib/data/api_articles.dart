import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

Future<List<Map<String, dynamic>>> fetch() async {
  const apiKey = 'a592096d6ab14973ab15f4937ce4ffde';
  const url =
      'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<Map<String, dynamic>> articles =
        List<Map<String, dynamic>>.from(json.decode(response.body)['articles']);
    return articles;
  } else {
    throw Exception('Failed to load data');
  }
}

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
