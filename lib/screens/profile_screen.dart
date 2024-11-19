

import 'package:flutter/material.dart';
import 'package:flutter_application_reown/controllers/controller.dart';
import 'package:flutter_application_reown/main.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {



  WalletController walletController = Get.find<WalletController>();
    final ReownAppKitModal appKitModal = Get.find<ReownAppKitModal>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        
          automaticallyImplyLeading: false, 
          
        actions: [IconButton(onPressed: (){
          appKitModal.disconnect();
          Get.offAll(WalletConnectScreen());

        }, icon: Icon(Icons.logout,color: Colors.white,))],
        centerTitle: true,title: Text("Profile",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.transparent,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 60,
              child: Image.asset("assets/images/man.png"),
            ),
          ),
          SizedBox(height: 20,),
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 20),
                             child: Text("Wallet Address",style: TextStyle(color: Colors.white38),),
                           ),

          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Container(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [ 
                    Image.asset("assets/images/wallet.png",height: 30,width: 30,),
                    // Icon(Icons.wallet,size: 46,color: Colors.yellowAccent,),
                    Text("${walletController.walletAddress.value}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 9),)


                    
                  ],
                ),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
          ),
 Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 20),
                             child: Text("Wallet Balance",style: TextStyle(color: Colors.white38),),
                           ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Container(

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [ 
                    Text("${walletController.balance.value}",style: TextStyle(fontWeight: FontWeight.bold),)


                    
                  ],
                ),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}