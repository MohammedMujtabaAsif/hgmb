import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//Pages
import 'package:hgmb/pages/login.dart';
import 'package:hgmb/pages/middleware.dart';

//Services
import 'package:flutter/services.dart';
import 'package:hgmb/utils/routeGenerator.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
        title: 'Hall Green Marriage Bureau App',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.generateRoute,
        home: CheckAuth(),
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('en')]);
  }
}

class CheckAuth extends StatefulWidget {
  @override
  State createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;

  @override
  void initState() {
    if (this.mounted) {
      _checkIfLoggedIn();
      super.initState();
    }
  }

  @override
  void dispose() {
    super.dispose();
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
      child = new MiddlewarePage();
    } else {
      child = new LoginPage();
    }
    return child;
  }
}
