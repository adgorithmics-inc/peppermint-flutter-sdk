import 'package:peppermint_sdk/peppermint_sdk.dart';
import 'package:dio/dio.dart';

/// This class contains all the function
/// to get data from the API.
class NftRepo {
  final Dio _getClient;

  NftRepo({
    required walletClient,
  }) : _getClient = walletClient;

  String token = '/api/v2/tokens/';
  String exchange = '/api/v2/tokens/exchange/';

  /// get token(NFT) list that own by the user.
  /// will return list of NFT token.
  /// "status" parameter is an optional
  Future<PeppermintResource<PepperApiListResponse<Nft>>> getOwnedToken({
    required String? walletAddress,
    required int page,
    String? status,
  }) async {
    try {
      Response response = await _getClient.get(
        token,
        queryParameters: {
          'owner': walletAddress,
          'page': '$page',
          'status': status,
        },
      );
      PepperApiListResponse<Nft> res = PepperApiListResponse.fromJson(
          response, (json) => Nft.fromJson(json));
      return res.toResourceSuccess();
    } on DioException catch (e) {
      /// API Error
      return e.errorMessage.toResourceFailure();
    } catch (e) {
      /// Model parsing error because API changed without notice.
      return e.toString().toResourceFailure();
    }
  }

  /// get token(NFT) detail data by ID
  Future<PeppermintResource<Nft>> getTokenDetail({String? id}) async {
    try {
      Response response = await _getClient.get('$token$id/');
      return Nft.fromJson(response.data).toResourceSuccess();
    } on DioException catch (e) {
      return e.errorMessage.toResourceFailure();
    }
  }

  /// Exchange code from QR code scanned to NFT
  /// will return NFT response
  Future<PeppermintResource<Nft>> exchangeCodeToNft({
    required String? code,
    required String? walletAddress,
    required String? provenance,
  }) async {
    try {
      Response response = await _getClient.post(exchange, queryParameters: {
        'code': code,
        'owner': walletAddress,
        'provenance': provenance,
      });
      return Nft.fromJson(response.data).toResourceSuccess();
    } on DioException catch (e) {
      return e.errorMessage.toResourceFailure();
    }
  }
}
