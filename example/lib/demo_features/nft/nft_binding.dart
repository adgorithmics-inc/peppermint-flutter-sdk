import 'package:example/api_v2/dio_client.dart';
import 'package:example/demo_features/nft/nft_controller.dart';
import 'package:get/get.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';

class NftBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NftRepo>(
      () => NftRepo(
        walletClient: DioClient(),
      ),
    );
    Get.lazyPut(() => GetNftListUseCase(Get.find()));
    Get.lazyPut(() => TokenDetailUsecase(Get.find()));
    Get.lazyPut(() => ExchangeCodeUseCase(Get.find()));

    Get.lazyPut<NftController>(() => NftController(
          getNftListUseCase: Get.find(),
          launchNftUseCase: Get.find(),
          walletManager: WalletManager(),
        ));
  }
}
