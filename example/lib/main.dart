import 'package:clipboard/clipboard.dart';
import 'package:example/nft_view.dart';
import 'package:example/pick_media_view.dart';
import 'package:example/scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';

import 'button.dart';
import 'popup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Peppermint SDK Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CreateWalletPage(),
    );
  }
}

/// This page is a collection of many example of functions.
class CreateWalletPage extends StatefulWidget {
  const CreateWalletPage({Key? key}) : super(key: key);

  @override
  State<CreateWalletPage> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  late WalletManager _manager;
  WalletKeys? _walletKeys;
  bool hasWallet = false;
  String? qrCode;
  String? scanResult;
  String? contractName;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    _manager = WalletManager();
    super.initState();
  }

  /// Generate a wallet with name "wallet1".
  _generateWallet() async {
    _walletKeys = await _manager.createWallet(key: "wallet1");
    hasWallet = await _manager.hasAnyWallet();
    setState(() {});
  }

  /// Delete a wallet with name "wallet1".
  _deleteWallet() async {
    await _manager.delete(key: "wallet1");
    _walletKeys = null;
    hasWallet = await _manager.hasAnyWallet();
    setState(() {});
  }

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

  /// Generate new random contract name.
  _generateContractName() {
    contractName = PeppermintUtility.generateContractName();
    setState(() {});
  }

  /// Go to NftView page.
  void _goToNftExample(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NftView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Wallet'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RestoreWalletPage())),
        tooltip: 'Restore wallet',
        child: const Icon(Icons.restore),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('I have wallet? $hasWallet'),
            const Text('Your public key / wallet address'),
            Text(_walletKeys?.publicKey ?? ''),
            const SizedBox(height: 16.0),
            const Text('Your private key'),
            InkWell(
              onTap: () {
                FlutterClipboard.copy(_walletKeys?.privateKey ?? '').then(
                  (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Private key copied!'),
                      ),
                    );
                  },
                );
              },
              child: Text(_walletKeys?.privateKey ?? ''),
            ),
            const SizedBox(height: 16.0),
            MyButton(text: 'Generate new Wallet', onTap: _generateWallet),
            if (_walletKeys != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: InkWell(
                  onTap: _deleteWallet,
                  child: Container(
                    width: double.infinity,
                    height: 44.0,
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: const Text(
                      'Delete Wallet',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16.0),
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
            MyButton(text: 'generate', onTap: _generateContractName),
            const SizedBox(height: 16.0),
            Text(
              contractName ??
                  'Click button "generate" to get random contract name',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'insert url to launch here',
              ),
            ),
            const SizedBox(height: 16.0),
            MyButton(text: 'Launch Url', onTap: _launchBrowser),
            const SizedBox(height: 16.0),
            MyButton(
                text: 'NFT view example',
                onTap: () => _goToNftExample(context)),
          ],
        ),
      ),
    );
  }
}

/// This page is for restoring a wallet with private key.
class RestoreWalletPage extends StatefulWidget {
  const RestoreWalletPage({Key? key}) : super(key: key);

  @override
  State<RestoreWalletPage> createState() => _RestoreWalletPageState();
}

class _RestoreWalletPageState extends State<RestoreWalletPage> {
  TextEditingController controller = TextEditingController();
  String? walletAddress;
  late WalletManager manager;

  @override
  void initState() {
    manager = WalletManager();
    super.initState();
  }

  /// For restoring a wallet with private key.
  void _restoreWallet() async {
    walletAddress = await manager.restoreWallet(controller.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restore Wallet'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'insert your private key',
                ),
              ),
              const SizedBox(height: 16.0),
              Text(walletAddress ?? ''),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: _restoreWallet,
                child: Container(
                  width: double.infinity,
                  height: 44.0,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: const Text(
                    'Generate new Wallet',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
