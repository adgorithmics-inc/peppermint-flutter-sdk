import 'package:example/demo_features/nft/nft_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// this class contains the example of
/// NFT list that received from TokenDetailUsecase class.
class NftDetailPage extends StatelessWidget {
  const NftDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder(builder: (NftController controller) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'NFT ID: ${controller.detailData!.id}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      }),
    );
  }
}
