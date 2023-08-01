import 'package:peppermint_sdk/src/api/api_list_response.dart';
import 'package:peppermint_sdk/src/models/nft/nft.dart';
import 'package:peppermint_sdk/src/peppermint_functionalities/nft/repo/nft_repo.dart';
import '../../../resource.dart';

class GetNftListUseCase {
  final NftRepo _nftRepo;

  GetNftListUseCase(this._nftRepo);

  Future<Resource<ApiListResponse<Nft>>> invoke({
    required int page,
    required String owner,
  }) async {
    return _nftRepo.getNftList(page: page, owner: owner);
  }
}
