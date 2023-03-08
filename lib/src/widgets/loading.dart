import 'package:flutter/material.dart';

/// Loading widget
/// That is use all over the SDK.
class PeppermintLoading extends StatelessWidget {
  final Color? color;

  const PeppermintLoading({this.color = const Color(0xffF00F13), Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: color));
  }
}
