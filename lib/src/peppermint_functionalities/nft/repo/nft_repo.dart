import 'package:get/get.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';
import 'package:peppermint_sdk/src/api/api_list_response.dart';
import 'package:peppermint_sdk/src/api/api_response.dart';

class NftRepo {
  final GetConnect _getClient;
  final ErrorHandlers _errorHandler;

  NftRepo({
    required walletClient,
    required errorHandler,
  })  : _getClient = walletClient,
        _errorHandler = errorHandler;

  String token = '/api/v2/tokens/';

  Future<Resource<ApiListResponse<Nft>>> getNftList(
      {required int page, required String owner}) async {
    Response response = await _getClient.get(
      token,
      query: {
        'owner': owner,
        'page': '$page',
        'status': 'minted, pending',
      },
    );
    if (response.status.hasError) {
      return _errorHandler.errorHandler(response).toResourceFailure();
    }
    ApiListResponse responses = ApiListResponse.fromResponse(response);
    ApiListResponse<Nft> res = ApiListResponse.castResult(
      responses,
      responses.results.map((e) => Nft.fromJson(e)).toList(),
    );
    return res.toResourceSuccess();
  }

  Future<Resource<Nft>> launchNftPage({
    required String id,
  }) async {
    Response response = await _getClient.get(
      '$token$id/',
    );
    if (response.status.hasError) {
      return _errorHandler.errorHandler(response).toResourceFailure();
    }
    ApiResponse apiResonses = ApiResponse.fromResponse(response);
    return Nft.fromJson(apiResonses.data).toResourceSuccess();
  }
}
