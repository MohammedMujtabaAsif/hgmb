import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hgmb/utils/customCard.dart';
import 'package:hgmb/utils/customCardList.dart';
import 'package:hgmb/utils/confirmButton.dart';
import 'package:hgmb/utils/databaseHelper.dart';
import 'package:hgmb/utils/userProfile.dart';
import 'package:hgmb/utils/formFields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePrivatePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const UserProfilePrivatePage({this.scaffoldKey});
  @override
  State createState() => _UserProfilePrivatePageState();
}

class _UserProfilePrivatePageState extends State<UserProfilePrivatePage>
    with AutomaticKeepAliveClientMixin<UserProfilePrivatePage> {
  String password;
  var db = new DatabaseHelper();
  final _controller = ScrollController();

  Future activeUser;

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
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    activeUser = _getActiveUser();
  }

  _getActiveUser() async {
    var response = await db.getData('user');
    var body = json.decode(response.body);
    User user = User.fromJson(body['data']);
    return user;
  }

  _logout() async {
    var response = await db.getData('logout');
    var body = json.decode(response.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      localStorage.remove('user');
      localStorage.remove('token');
    } else {
      _showMsg(body['message']);
    }
  }

  _deleteAccount() async {
    var response = await db.postData({'password': password}, 'deleteAccount');
    var body = json.decode(response.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    } else {
      _showMsg(body["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _mediaWidth = MediaQuery.of(context).size.width;

    super.build(context);
    return FutureBuilder(
      future: activeUser,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? RefreshIndicator(
                child: ListView(
                  controller: _controller,
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 20, bottom: 10),
                        alignment: Alignment.center,
                        width: _mediaWidth * 0.4,
                        child: snapshot.data.image == null
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
                                  snapshot.data.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    CustomCardList(
                      controller: _controller,
                      title: CustomCard(
                        title: "Your Details",
                        isTitle: true,
                      ),
                      cards: [
                        CustomCard(
                            title: "Full Name",
                            subtitle: snapshot.data.firstNames +
                                " " +
                                snapshot.data.surname),
                        CustomCard(
                            title: "Display Name",
                            subtitle: snapshot.data.prefName),
                        CustomCard(
                            title: "Email", subtitle: snapshot.data.email),
                        CustomCard(
                            title: "Phone Number",
                            subtitle: snapshot.data.phoneNumber),
                        CustomCard(
                            title: "Age",
                            subtitle: snapshot.data.age.toString()),
                        CustomCard(
                            title: "Number of Children",
                            subtitle: snapshot.data.numOfChildren.toString()),
                        CustomCard(
                            title: "Gender",
                            subtitle: snapshot.data.gender.name),
                        CustomCard(
                            title: "City", subtitle: snapshot.data.city.name),
                        CustomCard(
                            title: "Marital Status",
                            subtitle: snapshot.data.maritalStatus.name),
                        CustomCard(
                            title: "Biography", subtitle: snapshot.data.bio),
                      ],
                    ),
                    CustomCardList(
                        controller: _controller,
                        title: CustomCard(
                          title: "What You're Looking For",
                          isTitle: true,
                        ),
                        cards: [
                          CustomCard(
                            title: "Age Range",
                            subtitle: snapshot.data.prefMinAge.toString() +
                                " - " +
                                snapshot.data.prefMaxAge.toString(),
                          ),
                          CustomCard(
                            title: "Max Number of Children",
                            subtitle:
                                snapshot.data.prefMaxNumOfChildren.toString(),
                          ),
                          CustomCard(
                            title: "City",
                            subtitle: snapshot.data.prefCitiesNamesToString(),
                          ),
                          CustomCard(
                            title: "Gender",
                            subtitle: snapshot.data.prefGendersNamesToString(),
                          ),
                          CustomCard(
                            title: "Marital Status",
                            subtitle: snapshot.data
                                .prefMaritalStatusesNamesToString(),
                          ),
                        ]),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          //left
                          _mediaWidth / 4,
                          //top
                          0,
                          //right
                          _mediaWidth / 4,
                          //bottom
                          0),
                      child: FlatButton(
                        color: Colors.blue,
                        child: Text("Update",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/update'),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          //left
                          _mediaWidth / 4,
                          //top
                          0,
                          //right
                          _mediaWidth / 4,
                          //bottom
                          0),
                      child: FlatButton(
                        color: Colors.red,
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          child: ConfirmButton(
                            buttonName: "Logout",
                            buttonColor: Colors.red,
                            buttonMethod: () => _logout(),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          //left
                          _mediaWidth / 4,
                          //top
                          0,
                          //right
                          _mediaWidth / 4,
                          //bottom
                          10),
                      child: FlatButton(
                        color: Colors.red,
                        child: Text(
                          "Delete Account",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            Widget cancelButton = FlatButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            );
                            Widget deleteButton = FlatButton(
                              child: Text(
                                "Delete Account",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  _deleteAccount();
                                }
                              },
                            );
                            return AlertDialog(
                              content: Stack(
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              "Enter your password to delete account"),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: MyTextFormField(
                                            hintText: "Password",
                                            autocorrect: false,
                                            isPassword: true,
                                            validator: (String value) {
                                              if (value.length < 8) {
                                                return "Password must be a minimum of 8 characters";
                                              }
                                              _formKey.currentState.save();
                                              return null;
                                            },
                                            onSaved: (String value) {
                                              password = value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              actions: [cancelButton, deleteButton],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                onRefresh: () => _getActiveUser(),
              )
            : new Center(child: CircularProgressIndicator());
      },
    );
  }
}
