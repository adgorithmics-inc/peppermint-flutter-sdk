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

  /// Key variables for save private key and wallet address data to storage
  String keyToSavePrivateKey = 'privateKey';
  String keyToSaveWallet = 'walletAddress';

  /// Create new wallet.
  ///
  /// Returns web3 wallet address (also known as public key)
  /// and private key. Private key is used to restore web3 wallet in all
  /// platform.
  Future<WalletKeys> createWallet(
      {required String keyToSaveWallet,
      required String keyToSavePrivateKey}) async {
    this.keyToSaveWallet = keyToSaveWallet;
    this.keyToSavePrivateKey = keyToSavePrivateKey;

    var rng = math.Random.secure();
    EthPrivateKey priKey = EthPrivateKey.createRandom(rng);

    String privateKey = bytesToHex(priKey.privateKey, include0x: false);
    privateKey = Utils.getPrettyPrivateKey(privateKey);
    String walletAddress = priKey.address.hexEip55;

    await storage.write(key: this.keyToSaveWallet, value: walletAddress);
    await storage.write(key: this.keyToSavePrivateKey, value: privateKey);
    return WalletKeys(privateKey, walletAddress);
  }

  /// Restore wallet.
  ///
  /// Returns wallet address (also known as public key)
  /// it can be used to generate wallet address from any web3 private key
  Future<String> restoreWallet(String privateKey) async {
    /// Trim private key.
    ///
    /// Because there is some cases where web3dart package includes hex (00)
    /// in the beginning of the String.
    String trimmedKey = Utils.getPrettyPrivateKey(privateKey);

    EthPrivateKey priKey = EthPrivateKey.fromHex(trimmedKey);
    String walletAddress = priKey.address.hexEip55;
    await storage.write(key: keyToSaveWallet, value: walletAddress);
    await storage.write(
        key: keyToSavePrivateKey, value: bytesToHex(priKey.privateKey));
    return walletAddress;
  }

  Future<String?> getPrivateKey() async {
    return await storage.read(key: keyToSavePrivateKey);
  }

  Future<String?> getPublicKey() async {
    return await storage.read(key: keyToSaveWallet);
  }

  Future<void> deleteAll() async {
    return await storage.deleteAll();
  }

  Future<void> deletePrivateKey() async {
    return await storage.delete(key: keyToSavePrivateKey);
  }

  Future<void> deletePublicKey() async {
    return await storage.delete(key: keyToSaveWallet);
  }
}
