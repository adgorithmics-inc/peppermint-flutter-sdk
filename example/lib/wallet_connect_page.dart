import 'package:example/widget/popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';

class WalletConnectPage extends StatefulWidget {
  const WalletConnectPage({Key? key}) : super(key: key);

  @override
  State<WalletConnectPage> createState() => _WalletConnectPageState();
}

class _WalletConnectPageState extends State<WalletConnectPage> {
  late WalletConnectManager _wcManager;
  late WalletManager _wManager;
  WCAttributes? _attributes;
  WalletKeys? _walletKeys;
  String rpcUri =
      'https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161';

  @override
  void initState() {
    _wcManager = WalletConnectManager();
    _wManager = WalletManager();
    _generateWallet();
    initWalletConnect();
    super.initState();
  }

  /// Generate a wallet with name "wallet1".
  Future<void> _generateWallet() async {
    _walletKeys = await _wManager.createWallet(key: "wallet1");
  }

  /// Create instance of Wallet connect client and define callbacks
  initWalletConnect() async {
    _attributes = await _wcManager.initWalletConnect(
      rpcUri: rpcUri,
      onDisconnect: _onSessionClosed,
      onEthSendTransaction: _onSendTransaction,
      onEthSign: _onSign,
      onEthSignTransaction: _onSignTransaction,
      onFailure: _onSessionError,
      onSessionRequest: _onSessionRequest,
    );
  }

  _onSessionError(dynamic message) {
    Popup.error('Some Error Occured. $message', title: 'Error');
  }

  _onSessionClosed(int? code, String? reason) {
    _attributes = _wcManager.closeSession(_attributes!);
    setState(() {});
    Popup.error(
      'The session has ended. Status: $code\n${reason != null && reason.isNotEmpty ? 'Failure Reason: $reason}' : ''}',
      title: 'Session Ended',
    );
  }

  _onSessionRequest(id, peerMeta) {
    Popup.popUp2Button(
      '',
      title: Column(
        children: [
          if (peerMeta.icons.isNotEmpty)
            Container(
              height: 100.0,
              width: 100.0,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.network(peerMeta.icons.first),
            ),
          Text(
            peerMeta.name,
            style: const TextStyle(fontSize: 20.0),
          ),
        ],
      ),
      content: Column(
        children: [
          if (peerMeta.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                peerMeta.description,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          if (peerMeta.url.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Connection to ${peerMeta.url}',
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
        ],
      ),
      titleBtn1: 'APPROVE',
      btn1: () {
        _attributes = _wcManager.approveSession(
          attributes: _attributes!,
          chainId: 5,
          rpcNetwork:
              'https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161',
          walletAddress: _walletKeys!.publicKey,
        );
        setState(() {});
      },
      titleBtn2: 'REJECT',
      btn2: () {
        _attributes?.wcClient.rejectSession();
        Get.back();
      },
    );
  }

  _onSign(id, ethereumSignMessage) {
    Popup.popUp2Button(
      '',
      title: Column(
        children: [
          if (_attributes != null &&
              _attributes!.wcClient.remotePeerMeta!.icons.isNotEmpty)
            Container(
              height: 100.0,
              width: 100.0,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.network(
                  _attributes!.wcClient.remotePeerMeta!.icons.first),
            ),
          Text(
            _attributes?.wcClient.remotePeerMeta!.name ?? '',
            style:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0),
          ),
        ],
      ),
      content: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 8.0),
            child: const Text(
              'Sign Message',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Text(
                  'Message',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                children: [
                  Text(
                    ethereumSignMessage.data!,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      titleBtn1: 'SIGN',
      btn1: () async {
        _attributes = await _wcManager.confirmSign(
          attributes: _attributes!,
          id: id,
          ethereumSignMessage: ethereumSignMessage,
          privateKey: _walletKeys!.privateKey,
        );
      },
      titleBtn2: 'REJECT',
      btn2: () {
        _attributes?.wcClient.rejectRequest(id: id);
        Get.back();
      },
    );
  }

  _onSignTransaction(id, ethereumTransaction) {
    _onTransaction(
      id: id,
      ethereumTransaction: ethereumTransaction,
      title: 'Sign Transaction',
      onConfirm: () async {
        _attributes = await _wcManager.confirmSignTransaction(
          attributes: _attributes!,
          id: id,
          ethereumTransaction: ethereumTransaction,
          privateKey: _walletKeys!.privateKey,
        );
      },
      onReject: () {
        _attributes?.wcClient.rejectRequest(id: id);
        Get.back();
      },
    );
  }

  _onSendTransaction(id, ethereumTransaction) {
    _onTransaction(
      id: id,
      ethereumTransaction: ethereumTransaction,
      title: 'Send Transaction',
      onConfirm: () async {
        _attributes = await _wcManager.confirmSendTransaction(
          attributes: _attributes!,
          id: id,
          ethereumTransaction: ethereumTransaction,
          privateKey: _walletKeys!.privateKey,
        );
      },
      onReject: () {
        _attributes?.wcClient.rejectRequest(id: id);
        Get.back();
      },
    );
  }

  _onTransaction({
    required id,
    required ethereumTransaction,
    required title,
    required onConfirm,
    required onReject,
  }) async {
    BigInt gasPrice = await _wcManager.getGasPrice(
      attributes: _attributes!,
      ethereumTransaction: ethereumTransaction,
    );
    Popup.popUp2Button(
      '',
      title: Column(
        children: [
          if (_attributes != null &&
              _attributes!.wcClient.remotePeerMeta!.icons.isNotEmpty)
            Container(
              height: 100.0,
              width: 100.0,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Image.network(
                  _attributes!.wcClient.remotePeerMeta!.icons.first),
            ),
          Text(
            _attributes?.wcClient.remotePeerMeta!.name ?? '',
            style:
                const TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0),
          ),
        ],
      ),
      content: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Receipient',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '${ethereumTransaction.to}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Transaction Fee',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${_wcManager.weiToEthUnTrimmed(gasPrice * BigInt.parse(ethereumTransaction.gas ?? '0'), 18)} MATIC',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Transaction Amount',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${_wcManager.weiToEthUnTrimmed(BigInt.parse(ethereumTransaction.value ?? '0'), 18)} MATIC',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text(
                'Data',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              children: [
                Text(
                  '${ethereumTransaction.data}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ],
      ),
      titleBtn1: 'CONFIRM',
      btn1: onConfirm,
      titleBtn2: 'REJECT',
      btn2: onReject,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet Connect')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_attributes?.sessionStore != null)
              Text(
                'Connected to ${_attributes?.sessionStore?.remotePeerMeta.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (_attributes?.sessionStore != null)
              MenuItem(
                onTap: () => _attributes?.wcClient.killSession(),
                image: const Icon(
                  Icons.history_toggle_off_rounded,
                  color: Colors.blue,
                  size: 20.0,
                ),
                label: 'Disconnect',
              ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final Function() onTap;
  final Widget image;
  final String label;
  final Color? fontColor;

  const MenuItem({
    Key? key,
    required this.onTap,
    required this.image,
    required this.label,
    this.fontColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
        margin: const EdgeInsets.only(top: 12.0),
        child: Row(
          children: [
            image,
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: fontColor ?? Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
