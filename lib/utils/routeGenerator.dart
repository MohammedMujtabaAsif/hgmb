import 'package:flutter/material.dart';
import 'package:hgmb/pages/landing.dart';
import 'package:hgmb/pages/login.dart';
import 'package:hgmb/pages/matched.dart';
import 'package:hgmb/pages/register.dart';
import 'package:hgmb/pages/middleware.dart';
import 'package:hgmb/pages/resetPassword.dart';
import 'package:hgmb/pages/update.dart';
import 'package:hgmb/pages/userProfilePublic.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case '/resetPassword':
        return MaterialPageRoute(builder: (_) => ResetPasswordPage());
      case '/middleware':
        return MaterialPageRoute(builder: (_) => MiddlewarePage());
      case '/landing':
        return MaterialPageRoute(builder: (_) => LandingPage());
      case '/userProfilePublic':
        return MaterialPageRoute(
          builder: (_) => UserProfilePublicPage(
            u: settings.arguments,
          ),
        );
      case '/matched':
        return MaterialPageRoute(builder: (_) => MatchedPage());
      case '/update':
        return MaterialPageRoute(builder: (_) => UpdatePage());

      default:
        // If there is no such named route in the switch statement
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Invalid Page'),
        ),
      );
    });
  }
}
