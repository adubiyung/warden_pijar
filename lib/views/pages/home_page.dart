import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:warden_pijar/views/pages/account_page.dart';
import 'package:warden_pijar/views/pages/dashboard_page.dart';
import 'package:warden_pijar/views/pages/location_page.dart';
import 'package:warden_pijar/views/pages/lot_page.dart';
import 'package:warden_pijar/views/pages/order_page.dart';
import 'package:warden_pijar/views/pages/scanner_page.dart';
import 'package:warden_pijar/views/widgets/color_library.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;

  final _pageOption = [
    DashboardPage(),
    // LotPage(),
    LocationPage(),
    ScannerPage(),
    OrderPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: ColorLibrary.primary,
        selectedIndex: _page,
        showElevation: true,
        onItemSelected: (index) => setState((){
          _page = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.dashboard),
            title: Text("Dashboard"),
            activeColor: ColorLibrary.secondary,
            inactiveColor: ColorLibrary.thinFontWhite
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.straighten),
            title: Text("Lot"),
            activeColor: ColorLibrary.secondary,
            inactiveColor: ColorLibrary.thinFontWhite
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.search),
            title: Text("Scan"),
            activeColor: ColorLibrary.secondary,
            inactiveColor: ColorLibrary.thinFontWhite
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.reorder),
            title: Text("Orders"),
            activeColor: ColorLibrary.secondary,
            inactiveColor: ColorLibrary.thinFontWhite
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text("Account"),
            activeColor: ColorLibrary.secondary,
            inactiveColor: ColorLibrary.thinFontWhite
          ),
        ],
      ),
      body: _pageOption[_page],
    );
  }
}
