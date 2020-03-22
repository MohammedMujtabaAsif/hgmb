import 'dart:convert';
import 'package:hgmb/utils/userProfile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  final String _url = 'https://hgmb.herokuapp.com/api/auth';
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];
  }

  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(fullUrl, headers: _setHeaders());
  }

  getUsersAsList(apiUrl) async {
    var response = await getData(apiUrl);
    var body = json.decode(response.body);
    print(body);
    if (body != null) {
      List<User> _usersList = new List<User>();
      int index = 0;
      while (index < body.length) {
        User _user = new User.fromJson(body[index]);
        if (_user != null) {
          _usersList.add(_user);
          // print("user " + (_user.prefName).toString() + " added");
        } else {
          print("user is null");
        }
        index++;
      }
      return _usersList;
    }
  }

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
