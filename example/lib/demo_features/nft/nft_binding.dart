import 'package:example/api/api.dart';
import 'package:example/demo_features/nft/nft_controller.dart';
import 'package:get/get.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';

class NftBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NftRepo>(
      () => NftRepo(
        walletClient: Get.put(WalletClient()),
        errorHandler: ErrorHandlers(
            wrong: 'Something went wrong',
            forbidden: 'Forbidden request',
            doesntExist: 'Page does not exist',
            underMaintenance: 'Feature is under maintenance'),
      ),
    );
    Get.lazyPut(() => GetNftListUseCase(Get.find()));

    Get.lazyPut<NftController>(() => NftController(
          getNftListUseCase: Get.find(),
          walletManager: WalletManager(),
        ));
  }
}
