import 'package:flutter/material.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';

/// Scanner widget example
/// for scan QR, try to call NFTScanner
class ScannerView extends StatefulWidget {
  const ScannerView({Key? key}) : super(key: key);

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
      ),
      body: NFTScanner(onDetect: (barcode, args) async {
        if (barcode.rawValue != null) {
          Get.back(result: barcode.rawValue);
        }
      }),
    );
  }
}
