import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final bool selected;
  final String title;
  final bool value;
  final Function onChanged;

  const CustomCheckbox({this.selected, this.title, this.value, this.onChanged});

  @override
  State createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: widget.value,
      onChanged: widget.onChanged,
    );
  }
}
