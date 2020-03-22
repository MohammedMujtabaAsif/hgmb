import 'package:flutter/material.dart';

class UserListBox extends StatefulWidget {
  final String id;
  final String prefName;
  final String city;
  final String maritalStatus;
  final String imageLocation;
  final String buttonName;
  final VoidCallback buttonMethod;

  const UserListBox({
    Key key,
    this.id,
    this.prefName,
    this.city,
    this.maritalStatus,
    this.imageLocation,
    this.buttonName,
    this.buttonMethod,
  }) : super(key: key);

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
                      // crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: Text(widget.buttonName),
                        color: Colors.blue,
                        onPressed: widget.buttonMethod,
                      ))),
            ])));
  }
}
