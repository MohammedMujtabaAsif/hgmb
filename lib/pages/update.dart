import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hgmb/utils/confirmButton.dart';
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
import 'dart:async';

class UpdatePage extends StatefulWidget {
  @override
  State createState() => new UpdatePageState();
}

class UpdatePageState extends State<UpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();

  TextEditingController _dateTextController = new TextEditingController();

  bool _isLoading = false;
  User user;
  Future<User> activeUser;
  bool prefFemale = false;
  bool prefMale = false;

  bool prefBirmingham = false;
  bool prefLondon = false;
  bool prefManchester = false;

  bool prefSingle = false;
  bool prefDivorced = false;
  bool prefWidowed = false;

  @override
  void initState() {
    activeUser = _getActiveUser();
    super.initState();
  }

  Future<User> _getActiveUser() async {
    var response = await DatabaseHelper().getData('user');
    var body = json.decode(response.body);

    User user = User.fromJson(body['data']);
    user.dob = Jiffy(user.dob).format('yyyy/MM/dd');

    var prefGendersNamesToString = user.prefGendersNamesToString();
    var prefCitiesToString = user.prefCitiesNamesToString();
    var prefMaritalStatusesNamesToString =
        user.prefMaritalStatusesNamesToString();

    _dateTextController.text = Jiffy(user.dob).format('dd MMM yyyy');

    prefFemale = prefGendersNamesToString.contains("Female");
    prefMale = prefGendersNamesToString.contains("Male");

    prefBirmingham = prefCitiesToString.contains("Birmingham");
    prefLondon = prefCitiesToString.contains("London");
    prefManchester = prefCitiesToString.contains("Manchester");

    prefSingle = prefMaritalStatusesNamesToString.contains("Single");
    prefDivorced = prefMaritalStatusesNamesToString.contains("Divorced");
    prefWidowed = prefMaritalStatusesNamesToString.contains("Widowed");
    return user;
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

  _update(User user) async {
    _isLoading = true;

    setPrefs(user);
    var userData = user.toJson();

    var res = await DatabaseHelper().postData(userData, 'updateAccount');
    var body = json.decode(res.body);

    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', json.encode(body['user']));
    } else {
      Map<String, dynamic> _errors = Map<String, dynamic>.from(body['message']);
      StringBuffer sb = new StringBuffer();
      sb.writeAll(_errors.values, "\n");
      _showMsg(sb.toString());
    }

    _isLoading = false;
  }

  setPrefs(User user) {
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

  _selectDate(BuildContext context, User user) async {
    // eighteenyearsago = 18*365.25 days rounded up to account for leap years
    DateTime eighteenYearsAgo =
        DateTime.now().subtract(new Duration(days: 6575));

    // seventyYearsAgo = 70*365.25 days rounded up to account for leap years
    DateTime seventyYearsAgo =
        DateTime.now().subtract(new Duration(days: 25568));

    // show the datepicker startin 18 years ago and ending 70 years ago
    final DateTime picked = await showDatePicker(
      locale: const Locale("en", "EN"),
      context: context,
      initialDate: eighteenYearsAgo,
      firstDate: seventyYearsAgo,
      lastDate: eighteenYearsAgo,
    );

    // check the use picked a value
    if (picked != null) {
      // set the user.dob to correct format for db
      user.dob = Jiffy(picked).format('yyyy/MM/dd');
      // set text of form field to user readable date
      _dateTextController.text = Jiffy(picked).format('dd MMM yyyy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Update Account"),
      ),
      body: new FutureBuilder(
        future: activeUser,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? new GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView(
                        shrinkWrap: true,
                        controller: _scrollController,
                        children: <Widget>[
                          Column(
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
                                        initialValue: snapshot.data.firstNames,
                                        textCapitalisation: true,
                                        hintText: "First Name(s)",
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'Please Enter your First Name(s)';
                                          }
                                          return null;
                                        },
                                        onSaved: (String value) =>
                                            snapshot.data.firstNames = value,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                      child: MyTextFormField(
                                        textCapitalisation: true,
                                        initialValue: snapshot.data.surname,
                                        hintText: "Surname",
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'Please Enter your Surname';
                                          }
                                          return null;
                                        },
                                        onSaved: (String value) =>
                                            snapshot.data.surname = value,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              MyTextFormField(
                                textCapitalisation: true,
                                initialValue: snapshot.data.prefName,
                                hintText: "Displayed Name",
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter your Display Name';
                                  }
                                  return null;
                                },
                                onSaved: (String value) =>
                                    snapshot.data.prefName = value,
                              ),
                              MyTextFormField(
                                initialValue: snapshot.data.email,
                                hintText: "Email",
                                isEmail: true,
                                validator: (String value) {
                                  if (!validator.isEmail(value)) {
                                    return "Please Enter a valid Email Address";
                                  }
                                  return null;
                                },
                                onSaved: (String value) =>
                                    snapshot.data.email = value,
                              ),
                              MyTextFormField(
                                initialValue: snapshot.data.phoneNumber,
                                hintText: "Phone Number",
                                validator: (String value) {
                                  RegExp phoneNumberPattern = new RegExp(
                                      r'^(?:[+0])?[1|7]{1}[0-9]{9}$');
                                  if (!phoneNumberPattern.hasMatch(value)) {
                                    return "Enter a valid phone number";
                                  }
                                  return null;
                                },
                                onSaved: (String value) =>
                                    snapshot.data.phoneNumber = value,
                              ),
                              MyTextFormField(
                                initialValue:
                                    snapshot.data.numOfChildren.toString(),
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
                                onSaved: (String value) => snapshot
                                    .data.numOfChildren = int.parse(value),
                              ),
                              MyTextFormField(
                                hintText: "Date of Birth",
                                controller: _dateTextController,
                                readOnly: true,
                                isNumber: true,
                                onTap: () =>
                                    _selectDate(context, snapshot.data),
                              ),
                              MyTextFormField(
                                textCapitalisation: true,
                                initialValue: snapshot.data.bio,
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
                                onSaved: (String value) =>
                                    snapshot.data.bio = value,
                              ),
                              MyDropDownFormField(
                                userValue: snapshot.data.gender.name,
                                hintText: "Gender",
                                list: <String>[
                                  "Female",
                                  "Male",
                                ],
                                onSaved: (String value) {
                                  if (value == "Female")
                                    snapshot.data.gender =
                                        Attribute(id: 1, name: "Female");
                                  else if (value == "Male")
                                    snapshot.data.gender =
                                        Attribute(id: 2, name: "Male");
                                },
                              ),
                              MyDropDownFormField(
                                userValue: snapshot.data.city.name,
                                hintText: "City",
                                list: <String>[
                                  "Birmingham",
                                  "London",
                                  "Manchester",
                                ],
                                onSaved: (String value) {
                                  if (value == "Birmingham")
                                    snapshot.data.city =
                                        Attribute(id: 1, name: "Birmingham");
                                  else if (value == "London")
                                    snapshot.data.city =
                                        Attribute(id: 2, name: "London");
                                  else if (value == "Manchester")
                                    snapshot.data.city =
                                        Attribute(id: 3, name: "Manchester");
                                },
                              ),
                              MyDropDownFormField(
                                userValue: snapshot.data.maritalStatus.name,
                                hintText: "Marital Status",
                                list: <String>[
                                  "Single",
                                  "Divorced",
                                  "Widowed",
                                ],
                                onSaved: (String value) {
                                  if (value == "Single")
                                    snapshot.data.maritalStatus =
                                        Attribute(id: 1, name: "Single");
                                  else if (value == "Divorced")
                                    snapshot.data.maritalStatus =
                                        Attribute(id: 2, name: "Divorced");
                                  else if (value == "Widowed")
                                    snapshot.data.maritalStatus =
                                        Attribute(id: 3, name: "Widowed");
                                },
                              ),
                              Divider(
                                thickness: 1,
                                height: 50,
                              ),
                              Card(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Flexible(
                                                flex: 3,
                                                child: Container(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: MyTextFormField(
                                                    initialValue: snapshot
                                                        .data.prefMinAge
                                                        .toString(),
                                                    isNumber: true,
                                                    hintText: "Min Age",
                                                    validator: (String value) {
                                                      if (value.isEmpty)
                                                        return 'Enter Min Age';

                                                      if (int.parse(value) < 18)
                                                        return "Min Age Cannot Be Less Than 18";

                                                      if (int.parse(value) >
                                                          snapshot
                                                              .data.prefMaxAge)
                                                        return "Min Age Must Be Less Than Max Age";

                                                      return null;
                                                    },
                                                    onSaved: (String value) =>
                                                        snapshot.data
                                                                .prefMinAge =
                                                            int.parse(value),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: CustomCard(
                                                  title: "-",
                                                  titleSize: 18,
                                                ),
                                              ),
                                              Flexible(
                                                flex: 3,
                                                child: Container(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: MyTextFormField(
                                                    initialValue: snapshot
                                                        .data.prefMaxAge
                                                        .toString(),
                                                    isNumber: true,
                                                    hintText: "Max Age",
                                                    validator: (String value) {
                                                      if (value.isEmpty)
                                                        return 'Enter Max Age';

                                                      if (int.parse(value) > 70)
                                                        return "Max Age Cannot Be More Than 70";

                                                      if (int.parse(value) <
                                                          snapshot
                                                              .data.prefMinAge)
                                                        return "Max Age Must Be Greater Than Min Age";

                                                      return null;
                                                    },
                                                    onSaved: (String value) =>
                                                        snapshot.data
                                                                .prefMaxAge =
                                                            int.parse(value),
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
                                        initialValue: snapshot
                                            .data.prefMaxNumOfChildren
                                            .toString(),
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
                                        onSaved: (String value) =>
                                            snapshot.data.prefMaxNumOfChildren =
                                                int.parse(value),
                                      ),
                                    ),
                                    CustomCheckboxList(
                                      controller: _scrollController,
                                      title: "Genders",
                                      checkboxList: [
                                        CustomCheckbox(
                                          title: "Female",
                                          value: prefFemale,
                                          onChanged: (value) => setState(() {
                                            prefFemale ^= true;
                                          }),
                                        ),
                                        CustomCheckbox(
                                          title: "Male",
                                          value: prefMale,
                                          onChanged: (value) => setState(() {
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
                                            onChanged: (value) => setState(() {
                                                  prefBirmingham ^= true;
                                                })),
                                        CustomCheckbox(
                                          title: "London",
                                          value: prefLondon,
                                          onChanged: (value) => setState(() {
                                            prefLondon ^= true;
                                          }),
                                        ),
                                        CustomCheckbox(
                                          title: "Manchester",
                                          value: prefManchester,
                                          onChanged: (value) => setState(() {
                                            prefManchester ^= true;
                                          }),
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
                                          onChanged: (value) => setState(() {
                                            prefSingle ^= true;
                                          }),
                                        ),
                                        CustomCheckbox(
                                          title: "Divorced",
                                          value: prefDivorced,
                                          onChanged: (value) => setState(() {
                                            prefDivorced ^= true;
                                          }),
                                        ),
                                        CustomCheckbox(
                                          title: "Widowed",
                                          value: prefWidowed,
                                          onChanged: (value) => setState(() {
                                            prefWidowed ^= true;
                                          }),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              RaisedButton(
                                color: Colors.blueAccent,
                                child: Text(
                                  _isLoading ? 'Processing...' : 'Update',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  // if the form has no errors
                                  if (_formKey.currentState.validate()) {
                                    showDialog(
                                      context: context,
                                      child: ConfirmButton(
                                        buttonColor: Colors.blue,
                                        buttonMessage:
                                            "Updating account will require reapproval by Admins",
                                        buttonName: 'Update',
                                        buttonMethod: () async {
                                          // save its current state
                                          _formKey.currentState.save();
                                          // send form data to be database
                                          _update(snapshot.data);

                                          // pause the program to allow the data to be processed
                                          await Future.delayed(
                                            Duration(milliseconds: 500),
                                          );

                                          // push the middleware page to check their approval status
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/middleware',
                                                  (Route<dynamic> route) =>
                                                      false);
                                        },
                                      ),
                                    );
                                  } else {
                                    _showMsg(
                                        "Please Fix The Errors Before Updating");
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
