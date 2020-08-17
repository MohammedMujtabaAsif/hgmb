import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final initialValue;
  final String hintText;
  final Function validator;
  final Function onSaved;
  final VoidCallback onTap;
  final IconButton suffixIcon;
  final int maxLength;
  final bool autocorrect;
  final bool isPassword;
  final bool isEmail;
  final bool isNumber;
  final bool isBio;
  final bool readOnly;
  final bool textCapitalisation;

  MyTextFormField({
    this.controller,
    this.initialValue,
    this.hintText,
    this.validator,
    this.onSaved,
    this.onTap,
    this.maxLength,
    this.suffixIcon,
    this.autocorrect = true,
    this.isPassword = false,
    this.isEmail = false,
    this.isNumber = false,
    this.readOnly = false,
    this.isBio = false,
    this.textCapitalisation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        textCapitalization: textCapitalisation == true
            ? TextCapitalization.sentences
            : TextCapitalization.none,
        initialValue: initialValue,
        maxLines: isBio == true ? null : 1,
        maxLength: maxLength,
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintText: hintText,
          contentPadding: EdgeInsets.all(15),
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
          filled: false,
        ),
        obscureText: isPassword ? true : false,
        autocorrect: autocorrect,
        validator: validator,
        onSaved: onSaved,
        keyboardType: isEmail == true
            ? TextInputType.emailAddress
            : isNumber == true ? TextInputType.number : TextInputType.text,
        onTap: onTap,
        inputFormatters: isNumber == true
            ? [WhitelistingTextInputFormatter.digitsOnly]
            : [FilteringTextInputFormatter.deny('')],
      ),
    );
  }
}

class MyDropDownFormField extends StatefulWidget {
  final String userValue;
  final String hintText;
  final List list;
  final Function onSaved;

  const MyDropDownFormField({
    Key key,
    this.userValue,
    this.onSaved,
    this.hintText,
    this.list,
  }) : super(key: key);

  @override
  State createState() => MyDropDownFormFieldState();
}

class MyDropDownFormFieldState extends State<MyDropDownFormField> {
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: DropdownButtonFormField(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          validator: (value) =>
              value == null ? "Please Select A " + widget.hintText : null,
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: EdgeInsets.all(15),
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
            filled: false,
          ),
          value: widget.userValue != null ? widget.userValue : dropdownValue,
          items: widget.list.map((dropdownValue) {
            return DropdownMenuItem<String>(
              value: dropdownValue,
              child: Text(dropdownValue),
            );
          }).toList(),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          onSaved: widget.onSaved,
        ));
  }
}
