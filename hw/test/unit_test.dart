import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/data/ApiArticles.dart';

//getArticleImage всегда возвращает картинку, если ссылка валидная то ее же,если нет - картинку "по умолчанию"
// тест проверяет что в случае валидной и не валидной ссылке типа возвращаемого объекта все равно Image

void main() {
  test('getArticleImage with valid UrlToImage', () {
    Map<String?, dynamic> article = {
      'urlToImage':
          'https://images.unsplash.com/photo-1707391478959-8d7df51c9e53?q=80&w=3086&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    };
    Image image = getArticleImage(article['urlToImage'], article);
    expect(image, isInstanceOf<Image>());
  });

  test('Test getArticleImage with exception', () {
    Map<String?, dynamic> article = {
      'urlToImage': 'https://example.com/image.jpg',
    };
    Image image = getArticleImage(article['urlToImage'], article);
    expect(image, isInstanceOf<Image>());
  });
}
