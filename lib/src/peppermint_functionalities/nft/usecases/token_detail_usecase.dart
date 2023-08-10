import 'package:peppermint_sdk/src/models/nft/nft.dart';
import 'package:peppermint_sdk/src/peppermint_functionalities/nft/repo/nft_repo.dart';
import '../../../resource.dart';

class TokenDetailUsecase {
  final NftRepo _nftRepo;

  TokenDetailUsecase(this._nftRepo);

  /// get token(NFT) detail data by ID
  Future<PeppermintResource<Nft>> invoke({
    required String? id,
  }) async {
    return _nftRepo.getTokenDetail(id: id);
  }
}
