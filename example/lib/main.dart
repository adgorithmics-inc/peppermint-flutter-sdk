import 'package:example/utilities_page.dart';
import 'package:example/wallet_page.dart';
import 'package:example/widget/button.dart';
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
    return GetMaterialApp(
      title: 'Peppermint SDK Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CreateWalletPage(),
    );
  }
}

/// This page is a first page of the example appp.
class CreateWalletPage extends StatefulWidget {
  const CreateWalletPage({Key? key}) : super(key: key);

  @override
  State<CreateWalletPage> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyButton(
                text: 'Utility Example Page',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UtilitiesPage()));
                }),
            const SizedBox(height: 16.0),
            MyButton(
                text: 'Wallet Example Page',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WalletPage()));
                }),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
