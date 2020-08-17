import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:hgmb/utils/refreshWithMessage.dart';
import 'package:hgmb/utils/userListBox.dart';
import 'package:hgmb/utils/databaseHelper.dart';
import 'package:hgmb/utils/userProfile.dart';

class ExplorePage extends StatefulWidget {
  final ScrollController scrollController;
  const ExplorePage({this.scrollController});
  @override
  State createState() => new _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin<ExplorePage> {
  StreamController<List<User>> _users;

  List<User> users = new List<User>();
  var db = new DatabaseHelper();
  int _pageNum;
  bool _messageExists = false;
  bool _isLoading = false;
  String _messageData = "";

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder(
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
                    controller: widget.scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
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
                              buttonName: "View Profile",
                              buttonMethod: () {
                                Navigator.of(context).pushNamed(
                                    '/userProfilePublic',
                                    arguments: snapshot.data[index]);
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
                      _pageNum = 1;
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
                _pageNum = 1;
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

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    if (this.mounted) {
      super.initState();
      _pageNum = 1;
      _users = StreamController<List<User>>();
      _getUsers();

      // add a listener to the scrollcontroller
      // to check the user has reached the end of the page
      widget.scrollController.addListener(() {
        // if the user has reached the end of the page, get more users
        if (widget.scrollController.position.pixels ==
            widget.scrollController.position.maxScrollExtent) {
          _getUsers();
        }
      });
    }
  }

  _getUsers() async {
    // check page is loaded
    if (this.mounted) {
      setState(() {
        // show the loading icon
        _isLoading = true;
      });
    }

    var res = await db.postData({'pageNum': _pageNum}, 'allOtherUsers');
    var body = json.decode(res.body);

    //if the json has unsuccessful message
    if (!body['success']) {
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
      } else {
        // Decrement the counter to solve issue of current page index no longer existing
        // it will be reincreased later if the page index did exist
        _pageNum--;

        //if they are still approved, display the error message
        _messageExists = true;
        _messageData = body['message'];
      }
    }
    //if the json has a successful message
    else {
      // reset _messageExists to false to stop displaying message
      _messageExists = false;

      // add the users to the list of users
      users += await db.getUsersAsList(body['data']);

      // check if there is a next page
      res = await db.postData({'pageNum': _pageNum + 1}, 'allOtherUsers');
      body = json.decode(res.body);
      // if a next page exists, increase the counter
      if (body['success']) {
        // increase the _pageNum counter
        _pageNum++;
      }
      // remove duplicates from the list of users
      final tempUserList = users.map((e) => e.id).toSet();
      users.retainWhere((x) => tempUserList.remove(x.id));
    }
    if (this.mounted) {
      setState(
        () {
          // stop displaying loading icon
          _isLoading = false;

          // if users exist, add them to the stream
          if ((users).isNotEmpty) {
            _users.add(users);
          }
        },
      );
    }
  }

  @override
  void dispose() {
    // dispose of users stream when page is unloaded
    _users.close();
    super.dispose();
  }
}
