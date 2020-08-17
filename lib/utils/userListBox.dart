import 'package:flutter/material.dart';
import 'package:hgmb/utils/userProfile.dart';

class UserListBox extends StatefulWidget {
  final User u;
  final String buttonName;
  final VoidCallback buttonMethod;

  const UserListBox({
    Key key,
    this.u,
    this.buttonName,
    this.buttonMethod,
  }) : super(key: key);

  @override
  State createState() => UserListBoxState();
}

class UserListBoxState extends State<UserListBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        child: ListTile(
          leading: widget.u.image == null
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
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.file(
                    widget.u.image,
                    fit: BoxFit.cover,
                  ),
                ),
          title: Text(
            widget.u.prefName + ", " + widget.u.age.toString(),
            textAlign: TextAlign.center,
          ),
          subtitle: Text(
            widget.u.city.name + "\n" + widget.u.maritalStatus.name,
            textAlign: TextAlign.center,
          ),
          isThreeLine: true,
          trailing: widget.buttonName != null && widget.buttonMethod != null
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    child: Text(
                      widget.buttonName,
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed: widget.buttonMethod,
                  ),
                )
              : Text(widget.u.city.name + "\n" + widget.u.age.toString()),
        ),
      ),
    );
  }
}
