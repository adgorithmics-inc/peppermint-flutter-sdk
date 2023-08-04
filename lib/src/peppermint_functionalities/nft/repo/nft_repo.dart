import 'package:get/get.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';
import 'package:peppermint_sdk/src/api/api_list_response.dart';
import 'package:peppermint_sdk/src/api/api_response.dart';

/// This class contains all the function
/// to get data from the API.
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

  /// get token(NFT) list that own by the user.
  /// will return list of NFT token.
  /// "status" parameter is an optional
  Future<Resource<ApiListResponse<Nft>>> getOwnedToken({
    required String walletAddress,
    required int page,
    String? status,
  }) async {
    Response response = await _getClient.get(
      token,
      query: {
        'owner': walletAddress,
        'page': '$page',
        'status': status,
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

  /// get token(NFT) detail data by ID
  Future<Resource<Nft>> getTokenDetail({
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

  /// Exchange code from QR code scanned to NFT
  /// will return NFT response
  Future<Resource<Nft>> exchangeCodeToNft({
    required String? code,
    required String? walletAddress,
  }) async {
    Response response = await _getClient.post(
      exchange,
      {
        'code': code,
        'owner': walletAddress,
      },
    );
    if (response.status.hasError) {
      return _errorHandler.errorHandler(response).toResourceFailure();
    }
    ApiResponse apiResonses = ApiResponse.fromResponse(response);
    return Nft.fromJson(apiResonses.data).toResourceSuccess();
  }
}
