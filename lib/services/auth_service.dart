import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';
  static const String _displayNameKey = 'displayName';

  Future<bool> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Support both old and new credentials as per previous context and new requirements
    if ((username == 'gerardo' && password == '2020') || 
        (username == 'Pera' && password == '12345')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_usernameKey, username);
      
      // If display name doesn't exist, use username as default
      if (prefs.getString(_displayNameKey) == null) {
        await prefs.setString(_displayNameKey, username);
      }
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    // We keep the username and display name for potential profile persistence
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<String?> getDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_displayNameKey) ?? prefs.getString(_usernameKey);
  }

  Future<void> updateDisplayName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_displayNameKey, name);
  }
}
