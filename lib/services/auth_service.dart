import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:realtime_chat/global/environment.dart';
import 'package:realtime_chat/models/login_response.dart';
import 'package:realtime_chat/models/user.dart';

class AuthService with ChangeNotifier {
  late User user;
  bool _authenticating = false;
  final _storage = const FlutterSecureStorage();

  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  bool get authenticating => _authenticating;
  set authenticating(bool status) {
    _authenticating = status;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    authenticating = true;

    final userData = {
      'email': email,
      'password': password,
    };

    final url = Uri.parse('${Environment.apiUrl}/login');
    final resp = await http.post(
      url,
      body: jsonEncode(userData),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    authenticating = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user!;

      await _saveToken(loginResponse.token!);
      return null;
    }

    return getResponseErrors(resp.body);
  }

  Future<String?> register(String name, String email, String password) async {
    authenticating = true;

    final userData = {
      'name': name,
      'email': email,
      'password': password,
    };

    final url = Uri.parse('${Environment.apiUrl}/login/new');
    final resp = await http.post(
      url,
      body: jsonEncode(userData),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    authenticating = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user!;

      await _saveToken(loginResponse.token!);
      return null;
    }

    return getResponseErrors(resp.body);
  }

  String? getResponseErrors(String resp) {
    final response = jsonDecode(resp) as Map<String, dynamic>;

    if (response.containsKey('msg')) {
      return response['msg'];
    } else if (response.containsKey('errors')) {
      final errors = response['errors'];
      for (var error in errors.values) {
        if (error is Map<String, dynamic> && error.containsKey('msg')) {
          return error['msg'];
        }
      }
    }

    return null;
  }

  Future<bool> isLogged() async {
    final token = await _storage.read(key: 'token');

    final url = Uri.parse('${Environment.apiUrl}/login/renew');
    final resp = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? '',
      },
    );

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user!;

      await _saveToken(loginResponse.token!);
      return true;
    }

    logout();
    return false;
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    return await _storage.delete(key: 'token');
  }
}
