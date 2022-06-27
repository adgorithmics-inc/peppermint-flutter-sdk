<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A flutter library to easily use Peppermint functionality.

The most common usage of web3 wallet is to generate wallet address (public key) and private key. This library makes it easy to do it without much complexity to manually implement other web3 packages.

## Features

1. Generate wallet address (public key)  and private key
2. Get current wallet address
3. Get current private key

## Usage

Import  ```package:wallet_manager/wallet_manager.dart```, insantiate ```WalletManager```.

```dart
import 'package:wallet_manager/wallet_manager.dart';    

WalletManager manager = WalletManager();  

// generate new wallet
WalletKeys keys = manager.createWallet();  
print('${keys.publicKey}');
print('${keys.privateKey}');

// generate wallet from existing private key
String walletAddress = await manager.restoreWallet('enter your private key here')

// get current wallet address
String walletAddress = await manager.getPublicKey();

// get current private key
String walletAddress = await manager.getPrivateKey();


```

This library manage only 1 private key and public key per device.