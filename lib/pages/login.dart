import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hgmb/utils/databaseHelper.dart';
import 'package:hgmb/utils/formFields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPassword = true;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.blue,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              MyTextFormField(
                                isEmail: true,
                                hintText: "Email",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                  onPressed: null,
                                ),
                                validator: (emailValue) {
                                  if (emailValue.isEmpty) {
                                    return 'Please enter email';
                                  }
                                  email = emailValue;
                                  return null;
                                },
                              ),
                              MyTextFormField(
                                isPassword: _isPassword,
                                hintText: "Password",
                                suffixIcon: _isPassword
                                    ? IconButton(
                                        onPressed: () => toggle("_isPassword"),
                                        icon: Icon(Icons.visibility_off))
                                    : IconButton(
                                        onPressed: () => toggle("_isPassword"),
                                        icon: Icon(Icons.visibility),
                                      ),
                                validator: (passwordValue) {
                                  if (passwordValue.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  password = passwordValue;
                                  return null;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/resetPassword');
                                  },
                                  child: Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FlatButton(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    child: Text(
                                      _isLoading ? 'Proccessing...' : 'Login',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  color: Colors.teal,
                                  disabledColor: Colors.grey,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0)),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _login();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Create New Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Attempt to login
  void _login() async {
    // check the page is loaded and set the button to the loading state
    if (this.mounted) {
      toggle("_isLoading");
    }
    // format the data as expected by server
    var data = {'email': email, 'password': password};

    // POST data to login route
    var res = await DatabaseHelper().authData(data, 'login');
    // Decode the response from the server
    var body = json.decode(res.body);

    // If the success is true save the token and user, then move the user to the middleware page
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/middleware',
        (Route<dynamic> route) => false,
      );
    }
    // if the success is false, show the message in the snackbar
    else {
      _showMsg(body['message']);
    }

    // set the button to non-loading state
    if (this.mounted) {
      toggle("_isLoading");
    }
  }

  // show message in the scaffold's snackback
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

  void toggle(boolVal) {
    //toggle all the potential booleans
    setState(
      () {
        switch (boolVal) {
          case "_isLoading":
            _isLoading ^= true;
            break;
          case "_isPassword":
            _isPassword ^= true;
            break;
          default:
        }
      },
    );
  }
}
