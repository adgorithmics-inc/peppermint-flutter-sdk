import 'package:example/demo_features/chatbot/chatbot_binding.dart';
import 'package:example/demo_features/chatbot/chatbot_view.dart';
import 'package:example/demo_features/nft/nft_binding.dart';
import 'package:example/demo_features/nft/nft_list_view.dart';
import 'package:example/demo_utilities/utilities_page.dart';
import 'package:example/wallet_connect_page.dart';
import 'package:example/demo_utilities/wallet_page.dart';
import 'package:example/routes.dart';
import 'package:example/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      getPages: [
        GetPage(
          name: Routes.main,
          page: () => const CreateWalletPage(),
        ),
        GetPage(
          name: Routes.utilities,
          page: () => const UtilitiesPage(),
        ),
        GetPage(
          name: Routes.widgets,
          page: () => const WalletPage(),
        ),
        GetPage(
          name: Routes.chatbot,
          page: () => const ChatbotView(),
          binding: ChatbotBinding(),
        ),
        GetPage(
          name: Routes.nftView,
          page: () => const NftViewList(),
          binding: NftBinding(),
        ),
      ],
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
                  Get.toNamed(Routes.utilities);
                }),
            const SizedBox(height: 16.0),
            MyButton(
                text: 'Wallet Example Page',
                onTap: () {
                  Get.toNamed(Routes.widgets);
                }),
            const SizedBox(height: 16.0),
            MyButton(
                text: 'Chatbot Example Page',
                onTap: () {
                  Get.toNamed(Routes.chatbot);
                }),
            MyButton(
                text: 'Nft View Example Page',
                onTap: () {
                  Get.toNamed(Routes.nftView);
                }),
            MyButton(
                text: 'Wallet Connect Example Page',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WalletConnectPage()));
                }),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
