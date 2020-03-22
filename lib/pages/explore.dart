import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hgmb/utils/userListBox.dart';
import 'package:hgmb/utils/databaseHelper.dart';
import 'package:hgmb/utils/userProfile.dart';

class ExplorePage extends StatefulWidget {
  @override
  State createState() => new _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin<ExplorePage> {
  // Future users;
  StreamController<List<User>> _users;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _users = StreamController<List<User>>();
    _getUsers();
  }

  _getUsers() async {
    var db = new DatabaseHelper();
    var users = await db.getUsersAsList('/allUsers');
    setState(() {
      _users.add(users);
    });
    // return users;
  }

  @override
  void dispose() {
    super.dispose();
    _users.close();
  }

  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      body: StreamBuilder(
        stream: _users.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData == true && snapshot.data.length > 0) {
            return new RefreshIndicator(
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: ListView.builder(
                    // scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                        child: new UserListBox(
                          id: snapshot.data[index].id.toString(),
                          prefName: snapshot.data[index].prefName,
                          maritalStatus: snapshot.data[index].maritalStatus,
                          city: snapshot.data[index].city,
                          buttonName: "View Profile",
                          buttonMethod: () {
                            Navigator.of(context).pushNamed(
                                '/userProfilePublic',
                                arguments: snapshot.data[index]);
                          },
                        ),
                      );
                    },
                  ))
                ],
              ),
              onRefresh: () => _getUsers(),
            );
          } else {
            return new Center(
              child: Text(
                snapshot.hasData == true && snapshot.data.length == 0
                    ? "No Users"
                    : "Loading Users",
              ),
            );
          }
        },
      ),
    );
  }
}
