import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hgmb/utils/customCard.dart';
import 'package:hgmb/utils/customCardList.dart';
import 'package:hgmb/utils/databaseHelper.dart';
import 'package:hgmb/utils/userProfile.dart';

class UserProfilePublicPage extends StatefulWidget {
  final User u;

  const UserProfilePublicPage({
    Key key,
    this.u,
  }) : super(key: key);

  @override
  State createState() => _UserProfilePublicPageState();
}

class _UserProfilePublicPageState extends State<UserProfilePublicPage>
    with AutomaticKeepAliveClientMixin<UserProfilePublicPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController controller;
  var db = new DatabaseHelper();
  User u;



  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    u = widget.u;
    controller = ScrollController();
  }

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

  Future<void> sendMatchRequest() async {
    var data = {'id': widget.u.id};
    var res = await db.postData(data, 'sendFriendRequest');
    var body = json.decode(res.body);

    _showMsg(body['message']);
  }

  @override
  Widget build(BuildContext context) {
    var _mediaWidth = MediaQuery.of(context).size.width;
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: BackButton(),
        title: Text(widget.u.prefName),
      ),
      body: ListView(
        controller: controller,
        shrinkWrap: true,
        children: [
          Column(
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  alignment: Alignment.center,
                  width: _mediaWidth * 0.4,
                  child: widget.u.image == null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          // Placeholder image for a user
                          // Free for commercial use
                          // No attribution required
                          child: Image.network(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                            fit: BoxFit.fill,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(200.0),
                          child: Image.file(
                            widget.u.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              CustomCardList(
                controller: controller,
                title: CustomCard(
                  title: "User Details",
                  isTitle: true,
                ),
                cards: [
                  CustomCard(title: "Name", subtitle: widget.u.prefName),
                  CustomCard(title: "Age", subtitle: widget.u.age.toString()),
                  CustomCard(
                      title: "Number of Children",
                      subtitle: widget.u.numOfChildren.toString()),
                  CustomCard(title: "Gender", subtitle: widget.u.gender.name),
                  CustomCard(title: "City", subtitle: widget.u.city.name),
                  CustomCard(
                      title: "Marital Status",
                      subtitle: widget.u.maritalStatus.name),
                  CustomCard(title: "Biography", subtitle: widget.u.bio),
                ],
              ),
              CustomCardList(
                controller: controller,
                title: CustomCard(title: "Looking For", isTitle: true),
                cards: [
                  CustomCard(
                      title: "City",
                      subtitle: widget.u.prefCitiesNamesToString()),
                  CustomCard(
                      title: "Gender",
                      subtitle: widget.u.prefGendersNamesToString()),
                  CustomCard(
                      title: "Marital Status",
                      subtitle: widget.u.prefMaritalStatusesNamesToString()),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: FlatButton(
                  child: Text(
                    "Request Match",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    sendMatchRequest();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
