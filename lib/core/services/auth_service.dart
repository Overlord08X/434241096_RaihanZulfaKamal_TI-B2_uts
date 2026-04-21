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
      );

      // Save to preferences
      await _prefs.setString(_tokenKey, user.token);
      await _prefs.setString(_userKey, _userToJson(user));

      return user;
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
    return '{"id":"${user.id}","email":"${user.email}","name":"${user.name}","token":"${user.token}"}';
  }

  User _jsonToUser(String json) {
    // Simple JSON parsing without external package
    final map = _parseSimpleJson(json);
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      token: map['token'] ?? '',
    );
  }

  Map<String, String> _parseSimpleJson(String json) {
    final map = <String, String>{};
    final content = json.replaceAll('{', '').replaceAll('}', '');
    final pairs = content.split(',');
    for (final pair in pairs) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        final key = parts[0].trim().replaceAll('"', '');
        final value = parts[1].trim().replaceAll('"', '');
        map[key] = value;
      }
    }
    return map;
  }
}
