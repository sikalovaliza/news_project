import 'package:flutter/material.dart';
import 'button_widget.dart';
import 'package:flutter/cupertino.dart';
import '../../internal/main_provider.dart';
import 'package:provider/provider.dart';

// ignore: non_constant_identifier_names
PreferredSizeWidget TopAppBarWidget(BuildContext context, bool isSearch,
    Function() toggleSearch, Function(String) searchByTitle) {
  List<Widget> actions = [];
  TextEditingController searchController = TextEditingController();
  if (isSearch) {
    actions.add(SizedBox(
        width: 410,
        height: 300,
        child: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 255, 255, 255),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            labelStyle: CupertinoTextField.cupertinoMisspelledTextStyle,
          ),
          keyboardType: TextInputType.text,
          autofocus: true,
          onChanged: (value) {
            searchByTitle(value.toString());
          },
          onSubmitted: (value) {
            toggleSearch();
          },
        )));
  } else {
    actions.add(
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomIconButton(
              icon: CupertinoIcons.search,
              text: null,
              activeColor: const Color.fromARGB(255, 251, 251, 251),
              onPressed: () {
                toggleSearch();
              },
            ),
          ],
        ),
      ),
    );
  }

  return PreferredSize(
    preferredSize: const Size.fromHeight(60.0),
    child: Consumer<GlobalData>(
      builder: (BuildContext context, GlobalData value, Widget? child) {
        return AppBar(
          backgroundColor: const Color.fromARGB(227, 38, 64, 180),
          actions: actions,
        );
      },
    ),
  );
}
