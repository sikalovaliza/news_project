import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../screens/liked_news_page.dart';

Widget buildBottomNavigationBar(BuildContext context, Function() toggleTheme,
    GlobalKey<NavigatorState> navigatorKey) {
  return BottomNavigationBar(
    backgroundColor: const Color.fromARGB(227, 38, 64, 180),
    items: const [
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.person_solid),
        label: 'Домой',
      ),
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.book_solid),
        label: 'Нравится',
      ),
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.book_solid),
        label: 'Тема',
        backgroundColor: Color.fromARGB(255, 253, 253, 253),
      ),
    ],
    onTap: (index) {
      if (index == 0) {}
      if (index == 1) {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => LikedNewsPage(
                toggleTheme: toggleTheme, navigatorKey: navigatorKey),
          ),
        );
      }
      if (index == 2) {
        toggleTheme();
      }
    },
  );
}
