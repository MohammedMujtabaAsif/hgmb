import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hgmb/utils/databaseHelper.dart';
import 'package:hgmb/utils/userListBox.dart';

class PendingPage extends StatefulWidget {
  _PendingPageState createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  var db = new DatabaseHelper();
  Future requests;

  @override
  void initState() {
    super.initState();
    requests = _getMatchRequests();
  }

  _getMatchRequests() async {
    var res = await db.getData('/getMatchRequests');
    List<dynamic> body = json.decode(res.body);
    print(body);
    return body;
  }

  _acceptMatchRequest(data) async {
    var res = await db.postData(data, '/acceptMatchRequest');
    var body = json.decode(res.body);
    print(body);
  }

  _denyMatchRequest(data) async {
    var res = await db.postData(data, '/denyMatchRequest');
    var body = json.decode(res.body);
    print(body);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 10),
        child: FutureBuilder(
          future: requests,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        new UserListBox(
                          id: snapshot.data[index]['sender']['sender'],
                          prefName: snapshot.data[index]['sender']['prefName'],
                          maritalStatus: snapshot.data[index]['sender']
                              ['maritalStatus'],
                          city: snapshot.data[index]['sender']['city'],
                          buttonName: "Decision",
                          buttonMethod: () {
                            // set up the buttons
                            Widget cancelButton = FlatButton(
                              child: Text("Accept"),
                              onPressed: () {
                                _acceptMatchRequest(
                                    snapshot.data[index]['sender']);
                                Navigator.pop(context);
                              },
                            );
                            Widget continueButton = FlatButton(
                              child: Text("Deny"),
                              onPressed: () {
                                _denyMatchRequest(
                                    snapshot.data[index]['sender']);
                                Navigator.pop(context);
                              },
                            );

                            // set up the AlertDialog
                            AlertDialog alert = AlertDialog(
                              title: Text("AlertDialog"),
                              content: Text("Would you like to match with " +
                                  snapshot.data[index]['sender']['prefName'] +
                                  "?"),
                              actions: [
                                cancelButton,
                                continueButton,
                              ],
                            );

                            // show the dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasData == true && snapshot.data.length == 0) {
              return new Center(
                child: Text(
                  "No Requests",
                  // textAlign: TextAlign.center,
                ),
              );
            } else {
              return new Center(
                child: Text(
                  "Loading Requests",
                  // textAlign: TextAlign.center,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
