import 'package:get/get.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';
import 'package:peppermint_sdk/src/api/api_list_response.dart';

class NftRepo {
  final GetConnect _walletClient;
  final ErrorHandlers _errorHandler;
  final String _baseUrl;

  NftRepo({
    required walletClient,
    required errorHandler,
    required baseUrl,
  })  : _walletClient = walletClient,
        _baseUrl = baseUrl,
        _errorHandler = errorHandler;

  String token = '/api/v2/tokens/';

  Future<Resource<ApiListResponse<Nft>>> getNftList(
      {required int page, required String owner}) async {
    Response response = await _walletClient.get(
      '$_baseUrl$token',
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
}
