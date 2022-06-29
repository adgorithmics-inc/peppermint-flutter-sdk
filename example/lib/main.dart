import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peppermint SDK Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CreateWalletPage(),
    );
  }
}

class CreateWalletPage extends StatefulWidget {
  const CreateWalletPage({Key? key}) : super(key: key);

  @override
  State<CreateWalletPage> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  late WalletManager _manager;
  String? _privateKey;
  String? _walletAddress;

  @override
  void initState() {
    _manager = WalletManager();
    super.initState();
  }

  _generateWallet() async {
    await _manager.createWallet(
      keyToSavePrivateKey: 'keyToSavePrivateKey',
      keyToSaveWallet: 'keyToSaveWallet',
    );
    _getPrivateKey();
    _getPublicKey();
  }

  _getPrivateKey() async {
    _privateKey = await _manager.getPrivateKey();
    setState(() {});
  }

  _getPublicKey() async {
    _walletAddress = await _manager.getPublicKey();
    setState(() {});
  }

  _deleteAll() async {
    await _manager.deleteAll();
    _getPrivateKey();
    _getPublicKey();
  }

  _deletePrivateKey() async {
    await _manager.deletePrivateKey();
    _getPrivateKey();
  }

  _deletePublicKey() async {
    await _manager.deletePublicKey();
    _getPublicKey();
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Your public key / wallet address'),
            Row(
              children: [
                Expanded(
                  child: Text(_walletAddress ?? ''),
                ),
                if (_walletAddress != null)
                  IconButton(
                    onPressed: _deletePublicKey,
                    icon: const Icon(Icons.delete_rounded),
                  ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text('Your private key'),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      FlutterClipboard.copy(_privateKey ?? '').then(
                        (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Private key copied!'),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(_privateKey ?? ''),
                  ),
                ),
                if (_privateKey != null)
                  IconButton(
                    onPressed: _deletePrivateKey,
                    icon: const Icon(Icons.delete_rounded),
                  ),
              ],
            ),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: _generateWallet,
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
            ),
            if (_privateKey != null || _walletAddress != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: InkWell(
                  onTap: _deleteAll,
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
          ],
        ),
      ),
    );
  }
}

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
