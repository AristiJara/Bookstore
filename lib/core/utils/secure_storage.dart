import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/user.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  static Future<Map<String, String?>> readTokens() async {
    final access = await _storage.read(key: 'access_token');
    final refresh = await _storage.read(key: 'refresh_token');
    return {'access': access, 'refresh': refresh};
  }

  static Future<void> deleteTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  static Future<void> saveUser(User user) async {
    await _storage.write(key: 'user', value: jsonEncode(user.toJson()));
  }

  static Future<User?> readUser() async {
    final jsonString = await _storage.read(key: 'user');
    if (jsonString == null) return null;
    return User.fromJson(jsonDecode(jsonString));
  }

  static Future<void> deleteUser() async {
    await _storage.delete(key: 'user');
  }

  static Future<void> clearAll() async {
    await deleteTokens();
    await deleteUser();
  }
}