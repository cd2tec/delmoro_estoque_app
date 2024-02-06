import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginResult {
  final bool success;
  final String? token;

  LoginResult({required this.success, this.token});
}

class AuthService {
  String generateToken(String username, String password) {
    String token = "delmoro@mobiletoken" + username + password;

    return token;
  }

  Future<LoginResult> login(
      String username, String password, String token) async {
    var apiUrl = Uri.parse('http://144.22.160.136:8081/login/mobile');

    var response = await http.post(apiUrl, body: {
      'sequsuario': username,
      'password': password,
      'mobiletoken': token,
    });

    if (response.statusCode == 200) {
      String? token = "";
      await _saveTokenInSharedPreferences(token);
      return LoginResult(success: true, token: token);
    } else {
      return LoginResult(success: false);
    }
  }

  Future<void> _saveTokenInSharedPreferences(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token ?? '');
  }
}
