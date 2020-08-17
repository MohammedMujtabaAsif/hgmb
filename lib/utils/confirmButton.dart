import 'package:flutter/material.dart';

class ConfirmButton extends StatefulWidget {
  final String buttonName;
  final Color buttonColor;
  final String buttonMessage;
  final VoidCallback buttonMethod;

  const ConfirmButton({
    Key key,
    this.buttonName,
    this.buttonColor,
    this.buttonMessage,
    this.buttonMethod,
  }) : super(key: key);

  @override
  State createState() => ConfirmButtonState();
}

class ConfirmButtonState extends State<ConfirmButton> {
  @override
  Widget build(BuildContext context) {
    Widget methodButton = FlatButton(
      child:
          Text(widget.buttonName, style: TextStyle(color: widget.buttonColor)),
      onPressed: widget.buttonMethod,
    );
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    return AlertDialog(
      title: Text(
        "Confirm " + widget.buttonName + "?",
        style: TextStyle(fontSize: 18),
      ),
      content: Text(
        widget.buttonMessage == null
            ? "Are you sure you want to " + widget.buttonName + "?"
            : widget.buttonMessage,
        style: TextStyle(fontSize: 14),
      ),
      actions: [
        cancelButton,
        methodButton,
      ],
    );
  }
}
