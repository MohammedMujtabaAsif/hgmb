// import 'dart:convert';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hgmb/utils/databaseHelper.dart';
// import 'package:hgmb/utils/userProfile.dart';
// import 'package:hgmb/utils/databaseHelper.dart';

class UserProfilePublic extends StatefulWidget {
  final String id;
  final String prefName;
  final String city;
  final String maritalStatus;
  final String imageLocation;

  const UserProfilePublic({
    Key key,
    this.id,
    this.prefName,
    this.city,
    this.maritalStatus,
    this.imageLocation,
  }) : super(key: key);

  @override
  _UserProfilePublicState createState() => _UserProfilePublicState();
}

class _UserProfilePublicState extends State<UserProfilePublic>
    with AutomaticKeepAliveClientMixin<UserProfilePublic> {
  var profileImage;
  _setImage() {
    profileImage = Image.network(
      'https://www.thispersondoesnotexist.com/image',
      fit: BoxFit.cover,
    );
    return profileImage;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    profileImage = _setImage();
  }

  Future<void> sendFriendRequest() async {
    var db = new DatabaseHelper();
    var data = {'id': widget.id};
    var res = await db.postData(data, '/sendMatchRequest');
    var body = json.decode(res.body);
    print(body);
  }

  @override
  Widget build(BuildContext context) {
    var _mediaHeight = MediaQuery.of(context).size.height;
    super.build(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            floating: false,
            pinned: false,
            expandedHeight: _mediaHeight * .7,
            leading: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                child: Center(
                  child: CloseButton(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            flexibleSpace: new FlexibleSpaceBar(
              background: widget.imageLocation == null
                  ? _setImage()
                  : Image.network(
                      widget.imageLocation,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          new SliverFixedExtentList(
            itemExtent: 1000,
            delegate: new SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: new Column(
                  children: <Widget>[
                    Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Padding(
                        //   padding: EdgeInsets.all(10.0),
                        //   child: Text(
                        //     widget.id.toString(),
                        //     style: TextStyle(
                        //         fontSize: 24, fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            widget.prefName,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            widget.city,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            widget.maritalStatus,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: FlatButton(
                              child: Text(
                                "Request Match",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.blue,
                              onPressed: () {
                                sendFriendRequest();
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
