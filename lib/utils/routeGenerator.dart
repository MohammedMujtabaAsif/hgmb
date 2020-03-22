import 'package:flutter/material.dart';
import 'package:hgmb/pages/call.dart';
import 'package:hgmb/pages/landing.dart';
import 'package:hgmb/pages/login.dart';
import 'package:hgmb/pages/matched.dart';
import 'package:hgmb/pages/register.dart';
import 'package:hgmb/pages/userProfilePublic.dart';
import 'package:hgmb/utils/userProfile.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case '/landing':
        return MaterialPageRoute(builder: (_) => LandingPage());
      case '/userProfilePublic':
        // Validation of correct data type
        final User user = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => UserProfilePublic(
            id: user.id.toString(),
            prefName: user.prefName,
            city: user.city,
            maritalStatus: user.maritalStatus,
          ),
        );

      case '/call':
        return MaterialPageRoute(builder: (_) => CallPage());
      case '/matched':
        return MaterialPageRoute(builder: (_) => MatchedPage());

      default:
        // If there is no such named route in the switch statement, e.g. /third
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
