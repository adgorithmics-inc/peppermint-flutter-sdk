import 'package:example/demo_features/nft/nft_controller.dart';
import 'package:example/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';

/// this class contains the example of
/// NFT list that received from GetNftListUseCase class.
class NftViewList extends GetView<NftController> {
  const NftViewList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder(
        builder: (NftController nftController) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.separated(
              itemCount: controller.listNft.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    MediaGram(data: nftController.listNft[index]),
                    const SizedBox(
                      height: 10,
                    ),
                    MyButton(
                      text: "Launch Nft",
                      onTap: () {
                        nftController
                            .getTokenDetail(nftController.listNft[index].id!);
                      },
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
