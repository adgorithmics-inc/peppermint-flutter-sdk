import 'package:peppermint_sdk/src/models/nft/nft.dart';
import 'package:peppermint_sdk/src/peppermint_functionalities/nft/repo/nft_repo.dart';
import '../../../resource.dart';

class LaunchNftUseCase {
  final NftRepo _nftRepo;

  LaunchNftUseCase(this._nftRepo);

  Future<Resource<Nft>> invoke({
    required String id,
  }) async {
    return _nftRepo.launchNftPage(id: id);
  }
}
