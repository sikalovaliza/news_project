import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../presentation/screens/LikedNewsPage.dart';

Widget buildBottomNavigationBar(BuildContext context, Function() toggleTheme,
    GlobalKey<NavigatorState> navigatorKey) {
  return BottomNavigationBar(
    backgroundColor: Color.fromARGB(255, 132, 230, 125),
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
