import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final double? width;

  const MyButton(
      {required this.text, required this.onTap, this.width, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: 44.0,
        color: Colors.blue,
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
