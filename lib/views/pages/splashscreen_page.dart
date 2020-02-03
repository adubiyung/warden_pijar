import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warden_pijar/views/pages/home_page.dart';
import 'package:warden_pijar/views/pages/login_page.dart';
import 'package:warden_pijar/views/widgets/session_manager.dart';

class SplashscreenPage extends StatefulWidget {
  @override
  _SplashscreenPageState createState() => _SplashscreenPageState();
}

class _SplashscreenPageState extends State<SplashscreenPage> {
  SessionManager _session;

  void checkLogin() async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    if (_session.isLoggedIn() != null && _session.isLoggedIn()) {
      _moveToHome();
    } else {
      _moveToLogin();
    }
  }
  
  @override
  void initState() {
    super.initState();
    new Timer(const Duration(seconds: 3), checkLogin);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_img.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _moveToLogin() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new LoginPage(),
        transitionDuration: const Duration(seconds: 2),
        transitionsBuilder: (context, anim1, anim2, child) {
          return new FadeTransition(
            child: child,
            opacity: anim1,
          );
        }));
  }

  void _moveToHome() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new HomePage(),
        transitionDuration: const Duration(seconds: 2),
        transitionsBuilder: (context, anim1, anim2, child) {
          return new FadeTransition(
            child: child,
            opacity: anim1,
          );
        }));
  }
}
