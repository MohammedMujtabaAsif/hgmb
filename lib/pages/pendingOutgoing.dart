import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hgmb/utils/confirmButton.dart';
import 'package:hgmb/utils/databaseHelper.dart';
import 'package:hgmb/utils/refreshWithMessage.dart';
import 'package:hgmb/utils/userListBox.dart';
import 'package:hgmb/utils/userProfile.dart';

class PendingOutgoingPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const PendingOutgoingPage({
    this.scaffoldKey,
  });
  State createState() => _PendingOutgoingPageState();
}

class _PendingOutgoingPageState extends State<PendingOutgoingPage> {
  StreamController<List<User>> _users;
  ScrollController _sc = new ScrollController();
  List<User> users = new List<User>();
  var db = new DatabaseHelper();
  // int _pageNum;
  bool _messageExists = false;
  bool _isLoading = false;
  String _messageData = "";

  @override
  void initState() {
    super.initState();
    // _pageNum = 1;
    _users = StreamController<List<User>>();
    _getUsers();

    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getUsers();
      }
    });
  }

  _getUsers() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    await new Future.delayed(const Duration(seconds: 1));

    var res = await db.getData('outgoingRequests');
    var body = json.decode(res.body);
    if (!body['success']) {
      _messageExists = true;
      _messageData = body['message'];

      // check user is still approved
      bool approved = await db.verify();
      if (!approved) {
        // if they are not approved, return them to middleware page (lock them out)
        setState(
          () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/middleware', (route) => false);
          },
        );
      }
    } else {
      _messageExists = false;
      users += await db.getUsersAsList(body['data']);

      final tempUserList = users.map((e) => e.id).toSet();
      users.retainWhere((x) => tempUserList.remove(x.id));
    }
    if (this.mounted) {
      setState(
        () {
          if ((users).isNotEmpty) {
            _users.add(users);
          }
          _isLoading = false;
        },
      );
    }
  }

  _deleteMatchRequest(data) async {
    var res = await db.postData({'id': data}, "deleteFriendRequest");
    var body = json.decode(res.body);
    _messageExists = false;
    _showMsg(body['message']);
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    widget.scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void dispose() {
    super.dispose();
    _sc.dispose();
    _users.close();
  }

  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: _users.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && !_messageExists) {
          return new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _sc,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: false,
                    itemCount: snapshot.data.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == snapshot.data.length) {
                        return new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Center(
                            child: new Opacity(
                              opacity: _isLoading ? 1 : 0,
                              child: new CircularProgressIndicator(),
                            ),
                          ),
                        );
                      } else {
                        return new InkWell(
                          onTap: () => Navigator.of(context).pushNamed(
                              '/userProfilePublic',
                              arguments: snapshot.data[index]),
                          enableFeedback: true,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                            child: new UserListBox(
                              u: snapshot.data[index],
                              buttonName: "Delete",
                              buttonMethod: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmButton(
                                      buttonColor: Colors.red,
                                      buttonMessage:
                                          "Are you sure you want to delete your match request to " +
                                              snapshot.data[index].prefName +
                                              "?",
                                      buttonMethod: () {
                                        _deleteMatchRequest(
                                            snapshot.data[index].id);
                                        Navigator.of(context).pop();
                                      },
                                      buttonName: "Request Deletion",
                                    );
                                  },
                                ).then((value) {
                                  setState(() {
                                    // if (this.mounted) {
                                    users = [];
                                    // _pageNum = 1;
                                    _getUsers();
                                  });
                                });
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  onRefresh: () async {
                    setState(() {
                      users = [];
                      // _pageNum = 1;
                      _getUsers();
                    });
                  },
                ),
              ),
            ],
          );
        } else if (_messageExists) {
          return RefreshWithMessage(
            messageData: _messageData,
            onRefresh: () async {
              setState(() {
                users = [];
                // _pageNum = 1;
                _getUsers();
              });
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
