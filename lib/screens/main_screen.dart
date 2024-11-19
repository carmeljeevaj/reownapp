import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_application_reown/screens/order_screen.dart';
import 'package:flutter_application_reown/screens/profile_screen.dart';


class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
    int _page = 0;
    final navigationKey = GlobalKey<CurvedNavigationBarState>();

  final items = [
 Icon(Icons.add, size: 30),
            Icon(Icons.list, size: 30),
           
  ];

  final screens = [
    OrderScreen(),
    ProfileScreen(),
  ];
  @override
  void initState() {
    super.initState();
    _page = 0; 
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,
        automaticallyImplyLeading: false, 
),
      extendBody: true,
      body: screens[_page],
      backgroundColor: Colors.black,
          bottomNavigationBar: CurvedNavigationBar(items: items,
          key: navigationKey,
                    color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          onTap: (value) => setState(() {
            this._page = value;
          }),
          ),
          
    );
  }
}