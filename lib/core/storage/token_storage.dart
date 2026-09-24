import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';
  static const String _roleKey = 'user_role';

  Future<void> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _tokenKey,
      token,
    );
  }

  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getString(_tokenKey);
  }

  Future<void> saveRole(String role) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _roleKey,
      role,
    );
  }

  Future<String?> getRole() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getString(_roleKey);
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_tokenKey);
    await preferences.remove(_roleKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();

    return token != null && token.isNotEmpty;
  }
}