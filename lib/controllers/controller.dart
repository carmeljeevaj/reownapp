import 'package:get/get.dart';
import 'package:reown_appkit/reown_appkit.dart';

class WalletController extends GetxController {
  // Using Rx variables to store wallet address and balance
  var walletAddress = Rx<String?>(null);
  var balance = Rx<String>('0.1');
  var isConnected = RxBool(false); // To track the connection state
  // Initialize the app kit modal
  



}
