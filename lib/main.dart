import 'package:flutter/material.dart';

//Pages
import 'package:hgmb/pages/login.dart';
import 'package:hgmb/pages/landing.dart';

//Services
import 'package:flutter/services.dart';
import 'package:hgmb/utils/routeGenerator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() => runApp(new MaterialApp(home: new LandingPage()));

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'HGMB',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = LandingPage();
    } else {
      child = LoginPage();
    }
    return Scaffold(
      body: child,
    );
  }
}
