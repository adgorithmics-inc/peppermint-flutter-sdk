import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';
import 'package:peppermint_sdk/src/widgets/invisible_square.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({Key? key}) : super(key: key);

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
              key: qrKey,
              allowDuplicates: false,
              controller: controller,
              onDetect: (barcode, args) async {
                if (barcode.rawValue != null) {
                  Get.back(result: barcode.rawValue);
                }
              }),
          const AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: InvisibleSquare(
                  size: 300,
                  borderRadius: 8,
                  color: Colors.red,
                  strokeWidth: 8,
                ),
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
