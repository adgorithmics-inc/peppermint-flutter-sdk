import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'invisible_square.dart';

class Scanner extends StatelessWidget {
  final Function(Barcode, MobileScannerArguments?) onDetect;
  final GlobalKey? qrKey;
  final MobileScannerController? controller;
  final bool allowDuplicates;

  const Scanner(
      {Key? key,
      required this.onDetect,
      this.qrKey,
      this.controller,
      this.allowDuplicates = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        MobileScanner(
            key: qrKey,
            allowDuplicates: allowDuplicates,
            controller: controller,
            onDetect: onDetect),
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
