import 'package:flutter/material.dart';
import 'package:hgmb/utils/customCheckbox.dart';

class CustomCheckboxList extends StatefulWidget {
  final String title;
  final List<CustomCheckbox> checkboxList;
  final ScrollController controller;

  const CustomCheckboxList({this.controller, this.title, this.checkboxList});

  @override
  State createState() => CustomCheckboxListState();
}

class CustomCheckboxListState extends State<CustomCheckboxList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10, left: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          ListView.builder(
            controller: widget.controller,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.checkboxList.length,
            itemBuilder: (BuildContext context, int index) {
              return widget.checkboxList[index];
            },
          ),
        ],
      ),
    );
  }
}
