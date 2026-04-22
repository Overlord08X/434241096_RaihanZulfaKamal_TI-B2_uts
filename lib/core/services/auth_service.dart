import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_ticketing_app/shared/models/user_model.dart';

class AuthService {
  final SharedPreferences _prefs;
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  AuthService(this._prefs);

  Future<User?> login(String email, String password) async {
    try {
      // Simulated login - in real app this would call API
      // Mock data for demonstration
      final user = User(
        id: '1',
        email: email,
        name: email.split('@').first,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        role: _resolveRoleFromEmail(email),
      );

      // Save to preferences
      await _prefs.setString(_tokenKey, user.token);
      await _prefs.setString(_userKey, _userToJson(user));

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        role: UserRole.user,
      );

      await _prefs.setString(_tokenKey, user.token);
      await _prefs.setString(_userKey, _userToJson(user));

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      // Simulated API request.
      await Future.delayed(const Duration(milliseconds: 800));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _prefs.remove(_userKey);
      await _prefs.remove(_tokenKey);
    } catch (e) {
      rethrow;
    }
  }

  User? getCurrentUser() {
    try {
      final userJson = _prefs.getString(_userKey);
      if (userJson != null) {
        return _jsonToUser(userJson);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String? getAuthToken() {
    return _prefs.getString(_tokenKey);
  }

  bool isLoggedIn() {
    return _prefs.containsKey(_tokenKey);
  }

  String _userToJson(User user) {
    return jsonEncode(user.toJson());
  }

  User _jsonToUser(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return User.fromJson(map);
  }

  UserRole _resolveRoleFromEmail(String email) {
    if (email.contains('admin')) {
      return UserRole.admin;
    }
    if (email.contains('helpdesk')) {
      return UserRole.helpdesk;
    }
    return UserRole.user;
  }
}
