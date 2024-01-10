import 'package:flutter/material.dart';
import '../api/api_keys.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/http_exception.dart';
import 'dart:async';
// for Timer

class Auth with ChangeNotifier {
  String _token = '';
  DateTime? _expiryDate;
  late String _userId;
  Timer? authTimer;

  bool get isAuth {
    return (token != '');
    // checking token returned or not
  }

  String get token {
    if (_token != '' &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token;
      // fetching token from server
    }
    return '';
    // if token not available
  }

  String get userId {
    return _userId;
  }

  Future<void> signUp(String mail, String password) async {
    String uri =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${ApiKeys.cloudApiKey}';
    final url = Uri.parse(uri);

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': mail,
            'password': password,
            'returnSecureToken': true,
            // this is always true
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      /* print(json.decode(response.body)); */
      throw error;
    }
  }

  Future<void> logIn(String mail, String password) async {
    String uri =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${ApiKeys.cloudApiKey}';
    // diff url for login
    final url = Uri.parse(uri);

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': mail,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        /* print(responseData['error']['message']); */
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      // recieves the token from the server
      _expiryDate = DateTime.now().add(
        // recieving expiry date in seconds and converting it in a proper date
        Duration(
          seconds: int.parse(
            // string to int
            responseData['expiresIn'],
          ),
        ),
      );
      _userId = responseData['localId'];
      autoLogOut();
      // once user logs in timer starts
      notifyListeners();

      //storing login user data
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'expiryDate': _expiryDate!.toIso8601String(),
          'userId': _userId,
        },
      );
      // setting the login data as json

      prefs.setString('userData', userData);
      // saved the json

    } catch (error) {
      throw error;
    }
  }

  void logOut() {
    _token = '';
    _expiryDate = null;
    _userId = '';
    if (authTimer != null) {
      authTimer!.cancel();
      authTimer = null;
    }
    notifyListeners();
  }

  Future<void> autoLogOut() async {
    if (authTimer != null) {
      authTimer!.cancel();
      // cancel any timer set before setting another one
    }
    final expiryTiming = _expiryDate!.difference(DateTime.now()).inSeconds;
    // subtracting current time from expiry dateTime and converting it in seconds
    authTimer = Timer(
      Duration(
        seconds: expiryTiming,
      ),
      logOut,
    );
    // wait for that many seconds and call logout then

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // cause if logged out once delete saved data, dont auto log in
  }

  Future<bool> autoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final prefGetString = prefs.getString('userData');
    // as the json returns object? type so checking if its null or not, or its giving an error to decode directly
    if (prefGetString == null) {
      return false;
    }
    final extractedUserData =
        json.decode(prefGetString) as Map<String, dynamic>;
    // as null checked now decode works

    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogOut();
    return true;
  }
}
