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
  String exchange = '/api/v2/tokens/exchange/';

  Future<Resource<ApiListResponse<Nft>>> getNft(
      {required Map<String, String> query}) async {
    Response response = await _getClient.get(
      token,
      query: query,
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

  Future<Resource<Nft>> generateNft({
    required String? id,
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

  Future<Resource<Nft>> exchangeCodeToNft({
    required String? code,
    required String? walletAddress,
  }) async {
    Response response = await _getClient.post(exchange, {
      'code': code,
      'owner': walletAddress,
    });
    if (response.status.hasError) {
      return _errorHandler.errorHandler(response).toResourceFailure();
    }
    ApiResponse apiResonses = ApiResponse.fromResponse(response);
    return Nft.fromJson(apiResonses.data).toResourceSuccess();
  }
}
