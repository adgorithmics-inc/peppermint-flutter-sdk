import 'package:peppermint_sdk/peppermint_sdk.dart';

class NftController extends BaseListController {
  final GetNftListUseCase _getNftListUseCase;

  NftController({required GetNftListUseCase getNftListUseCase})
      : _getNftListUseCase = getNftListUseCase;

  List<Nft> listNft = [];
  String? walletAddress;

  final WalletManager _manager = WalletManager();

  init() async {
    loading = true;
    await _manager.initWallet(
      (addressWallet) {
        walletAddress = addressWallet;
      },
      key: 'test1@example.com',
      onFirstWallet: () {},
    );
    getData();
  }

  @override
  void getData() async {
    loading = true;
    error = '';
    final resource = await _getNftListUseCase.invoke(
      page: page,
      owner: walletAddress!,
    );

    resource.when(onSuccess: (onSuccess) {
      if (page == 1) listNft = [];
      listNft.addAll(onSuccess.results);
      next = onSuccess.hasNext;
    }, onFailure: (onFailure) {
      error = onFailure;
    });
    loading = false;
    update();

    super.getData();
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
}
