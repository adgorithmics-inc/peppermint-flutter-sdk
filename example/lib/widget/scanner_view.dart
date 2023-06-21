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
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
      ),
      body: NFTScanner(onDetect: (barcode) async {
        String value = '';
        for (final item in barcode.barcodes) {
          value = item.rawValue ?? '';
        }
        if (result == value) return;
        result = value;
        Get.log('SCAAAAAAAAN');
        Get.back(result: result);
      }),
    );
  }
}
