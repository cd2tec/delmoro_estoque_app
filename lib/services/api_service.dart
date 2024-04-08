// ignore_for_file: unused_element

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Uri apiUrl = Uri.parse('http://144.22.160.136:8081');

  Future<Map<String, dynamic>> getMe(String token) async {
    var getMeUrl = apiUrl.resolve('/me');

    var response = await http.get(getMeUrl, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      return responseData;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<dynamic>> listUsers(String token) async {
    var listUsersUrl = apiUrl.resolve('/user');

    var response = await http.get(listUsersUrl, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      var usersData = responseData['data'];

      if (usersData is List) {
        return usersData;
      } else {
        throw Exception('Response data is not a list');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> grantAccess(String userId, String value, String newToken) async {
    var grantAccessUrl = apiUrl.resolve('/user/grantaccess/$userId');

    var response = await http.put(grantAccessUrl, headers: {
      'Authorization': 'Bearer $newToken',
      'Accept': 'application/json',
    }, body: {
      'grantaccess': value,
    });

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body) as List<dynamic>;
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<List<dynamic>> getPermission(String token, int userId) async {
    var getPermissionUrl = apiUrl.resolve('/permission/$userId');

    try {
      var response = await http.get(getPermissionUrl, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body) as List<dynamic>;

        return decodedResponse;
      } else {
        throw Exception(
            'Failed to load user permission. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user permission: $e');
    }
  }

  Future<List<dynamic>> getStock(
      String token, String barcode, List selectedStoreId) async {
    var getStockUrl = apiUrl.resolve('/stock');

    try {
      var response = await http.post(getStockUrl,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'codacesso': barcode,
            'storeids': selectedStoreId,
          }));

      print(response);
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body) as List<dynamic>;
        return decodedResponse;
      } else {
        throw Exception(
            'Failed to load stock data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load stock data: $e');
    }
  }

  Future<void> costPermission(String token, String id, int value) async {
    var putCostPermissionUrl = apiUrl.resolve('/user/cost/$id');

    var response = await http.put(putCostPermissionUrl, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }, body: {
      'showcost': value,
    });
    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body) as List<dynamic>;
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<Map<String, dynamic>> getPrice(String token, String value) async {
    var getPriceUrl = apiUrl.resolve('/price');

    try {
      var response = await http.post(getPriceUrl,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'seqproduto': value}));

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body) as Map<String,
            dynamic>; // Alterado para mapear diretamente para um mapa
        return decodedResponse;
      } else {
        throw Exception(
            'Failed to load price data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load stock data: $e');
    }
  }

  Future<void> _saveTokenInSharedPreferences(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token ?? '');
  }
}
