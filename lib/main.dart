import 'package:flutter/material.dart';
import 'package:flutter_application_reown/controllers/controller.dart';
import 'package:flutter_application_reown/screens/main_screen.dart';
import 'package:get/route_manager.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:get/get.dart';

void main() {

  WalletController cryptoController = Get.put<WalletController>(WalletController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Wallet',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:  WalletConnectScreen(),
    );
  }
}

class WalletConnectScreen extends StatefulWidget {
  const WalletConnectScreen({Key? key}) : super(key: key);

  @override
  State<WalletConnectScreen> createState() => _WalletConnectScreenState();
}

class _WalletConnectScreenState extends State<WalletConnectScreen> {
  late ReownAppKitModal _appKitModal;
  ValueNotifier<String?> walletAddressNotifier = ValueNotifier(null);
  ValueNotifier<String> sessionStatusNotifier = ValueNotifier('No active session');
  WalletController walletController = Get.find<WalletController>();

  
  @override
  void initState() {
    super.initState();
    initializeWalletKit();
  }

  void initializeWalletKit() async {
    _appKitModal = ReownAppKitModal(
      context: context,
      projectId: 'c279c58b5d516632863cdf395b7ba7c5',
      
      metadata: const PairingMetadata(
        name: 'Wallet Connect App',
        description: 'Example app description',
        url: 'https://example.com/',
        icons: ['https://example.com/logo.png'],
        redirect: Redirect(
          native: 'web3modalflutter://',
          universal: 'https://reown.com/exampleapp',
          linkMode: true,
        ),
      ),
    );

    await _appKitModal.init();
      Get.put<ReownAppKitModal>(_appKitModal);


    // Start listening for session updates
    _appKitModal.addListener(_handleSessionUpdates);
  }

  void _handleSessionUpdates() {
    // React to session state changes
    if (_appKitModal.isConnected) {
      connectWallet();
    } else {
      walletAddressNotifier.value = null;
      sessionStatusNotifier.value = 'Disconnected from wallet';
    }
  }

  Future<void> connectWallet() async {
    try {
      final session = _appKitModal.isConnected;

      if (session) {
        // Namespace for wallet address retrieval
        String namespace = ReownAppKitModalNetworks.getNamespaceForChainId(
          _appKitModal.selectedChain!.chainId,
        );

        walletAddressNotifier.value = _appKitModal.session?.getAddress(namespace);
        sessionStatusNotifier.value = 'Connected to wallet';
        walletController.walletAddress.value = _appKitModal.session?.getAddress(namespace);
        walletController.isConnected.value  = true;
        walletController.balance.value = _appKitModal.balanceNotifier.value;
        Get.to(MainScreen());
      } else {
        sessionStatusNotifier.value = 'Connection failed or no accounts found.';
      }
    } catch (e) {
      print("Error connecting to wallet: $e");
      sessionStatusNotifier.value = 'Connection failed due to error.';
    }
  }

  @override
  void dispose() {
    _appKitModal.removeListener(_handleSessionUpdates);
    walletAddressNotifier.dispose();
    sessionStatusNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('CRYPTO WALLET',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: _appKitModal.isConnected ? MainScreen() :  Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppKitModalConnectButton(appKit: _appKitModal),
            
            ],
          ),
        ),
      ),
    );
  }
}

