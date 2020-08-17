import 'dart:io';
import 'package:jiffy/jiffy.dart';

class User {
  User({
    this.id,
    this.firstNames,
    this.surname,
    this.prefName,
    this.email,
    this.password,
    this.phoneNumber,
    this.image,
    this.dob,
    this.age,
    this.numOfChildren,
    this.bio,
    this.prefMinAge,
    this.prefMaxAge,
    this.prefMaxNumOfChildren,
    this.gender,
    this.city,
    this.maritalStatus,
    this.prefCities,
    this.prefGenders,
    this.prefMaritalStatuses,
  });

  int id;
  String firstNames;
  String surname;
  String prefName;
  String email;
  String password;
  String phoneNumber;
  File image;
  String dob;
  int age;
  int numOfChildren;
  String bio;
  int prefMinAge;
  int prefMaxAge;
  int prefMaxNumOfChildren;
  Attribute gender;
  Attribute city;
  Attribute maritalStatus;
  List<PrefCity> prefCities;
  List<PrefGender> prefGenders;
  List<PrefMaritalStatus> prefMaritalStatuses;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstNames: json["firstNames"],
        surname: json["surname"],
        prefName: json["prefName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        image: json["image"],
        dob: Jiffy(json["dob"]).format('yyyyMMdd'),
        age: json["age"],
        numOfChildren: json["numOfChildren"],
        bio: json["bio"],
        prefMinAge: json["prefMinAge"],
        prefMaxAge: json["prefMaxAge"],
        prefMaxNumOfChildren: json["prefMaxNumOfChildren"],
        gender: Attribute.fromJson(json["gender"]),
        city: Attribute.fromJson(json["city"]),
        maritalStatus: Attribute.fromJson(json["marital_status"]),
        prefCities: List<PrefCity>.from(
            json["pref_cities"].map((x) => PrefCity.fromJson(x))),
        prefGenders: List<PrefGender>.from(
            json["pref_genders"].map((x) => PrefGender.fromJson(x))),
        prefMaritalStatuses: List<PrefMaritalStatus>.from(
            json["pref_marital_statuses"]
                .map((x) => PrefMaritalStatus.fromJson(x))),
      );

  factory User.publicUserFromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        prefName: json["prefName"],
        age: json["age"],
        numOfChildren: json["numOfChildren"],
        bio: json["bio"],
        prefMinAge: json["prefMinAge"],
        prefMaxAge: json["prefMaxAge"],
        prefMaxNumOfChildren: json["prefMaxNumOfChildren"],
        gender: Attribute.fromJson(json["gender"]),
        city: Attribute.fromJson(json["city"]),
        maritalStatus: Attribute.fromJson(json["marital_status"]),
        prefCities: List<PrefCity>.from(
            json["pref_cities"].map((x) => PrefCity.fromJson(x))),
        prefGenders: List<PrefGender>.from(
            json["pref_genders"].map((x) => PrefGender.fromJson(x))),
        prefMaritalStatuses: List<PrefMaritalStatus>.from(
            json["pref_marital_statuses"]
                .map((x) => PrefMaritalStatus.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "firstNames": firstNames,
        "surname": surname,
        "prefName": prefName,
        "email": email,
        "password": password,
        "password_confirmation": password,
        "phoneNumber": phoneNumber,
        "dob": dob,
        "numOfChildren": numOfChildren,
        "bio": bio,
        "city_id": city.id,
        "gender_id": gender.id,
        "marital_status_id": maritalStatus.id,
        "pref_min_age": prefMinAge,
        "pref_max_age": prefMaxAge,
        "pref_num_of_children": prefMaxNumOfChildren,
        "pref_cities": prefCitiesIDsList(),
        "pref_genders": prefGendersIDsList(),
        "pref_marital_statuses": prefMaritalStatusesIDsList()
      };

  List<int> prefCitiesIDsList() {
    List<int> ids = new List<int>();

    for (var id in prefCities) {
      ids.add(id.cityId);
    }

    return ids;
  }

  List<int> prefGendersIDsList() {
    List<int> ids = new List<int>();

    for (var id in prefGenders) {
      ids.add(id.genderId);
    }

    return ids;
  }

  List<int> prefMaritalStatusesIDsList() {
    List<int> ids = new List<int>();

    for (var id in prefMaritalStatuses) {
      ids.add(id.maritalStatusId);
    }

    return ids;
  }

  String prefCitiesNamesToString() {
    StringBuffer names = new StringBuffer();

    for (var name in prefCities) {
      names.write(name.name + "\n");
    }

    return names.toString();
  }

  String prefGendersNamesToString() {
    StringBuffer names = new StringBuffer();

    for (var name in prefGenders) {
      names.write(name.name + "\n");
    }

    return names.toString();
  }

  String prefMaritalStatusesNamesToString() {
    StringBuffer names = new StringBuffer();

    for (var name in prefMaritalStatuses) {
      names.write(name.name + "\n");
    }

    return names.toString();
  }
}

class Attribute {
  Attribute({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class PrefCity {
  PrefCity({
    this.cityId,
    this.name,
  });

  int cityId;
  String name;

  factory PrefCity.fromJson(Map<String, dynamic> json) => PrefCity(
        cityId: json["city_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "city_id": cityId,
      };
}

class PrefGender {
  PrefGender({
    this.genderId,
    this.name,
  });

  int genderId;
  String name;

  factory PrefGender.fromJson(Map<String, dynamic> json) => PrefGender(
        genderId: json["gender_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "gender_id": genderId,
      };
}

class PrefMaritalStatus {
  PrefMaritalStatus({
    this.maritalStatusId,
    this.name,
  });

  int maritalStatusId;
  String name;

  factory PrefMaritalStatus.fromJson(Map<String, dynamic> json) =>
      PrefMaritalStatus(
        maritalStatusId: json["marital_status_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "marital_status_id": maritalStatusId,
      };
}
