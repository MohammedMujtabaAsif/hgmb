import 'dart:convert';
import 'package:hgmb/utils/userProfile.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  final String _url = 'https://hgmb.herokuapp.com/api';

  var _token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    _token = jsonDecode(localStorage.getString('token'))['token'];
  }

  authData(data, apiUrl) async {
    var fullUrl = _url + "/post/" + apiUrl;
    var response = await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
    if (response.statusCode == 429) {
      return _throttle();
    }
    return response;
  }

  getData(apiUrl) async {
    var fullUrl = _url + "/get/" + apiUrl;
    await _getToken();
    var response = await http.get(fullUrl, headers: _setHeaders());
    if (response.statusCode == 429) {
      return _throttle();
    }
    return response;
  }

  postData(data, apiUrl) async {
    var fullUrl = _url + "/post/" + apiUrl;
    await _getToken();
    var response = await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
    if (response.statusCode == 429) {
      return _throttle();
    }
    return response;
  }

  getUsersAsList(json) {
    if (json != null) {
      List<User> _usersList = new List<User>();
      int index = 0;
      while (index < json.length) {
        User _user = User.publicUserFromJson(json[index]);
        if (_user != null) {
          _usersList.add(_user);
        }
        index++;
      }
      return _usersList;
    }
  }

  verify() async {
    var response = await getData('verify');
    if (response.statusCode == 429) {
      return false;
    }
    var body = json.decode(response.body);
    return body['success'];
  }

  _throttle() async {
    Map<String, dynamic> message = {
      'success': false,
      'message': "Too Many Requests"
    };
    var encoded = json.encode(message);
    Response r = new http.Response(encoded, 429);

    return r;
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token'
      };
}
