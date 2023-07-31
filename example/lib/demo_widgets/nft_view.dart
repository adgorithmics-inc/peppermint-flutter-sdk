import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';

/// example page of NftView page.
/// using dummy_nft Json file.
class NftView extends StatefulWidget {
  const NftView({Key? key}) : super(key: key);

  @override
  State<NftView> createState() => _NftViewState();
}

class _NftViewState extends State<NftView> {
  List<Nft> data = [];
  List<Contract?> contract = [];

  @override
  void initState() {
    readJson();
    super.initState();
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/json/dummy_nft.json');
    Iterable jsonDecode = json.decode(response)['results'];
    List<Nft> posts =
        List<Nft>.from(jsonDecode.map((model) => Nft.fromJson(model)));
    setState(() {
      data.addAll(posts);
      contract.addAll(data.map((e) => e.contract));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFT View'),
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 10,
            );
          },
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          itemCount: 5,
          shrinkWrap: true,
          itemBuilder: ((context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediaGram(
                  data: data[index],
                ),
                Text('${data[index].name}\nContract: ${contract[index]?.id}')
              ],
            );
          })),
    );
  }
}
