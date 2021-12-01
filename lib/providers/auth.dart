import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token = '';
  DateTime? _expiryDate;
  late String userId;

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

  Future<void> signUp(String mail, String password) async {
    const uri =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[your_web_api_key]';
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
    const uri =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAzFtne3WKJLJdxo4NFqltceEUWRcPnyg4';
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
      userId = responseData['localId'];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
