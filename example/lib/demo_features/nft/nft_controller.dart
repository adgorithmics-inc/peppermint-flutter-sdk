import 'package:peppermint_sdk/peppermint_sdk.dart';

class NftController extends BaseListController {
  final GetNftListUseCase _getNftListUseCase;
  final WalletManager _manager;

  NftController(
      {required GetNftListUseCase getNftListUseCase,
      required WalletManager walletManager})
      : _getNftListUseCase = getNftListUseCase,
        _manager = walletManager;

  List<Nft> listNft = [];
  String? walletAddress;

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
      owner: '0x93cd916bA08c905f4c05b6D3C71432F59205a787',
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
