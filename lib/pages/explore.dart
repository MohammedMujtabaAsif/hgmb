import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hgmb/pages/userProfilePublic.dart';
import 'package:hgmb/utils/userProfile.dart';
import 'package:hgmb/utils/databaseHelper.dart';

class ExplorePage extends StatefulWidget {
  @override
  State createState() => new ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> {
  var db = new DatabaseHelper();
  Future users;

  @override
  void initState() {
    super.initState();
    users = _getUsers();
  }

  _getUsers() async {
    var response = await db.getData('/allUsers');
    var body = json.decode(response.body);
    if (body != null) {
      List<User> _usersList = new List();
      int index = 0;
      while (index < body.length) {
        User _user = new User.fromJson(body[index]);
        if (_user != null) {
          _usersList.add(_user);
          print("user " + (_user.prefName).toString() + " added");
        } else {
          print("user is null");
        }
        index++;
      }
      return _usersList;
    }
  }

  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      body: FutureBuilder(
        future: users,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Padding(
                      padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                      child: Column(children: <Widget>[
                        new UserListBox(
                          mediaWidth: mediaWidth,
                          prefName: snapshot.data[index].prefName,
                          maritalStatus: snapshot.data[index].maritalStatus,
                          city: snapshot.data[index].city,
                        ),
                      ]),
                    );
                  },
                )
              : new Center(
                  child: Text(
                  "Loading Users",
                  // textAlign: TextAlign.center,
                ));
        },
      ),
    );
  }
}

class UserListBox extends StatefulWidget {
  final double mediaWidth;
  final String prefName;
  final String city;
  final String maritalStatus;
  final String imageLocation;

  const UserListBox(
      {Key key,
      this.mediaWidth,
      this.prefName,
      this.city,
      this.maritalStatus,
      this.imageLocation})
      : super(key: key);

  @override
  UserListBoxState createState() => UserListBoxState();
}

class UserListBoxState extends State<UserListBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0)),
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                Widget>[
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Container(
                          child: widget.imageLocation == null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                    'https://www.thispersondoesnotexist.com/image',
                                    fit: BoxFit.fill,
                                  ))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(200.0),
                                  child: Image.network(
                                    widget.imageLocation,
                                    fit: BoxFit.cover,
                                  ))))),
              Expanded(
                  flex: 2,
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(widget.prefName,
                              style: TextStyle(
                                  // decoration: TextDecoration.underline,
                                  )),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(widget.city,
                              style: TextStyle(
                                  // decoration: TextDecoration.underline,
                                  )),
                        ),
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(widget.maritalStatus,
                              style: TextStyle(
                                  // decoration: TextDecoration.underline,
                                  )),
                        ),
                      ])),
              Expanded(
                  flex: 1,
                  child: FittedBox(
                      fit: BoxFit.cover,
                      child: FlatButton(
                        child: Text("View Profile"),
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => UserProfilePublic(
                                        prefName: widget.prefName,
                                        city: widget.city,
                                        maritalStatus: widget.maritalStatus,
                                      )));
                        },
                      ))),
            ])));
  }
}
