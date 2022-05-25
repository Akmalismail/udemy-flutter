import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signUp(String email, String password) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:signUp',
      {'key': 'AIzaSyAL13PGj73rPX_1vVEUIrdqPlgy022pQVs'},
    );

    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    print(json.decode(response.body));
  }
}
