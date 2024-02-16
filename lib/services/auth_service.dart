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

  static Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
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
      Map<String, dynamic> responseBody = json.decode(response.body);

      String? receivedToken = responseBody['access_token'];

      await _saveTokenInSharedPreferences(receivedToken);

      return LoginResult(success: true, token: receivedToken);
    } else {
      return LoginResult(success: false);
    }
  }

  Future<void> revokeToken() async {
    SharedPreferences prefs = await getSharedPreferences();
    var apiUrl = Uri.parse('http://144.22.160.136:8081/revoke');
    var token = prefs.getString('token');

    http.Response response = await http.post(apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
        body: null);

    if (response.statusCode != 200) {
      throw http.ClientException(response.body);
    }
  }

  Future<void> _saveTokenInSharedPreferences(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token ?? '');
  }
}
