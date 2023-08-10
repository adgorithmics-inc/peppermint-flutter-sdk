import 'package:clipboard/clipboard.dart';
import 'package:example/demo_widgets/nft_view.dart';
import 'package:example/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';

/// Wallet page.
/// Contains implemetation of Web3 function
/// That you can use with the SDK.
class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late WalletManager _manager;
  WalletKeys? _walletKeys;
  bool hasWallet = false;
  String? contractName;
  String? walletAddress;

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

  /// Init wallet
  /// Will check existing wallet before creating new one
  _initWallet() async {
    _manager.initWallet((addressWallet) {
      walletAddress = addressWallet;
    }, key: 'test1@example.com', onFirstWallet: () {});
    setState(() {});
  }

  /// Bound wallet
  /// Check existing wallet, if there is, will restore wallet.
  _boundWallet() async {
    await _manager.boundWallet('test1@example.com');
    walletAddress = await _manager.getPublicKey(key: 'test1@example.com');
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
        title: const Text('Wallet Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
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
              Text(
                'Your wallet address \n\n${walletAddress ?? ''}\n',
                textAlign: TextAlign.center,
              ),
              MyButton(text: 'Init wallet', onTap: _initWallet),
              const SizedBox(height: 16.0),
              MyButton(text: 'Bound wallet', onTap: _boundWallet),
              const SizedBox(height: 16.0),
              MyButton(text: 'generate', onTap: _generateContractName),
              const SizedBox(height: 16.0),
              Text(
                contractName ??
                    'Click button "generate" to get random contract name',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              MyButton(
                  text: 'Go to Restore Wallet Page ',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RestoreWalletPage()));
                  }),
              const SizedBox(height: 16.0),
              MyButton(
                  text: 'NFT view example',
                  onTap: () => _goToNftExample(context)),
            ],
          ),
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
