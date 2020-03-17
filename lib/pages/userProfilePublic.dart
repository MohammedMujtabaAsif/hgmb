// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hgmb/pages/landing.dart';
// import 'call.dart';
// import 'package:hgmb/utils/userProfile.dart';
// import 'package:hgmb/utils/databaseHelper.dart';
// import 'package:hgmb/pages/landing.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:hgmb/pages/login.dart';

class UserProfilePublic extends StatefulWidget {
  final String prefName;
  final String city;
  final String maritalStatus;
  final String imageLocation;

  const UserProfilePublic({
    Key key,
    this.prefName,
    this.city,
    this.maritalStatus,
    this.imageLocation,
  }) : super(key: key);

  @override
  _UserProfilePublicState createState() => _UserProfilePublicState();
}

class _UserProfilePublicState extends State<UserProfilePublic> {
  var profileImage;
  _setImage() {
    profileImage = Image.network(
      'https://www.thispersondoesnotexist.com/image',
      fit: BoxFit.cover,
    );
    return profileImage;
  }

  @override
  void initState() {
    super.initState();
    profileImage = _setImage();
  }

  @override
  Widget build(BuildContext context) {
    var _mediaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        backgroundColor: Colors.transparent,
        floating: false,
        leading:
            // CloseButton(),
            FlatButton(
                child: new Text(
                  "X",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: Colors.blue,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(360)),
                onPressed: () {
                  Navigator.pop(context);
                }),
        iconTheme: IconThemeData(color: Colors.white, opacity: 1.0),
        pinned: false,
        expandedHeight: _mediaHeight * .7,
        flexibleSpace: new FlexibleSpaceBar(
            background: widget.imageLocation == null
                ? _setImage()
                : Image.network(
                    widget.imageLocation,
                    fit: BoxFit.cover,
                  )),
      ),
      new SliverFixedExtentList(
          itemExtent: 1000,
          delegate: new SliverChildListDelegate(
            [
              Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: new Column(children: <Widget>[
                    Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
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
                                  child: Text("Call"),
                                  color: Colors.blue,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                LandingPage()));
                                  },
                                )))
                      ],
                    )),
                  ]))
            ],
          ))
    ]));
  }
}
