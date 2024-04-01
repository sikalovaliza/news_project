import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final String? text;
  final Color activeColor;
  final Function()? onPressed;
  final Key? key;

  const CustomIconButton({
    required this.icon,
    required this.text,
    required this.activeColor,
    this.onPressed,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Column(
        children: <Widget>[
          Icon(
            icon,
            size: 23,
            color: activeColor,
          ),
          Text(
            text ?? "",
            style: TextStyle(
              color: activeColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
