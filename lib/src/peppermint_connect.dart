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

  /// Initialize Wallet Connect
  ///
  /// This function is used to initialize a Wallet Connect connection by providing
  /// various callbacks to handle different connection-related events such as session requests,
  /// failures, disconnections, Ethereum transaction signing, and Ethereum transaction sending.
  /// The function also initializes the WCClient and Web3Client clients used to communicate
  /// with the blockchain service provider.
  ///
  /// Parameters:
  /// - onSessionRequest: A callback invoked when a Wallet Connect session request is received.
  /// - onFailure: A callback invoked when an error occurs in the Wallet Connect connection.
  /// - onDisconnect: A callback invoked when the Wallet Connect connection is disconnected.
  /// - onEthSign: A callback invoked when an Ethereum transaction signing request is received.
  /// - onEthSignTransaction: A callback invoked when an Ethereum transaction signing request is received.
  /// - onEthSendTransaction: A callback invoked when an Ethereum transaction sending request is received.
  /// - maticRpcUri: The RPC URI for the blockchain service provider to be used.
  ///
  /// Return:
  /// This function returns a Future<WCAttributes> that contains a WCAttributes object
  /// which includes the WCClient instance, WCSessionStore session storage, and Web3Client instance.
  /// The Future value will be resolved once the initialization is complete.
  ///
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

  /// Connect New Session
  ///
  /// This function is used to establish a new session in Wallet Connect by creating
  /// a session object and peer metadata. The function connects the WCClient to the
  /// new session using the provided session and peer metadata.
  ///
  /// Parameters:
  /// - value: The session value string received from the Wallet Connect handshake.
  /// - attributes: The WCAttributes object containing the WCClient, WCSessionStore,
  ///   and Web3Client instances.
  ///
  /// Return:
  /// This function returns the updated WCAttributes object after connecting to the new session.
  ///
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

  /// Approve Session
  ///
  /// This function is used to approve a session request in Wallet Connect by providing
  /// the wallet address, chain ID, and RPC network details. The function approves the
  /// session request by calling the `approveSession` method of the WCClient. It also
  /// updates the Web3Client, WCSessionStore, and saves the session store to storage.
  ///
  /// Parameters:
  /// - attributes: The WCAttributes object containing the WCClient, WCSessionStore,
  ///   and Web3Client instances.
  /// - walletAddress: The wallet address to be used for the session.
  /// - chainId: The chain ID associated with the session.
  /// - rpcNetwork: The RPC network details for the session.
  ///
  /// Return:
  /// This function returns the updated WCAttributes object after approving the session
  /// and updating the necessary attributes and storage.
  ///
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

  /// Close Session
  ///
  /// This function is used to close the current session in Wallet Connect by
  /// removing the session store and deleting the session from storage. The function
  /// updates the `WCAttributes` object by setting the session store to null and
  /// deleting the session from storage.
  ///
  /// Parameters:
  /// - attributes: The `WCAttributes` object containing the WCClient, WCSessionStore,
  ///   and Web3Client instances.
  ///
  /// Return:
  /// This function returns the updated `WCAttributes` object after closing the session
  /// and removing the session store from attributes and storage.
  ///
  WCAttributes closeSession(WCAttributes attributes) {
    attributes.sessionStore = null;
    storage.delete(key: 'session');
    return attributes;
  }

  /// Confirm Sign
  ///
  /// This function is used to confirm a signing request in Wallet Connect by providing
  /// the necessary parameters such as the attributes, request ID, Ethereum sign message,
  /// and private key. The function performs the signing process and approves the request
  /// using the `approveRequest` method of the WCClient.
  ///
  /// Parameters:
  /// - attributes: The WCAttributes object containing the WCClient, WCSessionStore,
  ///   and Web3Client instances.
  /// - id: The request ID associated with the signing request.
  /// - ethereumSignMessage: The Ethereum sign message object containing the sign type
  ///   and data to be signed.
  /// - privateKey: The private key to be used for signing.
  ///
  /// Return:
  /// This function returns a Future<WCAttributes> that contains the updated WCAttributes
  /// object after confirming the sign request and approving it.
  ///
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

  /// Confirm Sign Transaction
  ///
  /// This function is used to confirm a transaction signing request in Wallet Connect
  /// by providing the necessary parameters such as the attributes, request ID,
  /// Ethereum transaction, and private key. The function signs the transaction using
  /// the provided private key and approves the request using the `approveRequest`
  /// method of the WCClient.
  ///
  /// Parameters:
  /// - attributes: The WCAttributes object containing the WCClient, WCSessionStore,
  ///   and Web3Client instances.
  /// - id: The request ID associated with the transaction signing request.
  /// - ethereumTransaction: The Ethereum transaction object to be signed.
  /// - privateKey: The private key to be used for signing.
  ///
  /// Return:
  /// This function returns a Future<WCAttributes> that contains the updated WCAttributes
  /// object after confirming the transaction signing request and approving it.
  ///
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

  /// Confirm Send Transaction
  ///
  /// This function is used to confirm and send a transaction in Wallet Connect by
  /// providing the necessary parameters such as the attributes, request ID,
  /// Ethereum transaction, and private key. The function sends the transaction using
  /// the provided private key and approves the request using the `approveRequest`
  /// method of the WCClient.
  ///
  /// Parameters:
  /// - attributes: The WCAttributes object containing the WCClient, WCSessionStore,
  ///   and Web3Client instances.
  /// - id: The request ID associated with the send transaction request.
  /// - ethereumTransaction: The Ethereum transaction object to be sent.
  /// - privateKey: The private key to be used for signing and sending the transaction.
  ///
  /// Return:
  /// This function returns a Future<WCAttributes> that contains the updated WCAttributes
  /// object after confirming and sending the transaction request.
  ///
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

  /// Get Gas Price
  ///
  /// This function is used to retrieve the gas price for a transaction in Wallet Connect.
  /// It takes the attributes and Ethereum transaction as parameters and returns the gas
  /// price as a BigInt.
  ///
  /// Parameters:
  /// - attributes: The WCAttributes object containing the WCClient, WCSessionStore,
  ///   and Web3Client instances.
  /// - ethereumTransaction: The Ethereum transaction object for which the gas price is
  ///   to be retrieved.
  ///
  /// Return:
  /// This function returns a Future<BigInt> representing the gas price for the transaction.
  ///
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

  /// Convert Wallet Connect Ethereum Transaction to Web3 Transaction
  ///
  /// This function is used to convert a Wallet Connect Ethereum transaction object
  /// to a Web3 transaction object. The converted transaction is returned.
  ///
  /// Parameters:
  /// - ethereumTransaction: The Wallet Connect Ethereum transaction object to be
  ///   converted.
  ///
  /// Return:
  /// This function returns a Web3 Transaction object representing the converted
  /// transaction.
  ///
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

  /// Convert Wei to Ether (Untrimmed)
  ///
  /// This function is used to convert a given amount in Wei to Ether. The conversion
  /// takes into account the decimal places specified by the `decimal` parameter.
  /// The function returns the converted amount as a double value, without trimming
  /// any decimal places.
  ///
  /// Parameters:
  /// - amount: The amount to be converted, represented as a BigInt in Wei.
  /// - decimal: The number of decimal places to consider for the conversion.
  ///
  /// Return:
  /// This function returns the converted amount as a double value, without any trimming
  /// of decimal places.
  ///
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
