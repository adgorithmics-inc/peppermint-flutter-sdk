import 'package:example/base/base_controller.dart';
import 'package:example/routes.dart';
import 'package:example/widget/popup.dart';
import 'package:get/get.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';

class NftController extends BaseListController {
  final GetNftListUseCase _getNftListUseCase;
  final TokenDetailUsecase _launchNftUseCase;

  final WalletManager _manager;

  NftController(
      {required GetNftListUseCase getNftListUseCase,
      required WalletManager walletManager,
      required TokenDetailUsecase launchNftUseCase})
      : _getNftListUseCase = getNftListUseCase,
        _launchNftUseCase = launchNftUseCase,
        _manager = walletManager;

  List<Nft> listNft = [];
  String? walletAddress;
  Nft? detailData;

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

  /// Wallet address is marked as not nullable because the condition is handled
  /// beforehand.
  @override
  void getData() async {
    loading = true;
    error = '';
    final resource = await _getNftListUseCase.invoke(
      page: page,
      walletAddress: walletAddress!,
      status: 'minted, pending',
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

  void launchNft(String id) async {
    Popup.loading();
    final resource = await _launchNftUseCase.invoke(
      id: id,
    );
    Popup.pop();
    resource.when(onSuccess: (onSuccess) {
      detailData = onSuccess;
      Get.toNamed(
        Routes.nftViewDetail,
      );
    }, onFailure: (onFailure) {
      Popup.error(onFailure);
      return;
    });
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
}
