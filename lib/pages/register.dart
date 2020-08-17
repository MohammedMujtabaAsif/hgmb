import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hgmb/utils/customCheckboxList.dart';
import 'package:hgmb/utils/customCard.dart';
import 'package:hgmb/utils/customCheckbox.dart';
import 'package:hgmb/utils/databaseHelper.dart';
import 'package:hgmb/utils/formFields.dart';
import 'package:hgmb/utils/userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jiffy/jiffy.dart';
import 'package:validators/validators.dart' as validator;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  State createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();

  TextEditingController _passwordTextController = new TextEditingController();
  TextEditingController _dateTextController = new TextEditingController();

  bool _isLoading = false;
  bool _isPassword = true;
  User user;

  void initState() {
    super.initState();
    user = new User();
    user.prefMinAge = 100;
    user.prefMaxAge = 100;
  }

  bool prefFemale = false;
  bool prefMale = false;

  bool prefBirmingham = false;
  bool prefLondon = false;
  bool prefManchester = false;

  bool prefSingle = false;
  bool prefDivorced = false;
  bool prefWidowed = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: GestureDetector(
        onTap: () {
          focusCheck(context);
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: ListView(
              controller: _scrollController,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Card(
                      child: Column(
                        children: <Widget>[
                          CustomCard(
                            title: "Your Details",
                            isTitle: true,
                            titleSize: 18,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  child: MyTextFormField(
                                    textCapitalisation: true,
                                    hintText: "First Name(s)",
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter your First Name(s)';
                                      }
                                      return null;
                                    },
                                    onSaved: (String value) =>
                                        user.firstNames = value,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  child: MyTextFormField(
                                    textCapitalisation: true,
                                    hintText: "Surname",
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter your Surname';
                                      }
                                      return null;
                                    },
                                    onSaved: (String value) =>
                                        user.surname = value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          MyTextFormField(
                            textCapitalisation: true,
                            hintText: "Displayed Name",
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please Enter your Display Name';
                              }
                              return null;
                            },
                            onSaved: (String value) => user.prefName = value,
                          ),
                          MyTextFormField(
                            hintText: "Email",
                            isEmail: true,
                            validator: (String value) {
                              if (!validator.isEmail(value)) {
                                return "Please Enter a valid Email Address";
                              }
                              return null;
                            },
                            onSaved: (String value) => user.email = value,
                          ),
                          MyTextFormField(
                            hintText: "Password",
                            autocorrect: false,
                            isPassword: _isPassword,
                            suffixIcon: _isPassword
                                ? IconButton(
                                    onPressed: () => toggle("_isPassword"),
                                    icon: Icon(Icons.visibility_off),
                                  )
                                : IconButton(
                                    onPressed: () => toggle("_isPassword"),
                                    icon: Icon(Icons.visibility),
                                  ),
                            validator: (String value) {
                              if (value.length < 8) {
                                return "Password must be a minimum of 8 characters";
                              }
                              _formKey.currentState.save();
                              return null;
                            },
                            onSaved: (String value) => user.password = value,
                          ),
                          MyTextFormField(
                            controller: _passwordTextController,
                            hintText: "Confirm Password",
                            isPassword: true,
                            autocorrect: false,
                            validator: (String value) {
                              if (value.length < 8) {
                                return "Please confirm your password";
                              } else if (user.password != null &&
                                  value != user.password) {
                                _passwordTextController.text = "";
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
                            onSaved: (String value) => user.phoneNumber = value,
                          ),
                          MyTextFormField(
                            hintText: "Number of Children",
                            isNumber: true,
                            validator: (String value) {
                              if (value.isEmpty)
                                return "Please Enter How Many Children You Have";
                              if (int.parse(value) < 0)
                                return "Cannot Have Negative Number of Children";
                              if (int.parse(value) > 15)
                                return "Number Too Large";
                              return null;
                            },
                            onSaved: (String value) =>
                                user.numOfChildren = int.parse(value),
                          ),
                          MyTextFormField(
                            hintText: "Date of Birth",
                            controller: _dateTextController,
                            readOnly: true,
                            isNumber: true,
                            onTap: () => _selectDate(context),
                          ),
                          MyTextFormField(
                            textCapitalisation: true,
                            isBio: true,
                            maxLength: 1000,
                            hintText: "Biography",
                            autocorrect: true,
                            validator: (String value) {
                              if (value.length == 0)
                                return "Please Enter A Biography";
                              if (value.length < 10)
                                return "Biography Too Short";
                              return null;
                            },
                            onSaved: (String value) => user.bio = value,
                          ),
                          MyDropDownFormField(
                            hintText: "Gender",
                            list: <String>[
                              "Female",
                              "Male",
                            ],
                            onSaved: (String value) {
                              if (value == "Female")
                                user.gender = Attribute(id: 1, name: "Female");
                              else if (value == "Male")
                                user.gender = Attribute(id: 2, name: "Male");
                            },
                          ),
                          MyDropDownFormField(
                            hintText: "City",
                            list: <String>[
                              "Birmingham",
                              "London",
                              "Manchester",
                            ],
                            onSaved: (String value) {
                              if (value == "Birmingham")
                                user.city =
                                    Attribute(id: 1, name: "Birmingham");
                              else if (value == "London")
                                user.city = Attribute(id: 2, name: "London");
                              else if (value == "Manchester")
                                user.city =
                                    Attribute(id: 3, name: "Manchester");
                            },
                          ),
                          MyDropDownFormField(
                            hintText: "Marital Status",
                            list: <String>[
                              "Single",
                              "Divorced",
                              "Widowed",
                            ],
                            onSaved: (String value) {
                              if (value == "Single")
                                user.maritalStatus =
                                    Attribute(id: 1, name: "Single");
                              else if (value == "Divorced")
                                user.maritalStatus =
                                    Attribute(id: 2, name: "Divorced");
                              else if (value == "Widowed")
                                user.maritalStatus =
                                    Attribute(id: 3, name: "Widowed");
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: CustomCard(
                                title: "Partner Preferences",
                                isTitle: true,
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        flex: 3,
                                        child: Container(
                                          child: MyTextFormField(
                                            isNumber: true,
                                            hintText: "Min Age",
                                            validator: (String value) {
                                              if (value.isEmpty)
                                                return 'Enter Min Age';

                                              if (int.parse(value) < 18)
                                                return "Min Age Cannot Be Less Than 18";

                                              if (int.parse(value) >
                                                  user.prefMaxAge)
                                                return "Min Age Must Be Less Than Max Age";

                                              return null;
                                            },
                                            onSaved: (String value) => user
                                                .prefMinAge = int.parse(value),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: CustomCard(
                                          title: "_",
                                          titleSize: 18,
                                        ),
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: Container(
                                          child: MyTextFormField(
                                            isNumber: true,
                                            hintText: "Max Age",
                                            validator: (String value) {
                                              if (value.isEmpty)
                                                return 'Enter Max Age';

                                              if (int.parse(value) > 70)
                                                return "Max Age Cannot Be More Than 70";

                                              if (int.parse(value) <
                                                  user.prefMinAge)
                                                return "Max Age Must Be Greater Than Min Age";

                                              return null;
                                            },
                                            onSaved: (String value) => user
                                                .prefMaxAge = int.parse(value),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: MyTextFormField(
                                isNumber: true,
                                hintText: "Maximum Number of Children",
                                validator: (String value) {
                                  if (value.isEmpty)
                                    return "Please Enter Max Number of Children";
                                  if (int.parse(value) < 0)
                                    return "Cannot Have Negative Number of Children";
                                  if (int.parse(value) > 15)
                                    return "Number Too Large";
                                  return null;
                                },
                                onSaved: (String value) => user
                                    .prefMaxNumOfChildren = int.parse(value),
                              ),
                            ),
                            CustomCheckboxList(
                              controller: _scrollController,
                              title: "Genders",
                              checkboxList: [
                                CustomCheckbox(
                                  title: "Female",
                                  value: prefFemale,
                                  onChanged: (_) => setState(() {
                                    focusCheck(this.context);
                                    prefFemale ^= true;
                                  }),
                                ),
                                CustomCheckbox(
                                  title: "Male",
                                  value: prefMale,
                                  onChanged: (value) => setState(() {
                                    focusCheck(this.context);
                                    prefMale ^= true;
                                  }),
                                ),
                              ],
                            ),
                            CustomCheckboxList(
                              controller: _scrollController,
                              title: "Cities",
                              checkboxList: [
                                CustomCheckbox(
                                  title: "Birmingham",
                                  value: prefBirmingham,
                                  onChanged: (value) => {
                                    focusCheck(this.context),
                                    toggle("prefBirmingham")
                                  },
                                ),
                                CustomCheckbox(
                                  title: "London",
                                  value: prefLondon,
                                  onChanged: (value) => {
                                    focusCheck(this.context),
                                    toggle("prefLondon")
                                  },
                                ),
                                CustomCheckbox(
                                  title: "Manchester",
                                  value: prefManchester,
                                  onChanged: (value) => {
                                    focusCheck(this.context),
                                    toggle("prefManchester")
                                  },
                                ),
                              ],
                            ),
                            CustomCheckboxList(
                              controller: _scrollController,
                              title: "Marital Statuses",
                              checkboxList: [
                                CustomCheckbox(
                                  title: "Single",
                                  value: prefSingle,
                                  onChanged: (value) => {
                                    focusCheck(this.context),
                                    toggle("prefSingle")
                                  },
                                ),
                                CustomCheckbox(
                                  title: "Divorced",
                                  value: prefDivorced,
                                  onChanged: (value) => {
                                    focusCheck(this.context),
                                    toggle("prefDivorced")
                                  },
                                ),
                                CustomCheckbox(
                                  title: "Widowed",
                                  value: prefWidowed,
                                  onChanged: (value) => {
                                    focusCheck(this.context),
                                    toggle("prefWidowed")
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
                        } else {
                          _showMsg("Please Fix The Errors Before Registering");
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // show message in current scaffold
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

  // switch current focus of the widget
  focusCheck(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  // POST form data to server
  void _register() async {
    //set the button to loading
    toggle("_isLoading");
    //set the user's preferences from the form
    setPrefs();

    // convert the user to JSON
    var data = user.toJson();

    // await a response from server about POST data
    var res = await DatabaseHelper().authData(data, 'register');
    // decode the body of the response
    var body = json.decode(res.body);

    // if the success key in body is true
    if (body['success']) {
      // store the user and their token. Then move them to the middleware route to await approval
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/middleware', (Route<dynamic> route) => false);
    } else {
      // if the message is unsuccessful. Show the errors in the scaffold
      Map<String, dynamic> _errors = Map<String, dynamic>.from(body['message']);
      StringBuffer sb = new StringBuffer();
      sb.writeAll(_errors.values, "\n");
      _showMsg(sb.toString());
    }

    // set the button to normal
    toggle("_isLoading");
  }

  // use the values from the checkbox booleans to setup the user's preferences
  void setPrefs() {
    // Add prefGenders to User
    List<PrefGender> prefGenders = new List<PrefGender>();
    if (prefFemale) prefGenders.add(PrefGender(genderId: 1, name: "Female"));
    if (prefMale) prefGenders.add(PrefGender(genderId: 2, name: "Male"));

    // Add PrefCities to User
    List<PrefCity> prefCities = new List<PrefCity>();
    if (prefBirmingham) prefCities.add(PrefCity(cityId: 1, name: "Birmingham"));
    if (prefLondon) prefCities.add(PrefCity(cityId: 2, name: "London"));
    if (prefManchester) prefCities.add(PrefCity(cityId: 3, name: "Manchester"));

    // Add PrefMaritalStatuses to User
    List<PrefMaritalStatus> prefMaritalStatuses = new List<PrefMaritalStatus>();
    if (prefSingle)
      prefMaritalStatuses
          .add(PrefMaritalStatus(maritalStatusId: 1, name: "Single"));
    if (prefDivorced)
      prefMaritalStatuses
          .add(PrefMaritalStatus(maritalStatusId: 2, name: "Divorced"));
    if (prefWidowed)
      prefMaritalStatuses
          .add(PrefMaritalStatus(maritalStatusId: 3, name: "Widowed"));

    user.prefGenders = prefGenders;
    user.prefCities = prefCities;
    user.prefMaritalStatuses = prefMaritalStatuses;
  }

  // show the DatePicker with dates from 18-70 years ago
  Future<void> _selectDate(BuildContext context) async {
    DateTime eighteenYearsAgo =
        DateTime.now().subtract(new Duration(days: 6575));
    DateTime seventyYearsAgo =
        DateTime.now().subtract(new Duration(days: 25568));

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: eighteenYearsAgo,
        firstDate: seventyYearsAgo,
        lastDate: eighteenYearsAgo);

    // if a value is picked
    if (picked != null)
      setState(
        () {
          // save the date to the user as the correct format for the server
          user.dob = Jiffy(picked).format('yyyy/MM/dd');
          // display the date in a user friendly format  (Day Number / Month Name / Year)
          _dateTextController.text = Jiffy(picked).format('dd MMM yyyy');
        },
      );
  }

  void toggle(boolVal) {
    //toggle all the potential booleans
    setState(
      () {
        switch (boolVal) {
          case "_isLoading":
            _isLoading ^= true;
            break;
          case "_isPassword":
            _isPassword ^= true;
            break;
          case "prefBirmingham":
            prefBirmingham ^= true;
            break;
          case "prefLondon":
            prefLondon ^= true;
            break;
          case "prefManchester":
            prefManchester ^= true;
            break;
          case "prefSingle":
            prefSingle ^= true;
            break;
          case "prefDivorced":
            prefDivorced ^= true;
            break;
          case "prefWidowed":
            prefWidowed ^= true;
            break;
          default:
        }
      },
    );
  }
}
