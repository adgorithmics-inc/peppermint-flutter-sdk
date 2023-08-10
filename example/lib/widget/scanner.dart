import 'package:flutter/material.dart';

import 'invisible_square.dart';

class Scanner extends StatelessWidget {
  final Widget scanner;

  const Scanner({required this.scanner, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        scanner,
        AspectRatio(
            aspectRatio: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: InvisibleSquare(
                size: MediaQuery.of(context).size.width - 64,
                borderRadius: 10,
                color: Colors.white,
                strokeWidth: 10,
              ),
            )),
      ],
    );
  }
}
