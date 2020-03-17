class User {
  String firstNames;
  String surname;
  String prefName;
  String email;
  String password;
  String gender;
  String phoneNumber;
  String city;
  String maritalStatus;
  int minPrefAge;
  int maxPrefAge;
  DateTime dob;
  int numOfChildren;
  String bio;

  // String linkToPhoto;

  User({
    this.firstNames,
    this.surname,
    this.prefName,
    this.email,
    this.password,
    this.phoneNumber,
    this.city,
    this.maritalStatus,
    this.gender,
    this.minPrefAge,
    this.maxPrefAge,
    this.dob,
    this.numOfChildren,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // firstNames: json["firstNames"],
      // surname: json["surname"],
      prefName: json["prefName"],
      // email: json["email"],
      // phoneNumber: json['phoneNumber'],
      city: json['city'],
      maritalStatus: json['maritalStatus'],
      gender: json['gender'],
      minPrefAge: json['minPrefAge'],
      maxPrefAge: json['maxPrefAge'],
      dob: json['dob'],
      numOfChildren: json['numOfChildren'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstNames'] = this.firstNames;
    data['surname'] = this.surname;
    data['prefName'] = this.prefName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phoneNumber'] = this.phoneNumber;
    data['city'] = this.city;
    data['maritalStatus'] = this.maritalStatus;
    data['gender'] = this.gender;
    data['minPrefAge'] = this.minPrefAge;
    data['maxPrefAge'] = this.maxPrefAge;
    data['dob'] = this.dob;
    data['numOfChildren'] = this.numOfChildren;
    data['bio'] = this.bio;
    return data;
  }
}
