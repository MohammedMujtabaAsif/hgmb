import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hgmb/utils/databaseHelper.dart';
import 'package:hgmb/utils/userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart' as validator;
// import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:intl/intl.dart';
// import '../utils/calcAge.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
// import 'dart:math';

class RegisterPage extends StatefulWidget {
  @override
  State createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  // TextEditingController _textFieldController = TextEditingController();
  bool _isLoading = false;
  bool _isPassword = true;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  User user = User();

  int day;
  int month;
  int year;

  // String _fistName;
  // String _surname;
  // String _prefferedName;
  // String _emailAddress;
  // String _password;
  // String _city;
  // int _phoneNumber;
  // String _maritalStatus;
  // DateTime _dob;
  // String gender;
  // String _bio;

  // int _noOfChildren = 0;
  // String _linkToPhoto = "No Photo";

  // @override
  // Widget build(BuildContext context) {
  //   return Form(key: _formKey);
  // }

  @override
  Widget build(BuildContext context) {
    final _mediaWidth = MediaQuery.of(context).size.width;
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: new InkWell(
            child: new Form(
                key: _formKey,
                child: ListView(children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              width: _mediaWidth / 2,
                              child: MyTextFormField(
                                hintText: "First Name(s)",
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Enter Your First Name(s)';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  user.firstNames = value;
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              width: _mediaWidth / 2,
                              child: MyTextFormField(
                                hintText: "Last Name",
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Enter Your Last Name';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  user.surname = value;
                                },
                              ),
                            )
                          ]),
                      MyTextFormField(
                        hintText: "Displayed Name",
                        onSaved: (String value) {
                          user.prefName = value;
                        },
                      ),
                      MyTextFormField(
                        hintText: "Email",
                        isEmail: true,
                        validator: (String value) {
                          if (!validator.isEmail(value)) {
                            return "Enter a valid Email address";
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          user.email = value;
                        },
                      ),
                      MyTextFormField(
                        hintText: "Password",
                        autocorrect: false,
                        isPassword: _isPassword,
                        validator: (String value) {
                          if (value.length < 8) {
                            return "Password must be a minimum of 8 characters";
                          }
                          _formKey.currentState.save();
                          return null;
                        },
                        onSaved: (String value) {
                          user.password = value;
                        },
                      ),
                      MyTextFormField(
                        hintText: "Confirm Password",
                        isPassword: _isPassword,
                        autocorrect: false,
                        validator: (String value) {
                          if (user.password != null && value != user.password) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      MyTextFormField(
                        hintText: "Phone Number",
                        validator: (String value) {
                          RegExp phoneNumberPattern =
                              new RegExp(r'^(?:[+0])?[1|7]{1}[0-9]{9}$');
                          if (!phoneNumberPattern.hasMatch(value)) {
                            return "Enter a valid phone number";
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          user.phoneNumber = value;
                        },
                      ),
                      MyDropDownFormField(
                        hintText: "Your City",
                        list: <String>[
                          "Manchester",
                          "Birmingham",
                          "London",
                        ],
                        onSaved: (String value) {
                          user.city = value;
                        },
                      ),
                      MyDropDownFormField(
                        hintText: "Marital Status",
                        list: <String>[
                          "Single",
                          "Divorced",
                          "Separated",
                          "Widowed",
                        ],
                        onSaved: (String value) {
                          user.maritalStatus = value;
                        },
                      ),
/*                       Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              width: _mediaWidth / 3,
                              child: new MyTextFormField(
                                hintText: "DD",
                                autocorrect: false,
                                isDate: true,
                                validator: (String value) {
                                  RegExp datePattern =
                                      new RegExp(r'^(?:[+0])?[1-31]{1}$');
                                  if (datePattern.hasMatch(value)) {
                                    return "Date too large";
                                  }
                                  return null;
                                },
                              )),
                          Container(
                            alignment: Alignment.center,
                            width: _mediaWidth / 3,
                            child: new MyTextFormField(
                              hintText: "MM",
                              autocorrect: false,
                              isDate: true,
                              validator: (String value) {
                                RegExp datePattern =
                                    new RegExp(r'^(?:[+0])?[1-31]{1}$');
                                if (datePattern.hasMatch(value)) {
                                  return "Month too large";
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: _mediaWidth / 3,
                            child: new MyTextFormField(
                              hintText: "YYYY",
                              autocorrect: false,
                              isDate: true,
                              validator: (String value) {
                                RegExp datePattern =
                                    new RegExp(r'^(?:[+0])?[1-31]{1}$');
                                if (datePattern.hasMatch(value)) {
                                  return "Year too large";
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ), */
                      RaisedButton(
                          color: Colors.blueAccent,
                          child: Text(
                            _isLoading ? 'Processing...' : 'Register',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _register();
                            }
                          })
                    ],
                  )
                ]))));
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

  void _register() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      "firstNames": user.firstNames,
      "surname": user.surname,
      "prefName": user.prefName,
      "email": user.email,
      "password": user.password,
      "password_confirmation": user.password,
      "phoneNumber": user.phoneNumber,
      "city": user.city,
      "maritalStatus": user.maritalStatus
    };

    var res = await DatabaseHelper().authData(data, '/signup');
    var body = json.decode(res.body);
    // print(body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/landing', (Route<dynamic> route) => false);
    } else {
      Map<String, dynamic> _errors = Map<String, dynamic>.from(body['message']);
      StringBuffer sb = new StringBuffer();
      sb.writeAll(_errors.values, "\n");
      _showMsg(sb.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  void toggle() {
    setState(() {
      _isPassword = !_isPassword;
    });
  }
}

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onSaved;
  final bool autocorrect;
  final bool isPassword;
  final bool isEmail;
  final bool isDate;

  MyTextFormField({
    this.hintText,
    this.validator,
    this.onSaved,
    this.autocorrect = true,
    this.isPassword = false,
    this.isEmail = false,
    this.isDate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.all(15),
          border: InputBorder.none,
          filled: true,
        ),
        obscureText: isPassword ? true : false,
        autocorrect: autocorrect,
        validator: validator,
        onSaved: onSaved,
        keyboardType: isEmail == true
            ? TextInputType.emailAddress
            : isDate == true ? TextInputType.number : TextInputType.text,
      ),
    );
  }
}

