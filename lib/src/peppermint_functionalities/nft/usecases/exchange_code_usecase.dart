import 'package:peppermint_sdk/src/models/nft/nft.dart';
import 'package:peppermint_sdk/src/peppermint_functionalities/nft/repo/nft_repo.dart';
import '../../../resource.dart';

class ExchangeCodeUseCase {
  final NftRepo _nftRepo;

  ExchangeCodeUseCase(this._nftRepo);

  Future<Resource<Nft>> invoke({
    required String code,
    required String walletAddress,
  }) async {
    return _nftRepo.exchangeCodeToNft(
      code: code,
      walletAddress: walletAddress,
    );
  }
}
