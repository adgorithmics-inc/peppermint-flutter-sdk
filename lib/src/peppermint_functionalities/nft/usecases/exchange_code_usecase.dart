import 'package:peppermint_sdk/src/models/nft/nft.dart';
import 'package:peppermint_sdk/src/peppermint_functionalities/nft/repo/nft_repo.dart';
import '../../../resource.dart';

class ExchangeCodeUseCase {
  final NftRepo _nftRepo;

  ExchangeCodeUseCase(this._nftRepo);

  /// exchangeCode usecase, will convert
  /// the code from scanned qr before send it for
  /// minting the token.
  Future<PeppermintResource<Nft>> invoke({
    required String code,
    required String walletAddress,
  }) async {
    final exchangeResult = await _nftRepo.exchangeCodeToNft(
      code: code,
      walletAddress: walletAddress,
    );

    if (exchangeResult.hasError) {
      return exchangeResult.error.toResourceFailure();
    }
    Nft data = exchangeResult.data;
    await _checkMintingStatus(data);
    return data.toResourceSuccess();
  }

  Future<Nft> _checkMintingStatus(Nft data) async {
    /// Step to wait for the token status to be 'minted'.
    /// This will indicate token image already generated in the Web3 network.
    /// If by the timeout, status is not minted yet, still return the first
    /// successful [Nft] object from [exchangeResult].
    /// Fail or not, this won't obstruct the flow. Already handle the token
    /// status via UI.
    bool minting = true;
    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));
      final result = await _nftRepo.getTokenDetail(id: data.id);
      if (result.hasData) {
        if (result.data.status == 'minted') {
          minting = false;
          data.status = 'minted';
          return minting;
        }
      }
      return minting;
    }).timeout(const Duration(seconds: 30), onTimeout: () {
      minting = false;
    });
    return data;
  }
}
