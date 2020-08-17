import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hgmb/utils/databaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MiddlewarePage extends StatefulWidget {
  const MiddlewarePage({
    Key key,
  }) : super(key: key);

  @override
  State createState() => _MiddlewarePageState();
}

class _MiddlewarePageState extends State<MiddlewarePage> {
  StreamController<String> _check;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var db = new DatabaseHelper();
  Timer timer30;
  int errorType;

  @override
  void initState() {
    super.initState();
    _check = StreamController<String>();
    _verify();
    timer30 = new Timer.periodic(
      Duration(seconds: 30),
      (Timer t) => setState(
        () {
          _verify();
        },
      ),
    );
  }

  _logout() async {
    var response = await db.getData('logout');
    var body = json.decode(response.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    } else {
      _showMsg(body['message']);
    }
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _verify() async {
    var res = await db.getData('verify');
    var body = json.decode(res.body);
    if (this.mounted) {
      setState(
        () {
          if (!body['success']) {
            errorType = res.statusCode;
            _check.add(body['message']);
          } else {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/landing', (route) => false);
          }
        },
      );
    }
  }

  _sendVerificationEmail() async {
    var res = await db.getData('email/resend');
    var body = json.decode(res.body);
    if (this.mounted) {
      setState(
        () {
          if (body['message'] != null) {
            _showMsg(body['message']);
          }
        },
      );
    }
  }

  @override
  void dispose() {
    timer30.cancel();
    _check.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    double positionedPadding = MediaQuery.of(context).size.width / 4;
    double bottomPadding = 30;
    double spacing = 50;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Verification"),
      ),
      body: StreamBuilder(
        stream: _check.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData == true && snapshot.data.length > 0) {
            return RefreshIndicator(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            color: errorType == 401
                                ? Color.fromRGBO(255, 0, 0, 100)
                                : Color.fromRGBO(255, 152, 0, 100),
                            onPressed: () => null,
                            child: Text(
                              errorType == 402
                                  ? "Unapproved"
                                  : errorType == 401
                                      ? "BANNED"
                                      : errorType == 429
                                          ? "Slow Down"
                                          : "Verify Email",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 100),
                        width: MediaQuery.of(context).size.width * .8,
                        child: Center(
                          child: Text(
                            snapshot.data.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView(),
                  Positioned(
                    child: errorType == 403
                        ? FlatButton(
                            child: Text(
                              "Send Email",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.green,
                            onPressed: () => _sendVerificationEmail(),
                          )
                        : Container(),
                    right: positionedPadding,
                    left: positionedPadding,
                    bottom: bottomPadding + (2 * spacing),
                  ),
                  Positioned(
                    child: errorType == 402 || errorType == 403
                        ? FlatButton(
                            child: Text(
                              "Update Details",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/update'),
                          )
                        : Container(),
                    right: positionedPadding,
                    left: positionedPadding,
                    bottom: bottomPadding + spacing,
                  ),
                  Positioned(
                    child: FlatButton(
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                      onPressed: () => _logout(),
                    ),
                    right: positionedPadding,
                    left: positionedPadding,
                    bottom: bottomPadding,
                  ),
                ],
              ),
              onRefresh: () => _verify(),
            );
          } else {
            return new Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
