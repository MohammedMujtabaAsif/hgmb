import 'package:flutter/material.dart';

class RefreshWithMessage extends StatefulWidget {
  final String messageData;
  final VoidCallback onRefresh;
  const RefreshWithMessage({this.messageData, this.onRefresh});
  State createState() => new RefreshWithMessageState();
}

class RefreshWithMessageState extends State<RefreshWithMessage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Center(child: Text(widget.messageData)),
          ),
        ],
      ),
      onRefresh: widget.onRefresh,
    );
  }
}
