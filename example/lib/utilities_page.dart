import 'package:example/widget/button.dart';
import 'package:example/widget/pick_media_view.dart';
import 'package:example/widget/popup.dart';
import 'package:example/widget/scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';


/// Utilites page.
/// Contain many of example utilities
/// That you can use with the SDK.
class UtilitiesPage extends StatefulWidget {
  const UtilitiesPage({Key? key}) : super(key: key);

  @override
  State<UtilitiesPage> createState() => _UtilitiesPageState();
}

class _UtilitiesPageState extends State<UtilitiesPage> {
  String? qrCode;
  String? scanResult;
  TextEditingController controller = TextEditingController();

  /// Scan QR from image uploaded.
  _getQRFile() async {
    QRResult result = await PeppermintUtility.getQRFile();
    qrCode = result.result;
    if (!result.success) {
      Popup.error(result.result!);
      qrCode = null;
    }
    setState(() {});
  }

  /// Launch Url via browser.
  _launchBrowser() async {
    bool result = await PeppermintUtility.launchBrowser(controller.text);
    if (result != true) {
      Popup.error('Could not launch ${controller.text}');
    }
  }

  /// Scan QR using device camera.
  /// for scan QR, try to call NFTScanner
  /// you can open ScannerView to see the example
  _scanQR() async {
    scanResult = await Get.to(() => const ScannerView());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilities Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyButton(
                  text: 'Pick Media',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const PickMediaView()))),
              const SizedBox(height: 16.0),
              MyButton(text: 'Select QR', onTap: _getQRFile),
              const SizedBox(height: 16.0),
              Text('Code of your QR file ${qrCode ?? ''}'),
              const SizedBox(height: 16.0),
              MyButton(text: 'Scan QR', onTap: _scanQR),
              const SizedBox(height: 16.0),
              Text('Scanner result ${scanResult ?? ''}'),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'insert url to launch here',
                ),
              ),
              const SizedBox(height: 16.0),
              MyButton(text: 'Launch Url', onTap: _launchBrowser),
            ],
          ),
        ),
      ),
    );
  }
}
