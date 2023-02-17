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

The most common usage of Web3 Wallet is to generate wallet address (public key) and private key. Peppermint SDK makes it easy to do it without much complexity to manually implement other web3 packages. This package also store the keys safely using flutter_secure_storage.

In future, this package is a bridge to use Peppermint’s functionality with ease.

## Features

1. Generate wallet address (public key) and private key
2. Get current wallet address
3. Get current private key
4. Generate random contract name
5. Bound existing/new wallet
6. Delete wallet
7. Pick media file from device
8. Get image from camera
9. Launch Url
10. Scan QR code from camera
11. Image editor

## Usage

Import  `package:peppermint_sdk/peppermint_sdk.dart`, instantiate `WalletManager`.

You can see the full example in WalletPage class on `peppermint-flutter-sdk/example/lib/wallet_page.dart`.

Wallet function:

```dart
import 'package:peppermint_sdk/peppermint_sdk.dart';    

WalletManager manager = WalletManager();  

// generate new wallet
WalletKeys keys = manager.createWallet();  
print('${keys.publicKey}');
print('${keys.privateKey}');

// generate new wallet with key
WalletKeys keys = manager.createWallet(key: "wallet1");

// generate wallet from existing private key
String walletAddress = await manager.restoreWallet('enter your private key here')

// get current wallet address
String publicKey = await manager.getPublicKey();

// get current private key
String privateKey = await manager.getPrivateKey();

// delete all wallet
await deleteAllWallet();

// check if has any wallet
bool hasWallet = await manager.hasAnyWallet();

// generate contract name
String contractName = PeppermintUtility.generateContractName();


```

You can see the full example in UtilitiesPage class on `peppermint-flutter-sdk/example/lib/utilities_page.dart`.

Utilities function:

```dart

import 'package:peppermint_sdk/peppermint_sdk.dart';

// Scan QR from image uploaded.
QRResult result = await PeppermintUtility.getQRFile();
qrCode = result.result;

//Launch Url via browser.
bool result = await PeppermintUtility.launchBrowser('https://peppermintwallet.com/');

// Scan QR using device camera.
String? scanResult = await Get.to(() => const ScannerView());

// Upload image from camera.
// You can set edit to false or true to apply the editor
File? file = await PeppermintUtility.getImageFromCamera(edit: true);

// Upload image from Galery.
// You can set squareCrop to false or true to apply the squareCrop
File? file = await PeppermintUtility.getImageFromGallery(squareCrop: true);

// Upload media from explorer.
// You can set edit to false or true to apply the squareCrop
File? file = await PeppermintUtility.getMediaFromExplorer(squareCrop: true);

// Upload video from Galery.
File? file = await PeppermintUtility.getVideoFromGallery();

```



This library is able to manage multiple private key and public key per device.