class MyDropDownFormField extends StatefulWidget {
  final String hintText;
  final List list;
  final Function onSaved;

  const MyDropDownFormField({
    Key key,
    this.onSaved,
    this.hintText,
    this.list,
  }) : super(key: key);

  @override
  MyDropDownFormFieldState createState() => MyDropDownFormFieldState();
}

class MyDropDownFormFieldState extends State<MyDropDownFormField> {
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: EdgeInsets.all(15),
            border: InputBorder.none,
            filled: true,
          ),
          value: dropdownValue,
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

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Sign Up"),
//         ),
//         body: new InkWell(
//           child: new Form(
//               key: _formKey,
//               child: ListView(primary: false, children: <Widget>[
//                 new TextFormField(
//                   onChanged: (fullName) => _fullName = fullName,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.all(5.0),
//                     labelText: "Full Name",
//                     labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                     // helperText: "Please Enter Your Full Name"
//                   ),
//                 ),
//                 new TextFormField(
//                     onChanged: (prefName) => _prefferedName = prefName,
//                     decoration: InputDecoration(
//                       contentPadding: const EdgeInsets.all(5.0),
//                       labelText: "Display Name",
//                       labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                       // helperText: "Please The Name To Display On Your Profile",
//                     )),
//                 new TextFormField(
//                   // controller: _textFieldController,
//                   onChanged: (email) => _emailAddress = email,
//                   decoration: new InputDecoration(
//                     contentPadding: const EdgeInsets.all(5.0),
//                     labelText: 'E-mail Address',
//                     labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                     // helperText: "Please Enter Your Email Address",
//                   ),
//                 ),
//                 new TextFormField(
//                     // controller: _textFieldController,
//                     obscureText: _obscureText,
//                     onChanged: (value) => _password = value,
//                     autocorrect: false,
//                     decoration: new InputDecoration(
//                       contentPadding: const EdgeInsets.all(5.0),
//                       labelText: 'Password',
//                       labelStyle: TextStyle(fontWeight: FontWeight.bold),
//                       // helperText: "Please Enter Your Password",
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                             _obscureText
//                                 ? Icons.visibility_off
//                                 : Icons.visibility,
//                             color: Theme.of(context).primaryColorDark),
//                         onPressed: () {
//                           setState(() {
//                             _toggle();
//                           });
//                         },
//                       ),
//                     ),
//                     validator: (String value) {
//                       if (value.trim().isEmpty) {
//                         print("no input");
//                         return "Password is required";
//                       }
//                       if (value.trim().length <= 8) {
//                         return "Password must be at least 8 characters";
//                       }
//                     }),
//                 new TextFormField(
//                   decoration: new InputDecoration(
//                       contentPadding: const EdgeInsets.all(5.0),
//                       labelText: "City",
//                       labelStyle: TextStyle(fontWeight: FontWeight.bold)),
//                 ),
//                 new TextFormField(
//                   decoration: new InputDecoration(
//                       contentPadding: const EdgeInsets.all(5.0),
//                       labelText: "Phone Number",
//                       labelStyle: TextStyle(fontWeight: FontWeight.bold)),
//                 ),
//                 new DropdownButtonFormField(
//                     items: <String>[
//                       "Single",
//                       "Divorced",
//                       "Separated",
//                       "Widowed",
//                     ].map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                     onChanged: (String newValue) {
//                       setState(() {
//                         dropdownValue = newValue;
//                       });
//                     }),
//                 new Padding(padding: const EdgeInsets.all(5.0)),
//                 new Center(
//                     child: new Container(
//                         alignment: Alignment.center,
//                         child: new Column(children: <Widget>[
//                           new DropdownButtonFormField(
//                             value: dropdownValue == ""
//                                 ? "Select Marital Status"
//                                 : dropdownValue,
//                             items: <String>[
//                               "Select Marital Status",
//                               "Single",
//                               "Divorced",
//                               "Separated",
//                               "Widowed",
//                             ].map<DropdownMenuItem<String>>((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                             onChanged: (String newValue) {
//                               setState(() {
//                                 dropdownValue = newValue;
//                               });
//                             },
//                           ),
//                           new DropdownButtonFormField(
//                               items: <String>[
//                                 "Single",
//                                 "Divorced",
//                                 "Separated",
//                                 "Widowed",
//                               ].map<DropdownMenuItem<String>>((String value) {
//                                 return DropdownMenuItem<String>(
//                                   value: value,
//                                   child: Text(value),
//                                 );
//                               }).toList(),
//                               onChanged: (String newValue) {
//                                 setState(() {
//                                   dropdownValue = newValue;
//                                 });
//                               }),
//                         ]))),
//                 // new TextFormField(
//                 //dateselectorbutton
//                 // new FloatingActionButton(
//                 //   child: new Icon(Icons.date_range),
//                 //   onPressed: () => showDatePicker(
//                 //     context: context,
//                 //     initialDate: _dob == null
//                 //         ? new DateTime.now()
//                 //             .subtract(new Duration(days: 365 * 18))
//                 //         : _dob,
//                 //     firstDate: new DateTime.now()
//                 //         .subtract(new Duration(days: 365 * 100)),
//                 //     lastDate: new DateTime.now()
//                 //         .subtract(new Duration(days: 365 * 18)),
//                 //   ),
//                 // ),
//                 new Padding(padding: const EdgeInsets.all(5.0)),
//                 RaisedButton(
//                   child: Text('Save'),
//                   onPressed: () => _formKey.currentState.save(),
//                 ),
//                 RaisedButton(
//                   child: Text('Reset'),
//                   onPressed: () => _formKey.currentState.reset(),
//                 ),
//                 RaisedButton(
//                   child: Text('Validate'),
//                   onPressed: () => _formKey.currentState.validate(),
//                 ),
//                 RaisedButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       child: new AlertDialog(
//                         title: new Text("Email Address: " + _emailAddress),
//                         content: new Text("Password: " + _password),
//                       ),
//                     );
//                   },
//                   child: new Text('DONE'),
//                 ),
//               ])),
//         ));
//   }
