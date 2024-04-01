import 'package:flutter/material.dart';
import 'ButtonWidget.dart';
import 'package:flutter/cupertino.dart';

PreferredSizeWidget TopAppBarWidget(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50.0),
    child: AppBar(
      backgroundColor: Colors.black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Моя лента',
            style: TextStyle(
              color: Color.fromARGB(255, 247, 247, 247),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          CustomIconButton(
            icon: CupertinoIcons.clock_solid,
            text: null,
            activeColor: const Color.fromARGB(255, 81, 190, 79),
            onPressed: () {},
          )
        ],
      ),
    ),
  );
}
