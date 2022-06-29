import 'dart:math' as math;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import 'utils.dart';

/// WalletKeys
/// A class to get the value of private key and public key directly after
/// creating new wallet.
class WalletKeys {
  String privateKey;
  String publicKey;

  WalletKeys(this.privateKey, this.publicKey);
}

class WalletManager {
  /// Use Flutter Secure Storage to safely store keys.
  ///
  /// See documentation https://pub.dev/packages/flutter_secure_storage
  final storage = const FlutterSecureStorage();

  /// Create new wallet.
  ///
  /// Returns web3 wallet address (also known as public key)
  /// and private key. Private key is used to restore web3 wallet in all
  /// platform.
  /// the 'key' parameter is optional, it is needed if you want to
  /// save some wallet address and private key
  Future<WalletKeys> createWallet({String? key}) async {
    var rng = math.Random.secure();
    EthPrivateKey priKey = EthPrivateKey.createRandom(rng);

    String privateKey = bytesToHex(priKey.privateKey, include0x: false);
    privateKey = Utils.getPrettyPrivateKey(privateKey);
    String walletAddress = priKey.address.hexEip55;

    await storage.write(key: '${key}walletAddress', value: walletAddress);
    await storage.write(key: '${key}privateKey', value: privateKey);
    return WalletKeys(privateKey, walletAddress);
  }

  /// Restore wallet.
  ///
  /// Returns wallet address (also known as public key)
  /// it can be used to generate wallet address from any web3 private key
  /// the 'key' parameter is optional, it is needed if you want to
  /// save some wallet address and private key
  Future<String> restoreWallet(String privateKey, {String? key}) async {
    /// Trim private key.
    ///
    /// Because there is some cases where web3dart package includes hex (00)
    /// in the beginning of the String.
    String trimmedKey = Utils.getPrettyPrivateKey(privateKey);

    EthPrivateKey priKey = EthPrivateKey.fromHex(trimmedKey);
    String walletAddress = priKey.address.hexEip55;
    await storage.write(key: '${key}walletAddress', value: walletAddress);
    await storage.write(
        key: '${key}privateKey', value: bytesToHex(priKey.privateKey));
    return walletAddress;
  }

  /// the 'key' parameter is optional, it is needed if you want to
  /// get private key based on that key
  Future<String?> getPrivateKey({String? key}) async {
    return await storage.read(key: '${key}privateKey');
  }

  /// the 'key' parameter is optional, it is needed if you want to
  /// get wallet address based on that key
  Future<String?> getPublicKey({String? key}) async {
    return await storage.read(key: '${key}walletAddress');
  }

  /// the 'key' parameter is optional, it is needed if you want to
  /// delete private key and wallet address based on that key
  Future<void> delete({String? key}) async {
    await storage.delete(key: '${key}privateKey');
    await storage.delete(key: '${key}walletAddress');
  }
}
