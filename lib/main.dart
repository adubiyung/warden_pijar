import 'package:flutter/material.dart';
import 'package:warden_pijar/views/pages/home_page.dart';
import 'package:warden_pijar/views/pages/login_page.dart';
import 'package:warden_pijar/views/pages/order_page.dart';
import 'package:warden_pijar/views/pages/otp_page.dart';
import 'package:warden_pijar/views/pages/splashscreen_page.dart';

void main() {
  runApp(
    new MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warden Pijar',
      home: new SplashscreenPage(),
      routes: <String, WidgetBuilder>{
        '/loginPage': (BuildContext context) => new LoginPage(),
        '/splash': (BuildContext context) => new SplashscreenPage(),
        '/home': (BuildContext context) => new HomePage(),
        '/otpPage': (BuildContext context) => new OtpPage(),
        '/orderPage': (BuildContext context) => new OrderPage(),
      },
    );
  }
}
