import 'dart:convert';

import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class WCAttributes {
  WCClient wcClient;
  WCSessionStore? sessionStore;
  Web3Client? web3client;

  WCAttributes(this.wcClient, this.sessionStore, this.web3client);
}

class WalletConnectManager {
  /// Use Flutter Secure Storage to safely store keys.
  ///
  /// See documentation https://pub.dev/packages/flutter_secure_storage
  final storage = const FlutterSecureStorage();

  Future<WCAttributes> initWalletConnect({
    SessionRequest? onSessionRequest,
    SocketError? onFailure,
    SocketClose? onDisconnect,
    EthSign? onEthSign,
    EthTransaction? onEthSignTransaction,
    EthTransaction? onEthSendTransaction,
    required String maticRpcUri,
  }) async {
    WCClient _wcClient = WCClient(
      onSessionRequest: onSessionRequest,
      onFailure: onFailure,
      onDisconnect: onDisconnect,
      onEthSign: onEthSign,
      onEthSignTransaction: onEthSignTransaction,
      onEthSendTransaction: onEthSendTransaction,
    );
    Web3Client _web3client = Web3Client(
      maticRpcUri,
      http.Client(),
    );
    String? sessionSaved = await storage.read(key: 'session');
    WCSessionStore? _sessionStore = sessionSaved != null
        ? WCSessionStore.fromJson(jsonDecode(sessionSaved))
        : null;
    if (_sessionStore != null) {
      _wcClient.connectFromSessionStore(_sessionStore);
    }
    return WCAttributes(_wcClient, _sessionStore, _web3client);
  }

  WCAttributes connectNewSession(String value, WCAttributes attributes) {
    final session = WCSession.from(value);
    final peerMeta = WCPeerMeta(
      name: 'Example Wallet',
      url: 'https://example.wallet',
      description: 'Example Wallet',
      icons: [
        'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png'
      ],
    );
    attributes.wcClient.connectNewSession(session: session, peerMeta: peerMeta);
    return attributes;
  }

  WCAttributes approveSession({
    required WCAttributes attributes,
    required String walletAddress,
    required int chainId,
    required String rpcNetwork,
  }) {
    attributes.wcClient.approveSession(
      accounts: [walletAddress],
      chainId: chainId,
    );
    attributes.web3client = Web3Client(
      rpcNetwork,
      http.Client(),
    );
    attributes.sessionStore = attributes.wcClient.sessionStore;
    storage.write(
      key: 'session',
      value: jsonEncode(attributes.wcClient.sessionStore.toJson()),
    );
    return attributes;
  }

  WCAttributes closeSession(WCAttributes attributes) {
    attributes.sessionStore = null;
    storage.delete(key: 'session');
    return attributes;
  }

  Future<WCAttributes> confirmSign(
      {required WCAttributes attributes,
      required int id,
      required WCEthereumSignMessage ethereumSignMessage,
      required String privateKey}) async {
    String signedDataHex;
    if (ethereumSignMessage.type == WCSignType.TYPED_MESSAGE) {
      signedDataHex = EthSigUtil.signTypedData(
        privateKey: privateKey,
        jsonData: ethereumSignMessage.data!,
        version: TypedDataVersion.V4,
      );
    } else {
      final creds = EthPrivateKey.fromHex(privateKey);
      final encodedMessage = hexToBytes(ethereumSignMessage.data!);
      final signedData = await creds.signPersonalMessage(encodedMessage);
      signedDataHex = bytesToHex(signedData, include0x: true);
    }
    attributes.wcClient.approveRequest<String>(
      id: id,
      result: signedDataHex,
    );
    return attributes;
  }

  Future<WCAttributes> confirmSignTransaction(
      {required WCAttributes attributes,
      required int id,
      required WCEthereumTransaction ethereumTransaction,
      required String privateKey}) async {
    final creds = EthPrivateKey.fromHex(privateKey);
    final tx = await attributes.web3client!.signTransaction(
      creds,
      _wcEthTxToWeb3Tx(ethereumTransaction),
      chainId: attributes.wcClient.chainId!,
    );
    attributes.wcClient.approveRequest<String>(
      id: id,
      result: bytesToHex(tx),
    );
    return attributes;
  }

  Future<WCAttributes> confirmSendTransaction(
      {required WCAttributes attributes,
      required int id,
      required WCEthereumTransaction ethereumTransaction,
      required String privateKey}) async {
    final creds = EthPrivateKey.fromHex(privateKey);
    final txhash = await attributes.web3client!.sendTransaction(
      creds,
      _wcEthTxToWeb3Tx(ethereumTransaction),
      chainId: attributes.wcClient.chainId!,
    );
    attributes.wcClient.approveRequest<String>(
      id: id,
      result: txhash,
    );
    return attributes;
  }

  Future<BigInt> getGasPrice({
    required WCAttributes attributes,
    required WCEthereumTransaction ethereumTransaction,
  }) async {
    BigInt gasPrice = BigInt.parse(ethereumTransaction.gasPrice ?? '0');
    if (gasPrice == BigInt.zero) {
      gasPrice = await attributes.web3client!.estimateGas();
    }
    return gasPrice;
  }

  Transaction _wcEthTxToWeb3Tx(WCEthereumTransaction ethereumTransaction) {
    return Transaction(
      from: EthereumAddress.fromHex(ethereumTransaction.from),
      to: EthereumAddress.fromHex(ethereumTransaction.to!),
      maxGas: ethereumTransaction.gasLimit != null
          ? int.tryParse(ethereumTransaction.gasLimit!)
          : null,
      gasPrice: ethereumTransaction.gasPrice != null
          ? EtherAmount.inWei(BigInt.parse(ethereumTransaction.gasPrice!))
          : null,
      value: EtherAmount.inWei(BigInt.parse(ethereumTransaction.value ?? '0')),
      data: hexToBytes(ethereumTransaction.data!),
      nonce: ethereumTransaction.nonce != null
          ? int.tryParse(ethereumTransaction.nonce!)
          : null,
    );
  }

  double weiToEthUnTrimmed(BigInt amount, int? decimal) {
    if (decimal == null) {
      double db = amount / BigInt.from(10).pow(18);
      return double.parse(db.toStringAsFixed(6));
    } else {
      double db = amount / BigInt.from(10).pow(decimal);
      return double.parse(db.toStringAsFixed(6));
    }
  }
}
