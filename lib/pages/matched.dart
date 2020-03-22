import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hgmb/utils/databaseHelper.dart';
import 'package:hgmb/utils/userListBox.dart';

class MatchedPage extends StatefulWidget {
  _MatchedPageState createState() => _MatchedPageState();
}

class _MatchedPageState extends State<MatchedPage> {
  var db = new DatabaseHelper();
  Future matched;

  @override
  void initState() {
    super.initState();
    matched = _getMatched();
  }

  _getMatched() async {
    var res = await db.getUsersAsList('/getMatchedUsers');
    // var body = json.decode(res.body);
    // print(body);
    return res;
  }

  _unfriend(data) async {
    print(data);
    var res = await db.postData({'id': data}, '/unmatch');
    var body = json.decode(res.body);
    print(body);
    return body;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //TODO: Change FutureBuilders to StreamBuilders
      body: FutureBuilder(
          future: matched,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData == true && snapshot.data.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                    child: Column(children: <Widget>[
                      // Text(snapshot.data[index].id.toString(),),
                      new UserListBox(
                        id: snapshot.data[index].id.toString(),
                        prefName: snapshot.data[index].prefName,
                        maritalStatus: snapshot.data[index].maritalStatus,
                        city: snapshot.data[index].city,
                        buttonName: "Remove Friend",
                        buttonMethod: () {
                          // set up the buttons
                          Widget continueButton = FlatButton(
                            child: Text("Remove"),
                            onPressed: () {
                              _unfriend(snapshot.data[index].id.toString());
                              Navigator.of(context).pop();
                            },
                          );
                          Widget cancelButton = FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );

                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title: Text("AlertDialog"),
                            content: Text(
                                "Are you sure you want to unmatch with " +
                                    snapshot.data[index].prefName +
                                    "?"),
                            actions: [
                              cancelButton,
                              continueButton,
                            ],
                          );

                          // setState(() {
                          //   initState();
                          // });
                          // show the dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          ).then((value) {
                            setState(() {});
                          });
                        },
                      ),
                    ]),
                  );
                },
              );
            } else if (snapshot.hasData == true && snapshot.data.length == 0) {
              return new Center(
                child: Text(
                  "No Matches",
                  // textAlign: TextAlign.center,
                ),
              );
            } else {
              return new Center(
                child: Text(
                  "Loading Matches",
                  // textAlign: TextAlign.center,
                ),
              );
            }
          }),
    );
  }
}
