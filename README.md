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

## How to install

### Android

- Add UCropActivity into your AndroidManifest.xml

```xml

<activity
    android:name="com.yalantis.ucrop.UCropActivity"
    android:screenOrientation="portrait"
    android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>

```

Note:

From v1.2.0, you need to migrate your android project to v2 embedding ([detail](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects))

### iOS

- No configuration required

## Usage

Import `package:peppermint_sdk/peppermint_sdk.dart`, instantiate `WalletManager`.

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

This library is able to manage multiple private key and public key per device.

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

You can see the full example in WalletConnectPage class on `peppermint-flutter-sdk/example/lib/wallet_connect_page.dart`.

Wallet Connect function:

```dart

import 'package:peppermint_sdk/peppermint_sdk.dart';

WCAttributes attributes = await WalletConnectManager().initWalletConnect(
    maticRpcUri: maticRpcUri, //The RPC URI for the blockchain service provider to be used.
    onDisconnect: (code, reason) {
      // Respond to disconnect callback
    },
    onFailure: (error) {
      // Respond to connection failure callback
    },
    onSessionRequest: (id, peerMeta) {
      // Respond to connection request callback
    },
    onEthSign: (id, message) {
      // Respond to personal_sign or eth_sign or eth_signTypedData request callback
    },
    onEthSendTransaction: (id, tx) {
      // Respond to eth_sendTransaction request callback
    },
    onEthSignTransaction: (id, tx) {
      // Respond to eth_signTransaction request callback
    },
);

// Create WCSession object from wc: uri.
// Create WCPeerMeta object containing metadata for your app.
// Connect to a new session.
attributes = WalletConnectManager().connectNewSession(result, attributes);

// Approve a session connection request.
attributes = _wcManager.approveSession(
    attributes: attributes,
    chainId: 5,
    rpcNetwork: 'https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161',
    walletAddress: walletAddress,
);

// Approve a sign request
attributes = await _wcManager.confirmSign(
    attributes: attributes,
    id: id,
    ethereumSignMessage: ethereumSignMessage,
    privateKey: walletAddress,
);

// Approve a sign transaction request
attributes = await _wcManager.confirmSignTransaction(
    attributes: attributes,
    id: id,
    ethereumTransaction: ethereumTransaction,
    privateKey: walletAddress,
);

// Approve a send transaction request
attributes = await _wcManager.confirmSendTransaction(
    attributes: attributes,
    id: id,
    ethereumTransaction: ethereumTransaction,
    privateKey: walletAddress,
);

// Get Gas Price
BigInt gasPrice = await _wcManager.getGasPrice(
    attributes: attributes,
    ethereumTransaction: ethereumTransaction,
);

// Reject a session connection request.
attributes.wcClient.rejectSession();

// Reject any of the requests above by specifying request id
attributes.wcClient.rejectRequest(id: id);

// Permanently close a connected session
attributes.wcClient.killSession();

```

### Peppermint SDK Functionalities

This SDK also provide a global functionality (usecase) to make it easier for a project to use a basic Peppermint function such as 'ExchangeCode', 'GetNftList', 'TokenDetail'. You can see more detail of this function on the 'usecases' folder on path 'lib/src/peppermint_functionalities/nft/usecases'.

How to use:

1. Before using the function, you need to inject the usecase in your project:

```dart

import 'package:peppermint_sdk/peppermint_sdk.dart';

  Get.lazyPut<NftRepo>(
      () => NftRepo(
        walletClient: Get.put(WalletClient()),
        errorHandler: ErrorHandlers(
            wrong: 'Something went wrong',
            forbidden: 'Forbidden request',
            doesntExist: 'Page does not exist',
            underMaintenance: 'Feature is under maintenance'),
      ),
    );
  Get.lazyPut(() => GetNftListUseCase(Get.find()));
  Get.lazyPut(() => TokenDetailUsecase(Get.find()));
  Get.lazyPut(() => ExchangeCodeUseCase(Get.find()));

```

note that the injection example above is using the Get package, you can use your own depedency injection
like injectable, get_it. More about this package you can see on https://pub.dev/packages/get.

2. Use the functionalities:

You can use the function below on your controller class or your business logic class in your project.

```dart

import 'package:peppermint_sdk/peppermint_sdk.dart';

// Get the data from the repository through the Peppermint SDK.
final resource = await _tokenDetailUsecase.invoke(
      id: id,
    );

// Determine the next step after the resource above return success or fail.
// The onSuccess below will return a define-class-model of the usecase.
// See more detail of this usecase example on this path:
// lib/src/peppermint_functionalities/nft/usecases/token_detail_usecase.dart
resource.when(onSuccess: (onSuccess) {
      detailData = onSuccess;
      Get.toNamed(
        Routes.nftViewDetail,
      );
    }, onFailure: (onFailure) {
      Popup.error(onFailure);
      return;
    });


```

You can see more detail of this function in the nft_controller.dart file on path:
example/lib/demo_features/nft/nft_controller.dart.
