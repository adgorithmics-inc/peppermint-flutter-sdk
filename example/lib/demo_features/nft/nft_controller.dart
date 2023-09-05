import 'package:example/base/base_controller.dart';
import 'package:example/routes.dart';
import 'package:example/widget/popup.dart';
import 'package:get/get.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';

class NftController extends BaseListController {
  final GetNftListUseCase _getNftListUseCase;
  final TokenDetailUsecase _tokenDetailUsecase;

  NftController(
      {required GetNftListUseCase getNftListUseCase,
      required WalletManager walletManager,
      required TokenDetailUsecase launchNftUseCase})
      : _getNftListUseCase = getNftListUseCase,
        _tokenDetailUsecase = launchNftUseCase;

  List<Nft> listNft = [];
  Nft? detailData;

  @override
  void getData() async {
    loading = true;
    error = '';
    final resource = await _getNftListUseCase.invoke(
      page: page,
      walletAddress: '0x9A999E71C7F430bfE5b970326C200540ab25d525',
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

  /// get token(NFT) detail data by ID
  void getTokenDetail(String id) async {
    Popup.loading();
    final resource = await _tokenDetailUsecase.invoke(
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
    getData();
    super.onInit();
  }
}
