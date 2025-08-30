import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';
import '../models/user.dart';

class AuthServices {
  final String baseUrl = "http://192.168.0.20:3000/auth";

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return AuthResponse.fromJson(data);
    } else {
      throw Exception("Error en login: ${response.body}");
    }
  }

  Future<User> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/signup");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception("Error en signup: ${response.body}");
    }
  }
}
