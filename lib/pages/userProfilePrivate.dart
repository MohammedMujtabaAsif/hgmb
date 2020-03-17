import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hgmb/pages/login.dart';
import 'package:hgmb/utils/databaseHelper.dart';
import 'package:hgmb/utils/userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hgmb/utils/userProfile.dart';
// import 'package:hgmb/utils/databaseHelper.dart';
// import 'package:hgmb/pages/landing.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hgmb/pages/login.dart';

class UserProfilePrivate extends StatefulWidget {
  // final String prefName;
  // final String city;
  // final String maritalStatus;
  // final String imageLocation;

  // const UserProfilePrivate({
  //   Key key,
  //   this.prefName,
  //   this.city,
  //   this.maritalStatus,
  //   this.imageLocation,
  // }) : super(key: key);

  @override
  _UserProfilePrivateState createState() => _UserProfilePrivateState();
}

class _UserProfilePrivateState extends State<UserProfilePrivate> {
  var profileImage;
  _setImage() {
    profileImage = Image.network(
      'https://www.thispersondoesnotexist.com/image',
      fit: BoxFit.cover,
    );
    return profileImage;
  }

  var db = new DatabaseHelper();
  Future activeUser;

  @override
  void initState() {
    super.initState();
    activeUser = _getActiveUser();
    profileImage = _setImage();
  }

  _getActiveUser() async {
    var response = await db.getData('/user');
    var body = json.decode(response.body);
    return new User.fromJson(body);
  }

  _logout() async {
    var response = await db.getData('/logout');
    var body = json.decode(response.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: activeUser,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView(children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 30)),
                      Container(
                          height: 200,
                          width: 200,
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(500.0),
                                  child: Image.network(
                                    'https://www.thispersondoesnotexist.com/image',
                                    fit: BoxFit.fill,
                                  )))),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      UserDetailsBox(
                          title: "Name", data: snapshot.data.prefName),
                      UserDetailsBox(title: "City", data: snapshot.data.city),
                      UserDetailsBox(
                          title: "Marital Status",
                          data: snapshot.data.maritalStatus),
                      FlatButton(
                          onPressed: () {
                            _logout();
                          },
                          child: Text("Log Out"))
                    ])
                  : new Center(child: Text("Loading Profile"));
            }));
  }
}

class UserDetailsBox extends StatefulWidget {
  final String title;
  final String data;

  const UserDetailsBox({
    this.title,
    this.data,
  });

  @override
  _UserDetailsBoxState createState() => _UserDetailsBoxState();
}

class _UserDetailsBoxState extends State<UserDetailsBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(30, 15, 30, 0),
        child: Container(
            decoration: BoxDecoration(border: Border.all()),
            child: Row(children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(5, 15, 5, 15)),
              Text(
                widget.title + ": ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.data),
            ])));
  }
}
