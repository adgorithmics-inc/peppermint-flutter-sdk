import 'package:peppermint_sdk/src/api/api_list_response.dart';
import 'package:peppermint_sdk/src/models/nft/nft.dart';
import 'package:peppermint_sdk/src/peppermint_functionalities/nft/repo/nft_repo.dart';
import '../../../resource.dart';

class GetNftListUseCase {
  final NftRepo _nftRepo;

  GetNftListUseCase(this._nftRepo);

  /// Get the list NFT token that own by the user
  Future<PeppermintResource<ApiListResponse<Nft>>> invoke({
    required String walletAddress,
    required int page,
    String? status,
  }) async {
    return _nftRepo.getOwnedToken(
      walletAddress: walletAddress,
      page: page,
      status: status,
    );
  }
}
